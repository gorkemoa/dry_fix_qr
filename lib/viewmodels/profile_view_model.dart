import 'package:flutter/foundation.dart';
import '../core/network/api_result.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../core/utils/logger.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthService _authService;

  ProfileViewModel(this._authService);

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  User? get user => _user;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.fetchMe();

    if (result is Success<MeResponse>) {
      _user = result.data.user;
      Logger.info("Profile fetched successfully: ${_user?.name}");
    } else if (result is Failure<MeResponse>) {
      _errorMessage = result.errorMessage;
      Logger.error("Profile fetch failed", _errorMessage ?? "Unknown error");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(UpdateProfileRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    final result = await _authService.updateProfile(request);

    if (result is Success<bool>) {
      _isSuccess = true;
      Logger.info("Profile updated successfully");
      await fetchProfile(); // Refresh profile after update
    } else if (result is Failure<bool>) {
      _errorMessage = result.errorMessage;
      Logger.error("Profile update failed", _errorMessage ?? "Unknown error");
    }

    _isLoading = false;
    notifyListeners();
  }
}
