import 'package:flutter/foundation.dart';
import '../core/network/api_result.dart';
import '../services/history_service.dart';
import '../models/history_model.dart';
import '../core/utils/logger.dart';

class HistoryViewModel extends ChangeNotifier {
  final HistoryService _historyService;

  HistoryViewModel(this._historyService);

  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  List<HistoryItem> _items = [];
  HistoryMeta? _meta;

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  List<HistoryItem> get items => _items;
  bool get hasMore => _meta != null && _meta!.currentPage < _meta!.lastPage;

  Future<void> fetchHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _historyService.fetchHistory(page: 1);

    if (result is Success<HistoryResponse>) {
      _items = result.data.data;
      _meta = result.data.meta;
      Logger.info("History fetched: ${_items.length} items");
    } else if (result is Failure<HistoryResponse>) {
      _errorMessage = result.errorMessage;
      Logger.error("History fetch failed", _errorMessage ?? "Unknown error");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    final nextPage = (_meta?.currentPage ?? 0) + 1;
    final result = await _historyService.fetchHistory(page: nextPage);

    if (result is Success<HistoryResponse>) {
      _items.addAll(result.data.data);
      _meta = result.data.meta;
      Logger.info("History LOAD MORE: ${_items.length} total items");
    } else if (result is Failure<HistoryResponse>) {
      _errorMessage = result.errorMessage;
      Logger.warning("History load more failed: $_errorMessage");
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> refresh() => fetchHistory();
}
