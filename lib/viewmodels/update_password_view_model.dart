import 'package:flutter/foundation.dart';
import '../core/network/api_result.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../core/utils/logger.dart';

class UpdatePasswordViewModel extends ChangeNotifier {
  final AuthService _authService;

  UpdatePasswordViewModel(this._authService);

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  Future<void> updatePassword(UpdatePasswordRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    final result = await _authService.updatePassword(request);

    if (result is Success<bool>) {
      _isSuccess = true;
      Logger.info("Password updated successfully");
    } else if (result is Failure<bool>) {
      _errorMessage = result.errorMessage;
      Logger.error("Password update failed", _errorMessage ?? "Unknown error");
    }

    _isLoading = false;
    notifyListeners();
  }

  void resetState() {
    _isSuccess = false;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
