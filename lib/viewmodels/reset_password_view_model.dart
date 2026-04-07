import 'package:flutter/foundation.dart';
import '../core/network/api_result.dart';
import '../services/auth_service.dart';
import '../models/forgot_password_model.dart';
import '../core/utils/logger.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final AuthService _authService;

  ResetPasswordViewModel(this._authService);

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  String? get successMessage => _successMessage;

  void init() {
    _isLoading = false;
    _errorMessage = null;
    _isSuccess = false;
    _successMessage = null;
  }

  Future<bool> resetPassword({
    String? email,
    String? phone,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    final request = ResetPasswordRequest(
      email: email,
      phone: phone,
      code: code,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    final result = await _authService.resetPassword(request);

    if (result is Success<ResetPasswordResponse>) {
      _isSuccess = true;
      _successMessage = result.data.message;
      Logger.info('ResetPassword: Success. message=$_successMessage');
      _isLoading = false;
      notifyListeners();
      return true;
    } else if (result is Failure<ResetPasswordResponse>) {
      _errorMessage = result.errorMessage;
      Logger.warning('ResetPassword Failed: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void onRetry() {
    _errorMessage = null;
    notifyListeners();
  }
}
