import 'package:flutter/foundation.dart';
import '../core/network/api_result.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../core/utils/logger.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;

  LoginViewModel(this._authService);

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  Future<void> login(String identifier, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.login(identifier, password);

    if (result is Success<AuthResponse>) {
      _user = result.data.user;
      Logger.info("Login Success: User: ${_user?.name}");
    } else if (result is Failure<AuthResponse>) {
      _errorMessage = result.errorMessage;
      Logger.warning("Login Failed: $_errorMessage");
    }

    _isLoading = false;
    notifyListeners();
  }
}
