import 'package:flutter/foundation.dart';
import '../core/network/api_result.dart';
import '../services/auth_service.dart';
import '../services/mobile_log_service.dart';
import '../models/user_model.dart';
import '../core/utils/logger.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService;
  final MobileLogService _mobileLogService;

  RegisterViewModel(this._authService, this._mobileLogService);

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  Future<bool> register(RegisterRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.register(request);

    bool success = false;
    if (result is Success<AuthResponse>) {
      _user = result.data.user;
      Logger.info("Register Success: User: ${_user?.name}");
      success = true;

      // Kayıt başarılı – cihaz/konum bilgilerini arka planda gönder (fire-and-forget)
      _mobileLogService.sendMobileLog(screen: 'register', action: 'register');
    } else if (result is Failure<AuthResponse>) {
      _errorMessage = result.errorMessage;
      Logger.warning("Register Failed: $_errorMessage");
      success = false;
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
