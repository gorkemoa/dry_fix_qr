import 'package:flutter/foundation.dart';
import '../core/network/api_result.dart';
import '../services/support_service.dart';
import '../models/support_message_model.dart';
import '../core/utils/logger.dart';

class SupportViewModel extends ChangeNotifier {
  final SupportService _supportService;

  SupportViewModel(this._supportService);

  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  List<SupportMessage> _messages = [];
  int _currentPage = 1;
  bool _hasMore = true;

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  List<SupportMessage> get messages => _messages;
  bool get hasMore => _hasMore;

  Future<void> fetchMessages({int? userId, bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _isLoading = true;
    } else {
      if (!_hasMore || _isLoadingMore) return;
      _isLoadingMore = true;
    }

    _errorMessage = null;
    notifyListeners();

    final result = await _supportService.fetchSupportMessages(
      page: _currentPage,
      userId: userId,
    );

    if (result is Success<SupportMessageResponse>) {
      final paginationData = result.data.data;
      if (refresh) {
        _messages = paginationData.data;
      } else {
        _messages.addAll(paginationData.data);
      }

      _hasMore = paginationData.currentPage < paginationData.lastPage;
      if (_hasMore) {
        _currentPage++;
      }
      Logger.info("Support messages fetched. Count: ${_messages.length}");
    } else if (result is Failure<SupportMessageResponse>) {
      _errorMessage = result.errorMessage;
      Logger.error("Support messages fetch failed", _errorMessage ?? "");
    }

    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }

  Future<bool> createMessage({
    required String title,
    required String message,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _supportService.createSupportMessage(
      title: title,
      message: message,
    );

    bool success = false;
    if (result is Success<SupportMessage>) {
      _messages.insert(0, result.data);
      Logger.info("Support message created: ${result.data.id}");
      success = true;
    } else if (result is Failure<SupportMessage>) {
      _errorMessage = result.errorMessage;
      Logger.error("Support message creation failed", _errorMessage ?? "");
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
