import 'package:flutter/foundation.dart';
import 'dart:async';
import '../core/network/api_result.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';
import '../core/utils/logger.dart';
import '../services/order_service.dart';

enum ProductSortOrder { none, priceAsc, priceDesc, tokenAsc, tokenDesc }

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService;
  final OrderService _orderService;

  ProductViewModel(this._productService, this._orderService);

  bool _isLoading = false;
  // ... rest of the file
  bool _isLoadingMore = false;
  String? _errorMessage;
  List<ProductModel> _products = [];
  ProductMeta? _meta;

  // Cart State
  final List<ProductModel> _cart = [];

  // Search & Filters
  String _searchQuery = "";
  bool? _inStock;
  ProductSortOrder _sortOrder = ProductSortOrder.none;
  int? _selectedCategoryId;
  Timer? _debounce;

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _meta != null && _meta!.currentPage < _meta!.lastPage;
  String get searchQuery => _searchQuery;
  bool? get inStock => _inStock;
  ProductSortOrder get sortOrder => _sortOrder;
  int? get selectedCategoryId => _selectedCategoryId;

  List<ProductCategory> get availableCategories {
    final seen = <int>{};
    final categories = <ProductCategory>[];
    for (final p in _products) {
      if (p.category != null && seen.add(p.category!.id)) {
        categories.add(p.category!);
      }
    }
    return categories;
  }

  List<ProductModel> get products {
    final sorted = List<ProductModel>.from(_products);
    switch (_sortOrder) {
      case ProductSortOrder.priceAsc:
        sorted.sort(
          (a, b) => double.parse(a.price).compareTo(double.parse(b.price)),
        );
        break;
      case ProductSortOrder.priceDesc:
        sorted.sort(
          (a, b) => double.parse(b.price).compareTo(double.parse(a.price)),
        );
        break;
      case ProductSortOrder.tokenAsc:
        sorted.sort((a, b) => a.tokenPrice.compareTo(b.tokenPrice));
        break;
      case ProductSortOrder.tokenDesc:
        sorted.sort((a, b) => b.tokenPrice.compareTo(a.tokenPrice));
        break;
      case ProductSortOrder.none:
        break;
    }
    return sorted;
  }

  List<ProductModel> get cart => _cart;
  int get cartCount => _cart.length;
  double get cartTotalPrice =>
      _cart.fold(0, (sum, item) => sum + double.parse(item.price));
  int get cartTotalTokenPrice =>
      _cart.fold(0, (sum, item) => sum + item.tokenPrice);

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (!isRefresh) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    final result = await _productService.fetchProducts(
      page: 1,
      query: _searchQuery,
      inStock: _inStock,
      categoryId: _selectedCategoryId,
    );

    if (result is Success<ProductResponse>) {
      _products = result.data.data;
      _meta = result.data.meta;
      Logger.info("Products fetched: ${_products.length} items");
    } else if (result is Failure<ProductResponse>) {
      _errorMessage = result.errorMessage;
      Logger.error("Products fetch failed", _errorMessage ?? "Unknown error");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    final nextPage = (_meta?.currentPage ?? 0) + 1;
    final result = await _productService.fetchProducts(
      page: nextPage,
      query: _searchQuery,
      inStock: _inStock,
      categoryId: _selectedCategoryId,
    );

    if (result is Success<ProductResponse>) {
      _products.addAll(result.data.data);
      _meta = result.data.meta;
      Logger.info("Products LOAD MORE: ${_products.length} total items");
    } else if (result is Failure<ProductResponse>) {
      _errorMessage = result.errorMessage;
      Logger.warning("Products load more failed: $_errorMessage");
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;

    // Debounce search
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchProducts();
    });
  }

  void setInStockFilter(bool? value) {
    if (_inStock == value) return;
    _inStock = value;
    fetchProducts();
  }

  void setSortOrder(ProductSortOrder order) {
    if (_sortOrder == order) return;
    _sortOrder = order;
    notifyListeners();
  }

  void setCategory(int? categoryId) {
    if (_selectedCategoryId == categoryId) return;
    _selectedCategoryId = categoryId;
    fetchProducts();
  }

  void resetFilters() {
    _debounce?.cancel();
    _searchQuery = '';
    _sortOrder = ProductSortOrder.none;
    _inStock = null;
    _selectedCategoryId = null;
    // No notifyListeners() — called during deactivate (build phase).
    // initState will call fetchProducts() with clean state on next entry.
  }

  // Cart Methods
  void addToCart(ProductModel product) {
    // For now, simpler cart: allow multiples of same product
    _cart.add(product);
    notifyListeners();
    Logger.info("Added to cart: ${product.name}");
  }

  void removeFromCart(ProductModel product) {
    // Remove exactly one instance of this product (reference-based if same instance, otherwise finding first match by ID if we want that logic, but currently _cart holds instances)
    // To support + / - behavior with grouping:
    // If I have 3 "Product A" in list. I want to remove one.

    // If users tap "minus", we find first occurrence of this product ID and remove it.
    final index = _cart.indexWhere((element) => element.id == product.id);
    if (index != -1) {
      _cart.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  Future<void> refresh() => fetchProducts(isRefresh: true);

  Future<bool> completeOrder({
    required dynamic address,
    String? notes,
    Map<String, dynamic>? billing,
  }) async {
    if (_cart.isEmpty) return false;

    _isLoading = true;
    notifyListeners();

    final Map<int, int> quantities = {};
    for (var product in _cart) {
      quantities[product.id] = (quantities[product.id] ?? 0) + 1;
    }

    final List<Map<String, dynamic>> itemsPayload = quantities.entries
        .map((e) => {"product_id": e.key, "quantity": e.value})
        .toList();

    final Map<String, dynamic> addressPayload = {
      "title": address.title,
      "full_name": address.fullName,
      "phone": address.phone,
      "country": address.country ?? "TR",
      "city": address.city,
      "district": address.district,
      "neighborhood": address.neighborhood,
      "address_line1": address.addressLine1,
      "postal_code": address.postalCode ?? "",
    };

    final Map<String, dynamic> payload = {
      "items": itemsPayload,
      "address": addressPayload,
      "notes": notes,
      "billing": ?billing,
    };

    final result = await _orderService.createOrder(payload);

    _isLoading = false;
    if (result is Success) {
      _cart.clear();
      notifyListeners();
      return true;
    } else if (result is Failure) {
      _errorMessage = result.errorMessage;
      notifyListeners();
      return false;
    }
    notifyListeners();
    return false;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
