import 'package:flutter/foundation.dart';
import '../core/network/api_result.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';
import '../models/order_detail_model.dart';
import '../core/utils/logger.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderService _orderService;

  OrderViewModel(this._orderService);

  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  List<OrderModel> _orders = [];
  OrderMeta? _meta;

  OrderDetailResponse? _orderDetail;
  bool _isDetailLoading = false;

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isDetailLoading => _isDetailLoading;
  String? get errorMessage => _errorMessage;
  List<OrderModel> get orders => _orders;
  bool get hasMore => _meta != null && _meta!.currentPage < _meta!.lastPage;
  OrderDetailResponse? get orderDetail => _orderDetail;

  Future<void> fetchOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _orderService.fetchOrders(page: 1);

    if (result is Success<OrderResponse>) {
      _orders = result.data.data;
      _meta = result.data.meta;
      Logger.info("Orders fetched: ${_orders.length} items");
    } else if (result is Failure<OrderResponse>) {
      _errorMessage = result.errorMessage;
      Logger.error("Orders fetch failed", _errorMessage ?? "Unknown error");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchOrderDetail(int id) async {
    _isDetailLoading = true;
    _errorMessage = null;
    _orderDetail = null;
    notifyListeners();

    final result = await _orderService.fetchOrderDetail(id);

    if (result is Success<OrderDetailResponse>) {
      _orderDetail = result.data;
      Logger.info("Order detail fetched: $id");
    } else if (result is Failure<OrderDetailResponse>) {
      _errorMessage = result.errorMessage;
      Logger.error(
        "Order detail fetch failed",
        _errorMessage ?? "Unknown error",
      );
    }

    _isDetailLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    final nextPage = (_meta?.currentPage ?? 0) + 1;
    final result = await _orderService.fetchOrders(page: nextPage);

    if (result is Success<OrderResponse>) {
      _orders.addAll(result.data.data);
      _meta = result.data.meta;
      Logger.info("Orders LOAD MORE: ${_orders.length} total items");
    } else if (result is Failure<OrderResponse>) {
      _errorMessage = result.errorMessage;
      Logger.warning("Orders load more failed: $_errorMessage");
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> refresh() => fetchOrders();
}
