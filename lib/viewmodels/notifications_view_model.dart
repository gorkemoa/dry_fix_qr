import 'package:flutter/foundation.dart';
import '../core/network/api_result.dart';
import '../models/notification_model.dart';
import '../services/notification_api_service.dart';
import '../core/utils/logger.dart';

class NotificationsViewModel extends ChangeNotifier {
  final NotificationApiService _notificationApiService;

  NotificationsViewModel(this._notificationApiService);

  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  List<NotificationItem> _items = [];
  NotificationMeta? _meta;

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  List<NotificationItem> get items => _items;
  bool get hasMore => _meta != null && _meta!.currentPage < _meta!.lastPage;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _notificationApiService.fetchNotifications(page: 1);

    if (result is Success<NotificationResponse>) {
      _items = result.data.data;
      _meta = result.data.meta;
      Logger.info("Notifications fetched: ${_items.length} items");
    } else if (result is Failure<NotificationResponse>) {
      _errorMessage = result.errorMessage;
      Logger.error(
        "Notifications fetch failed",
        _errorMessage ?? "Unknown error",
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    final nextPage = (_meta?.currentPage ?? 0) + 1;
    final result = await _notificationApiService.fetchNotifications(
      page: nextPage,
    );

    if (result is Success<NotificationResponse>) {
      _items.addAll(result.data.data);
      _meta = result.data.meta;
      Logger.info("Notifications LOAD MORE: ${_items.length} total items");
    } else if (result is Failure<NotificationResponse>) {
      _errorMessage = result.errorMessage;
      Logger.warning("Notifications load more failed: $_errorMessage");
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> refresh() => fetchNotifications();
}
