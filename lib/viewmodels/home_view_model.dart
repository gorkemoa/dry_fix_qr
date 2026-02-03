import 'package:flutter/foundation.dart';
import '../core/utils/logger.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../core/network/api_result.dart';

class HomeViewModel extends ChangeNotifier {
  final AuthService _authService;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  HomeViewModel(this._authService);

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> init() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    Logger.info("HomeViewModel Initializing (fetchMe)...");

    final result = await _authService.fetchMe();

    if (result is Success<MeResponse>) {
      _user = result.data.user;
      Logger.info("HomeViewModel: User data fetched: ${_user?.name}");
    } else if (result is Failure<MeResponse>) {
      _errorMessage = result.errorMessage;
      Logger.error("HomeViewModel: Fetch me failed", _errorMessage ?? '');
    }

    _isLoading = false;
    notifyListeners();
  }

  void refresh() {
    init();
  }
}
