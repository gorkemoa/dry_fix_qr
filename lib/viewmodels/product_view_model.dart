import 'package:flutter/foundation.dart';
import 'dart:async';
import '../core/network/api_result.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';
import '../core/utils/logger.dart';

import '../services/order_service.dart';

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
  Timer? _debounce;

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  List<ProductModel> get products => _products;
  bool get hasMore => _meta != null && _meta!.currentPage < _meta!.lastPage;
  String get searchQuery => _searchQuery;
  bool? get inStock => _inStock;

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
    required dynamic address, // Accepts Address model
    String? notes,
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
      "full_name": address.fullName,
      "phone": address.phone,
      "city": address.city,
      "district": address.district,
      "neighborhood": address.neighborhood,
      "address_line1": address.addressLine1,
      "address_line2": address.addressLine2,
      "postal_code": address.postalCode,
    };

    final Map<String, dynamic> payload = {
      "items": itemsPayload,
      "address": addressPayload,
      "notes": notes,
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
