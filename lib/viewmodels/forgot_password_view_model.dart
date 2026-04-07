import 'package:flutter/foundation.dart';
import '../core/network/api_result.dart';
import '../services/auth_service.dart';
import '../models/forgot_password_model.dart';
import '../core/utils/logger.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthService _authService;

  ForgotPasswordViewModel(this._authService);

  bool _isLoading = false;
  String? _errorMessage;
  ForgotPasswordResponse? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ForgotPasswordResponse? get response => _response;

  void init() {
    _isLoading = false;
    _errorMessage = null;
    _response = null;
  }

  Future<bool> sendResetCode({String? email, String? phone}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.forgotPassword(email: email, phone: phone);

    if (result is Success<ForgotPasswordResponse>) {
      _response = result.data;
      Logger.info('ForgotPassword: Code sent. emailHint=${_response?.emailHint}');
      _isLoading = false;
      notifyListeners();
      return true;
    } else if (result is Failure<ForgotPasswordResponse>) {
      _errorMessage = result.errorMessage;
      Logger.warning('ForgotPassword Failed: $_errorMessage');
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
