import 'package:flutter/foundation.dart';
import 'dart:async';
import '../core/network/api_result.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';
import '../core/utils/logger.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService;

  ProductViewModel(this._productService);

  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  List<ProductModel> _products = [];
  ProductMeta? _meta;

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

  Future<void> refresh() => fetchProducts(isRefresh: true);

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
