import '../core/network/api_client.dart';
import '../core/network/api_result.dart';
import '../core/network/api_exception.dart';
import '../core/storage/storage_manager.dart';
import '../app/api_constants.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<ApiResult<AuthResponse>> login(
    String identifier,
    String password,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {'identifier': identifier, 'password': password},
      );

      final authResponse = AuthResponse.fromJson(response);

      // Save token locally
      await StorageManager.saveToken(authResponse.token);

      // Set token in ApiClient for future requests
      _apiClient.setToken(authResponse.token);

      return Success(authResponse);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ApiResult<AuthResponse>> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response);

      // Save token locally
      await StorageManager.saveToken(authResponse.token);

      // Set token in ApiClient for future requests
      _apiClient.setToken(authResponse.token);

      return Success(authResponse);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ApiResult<MeResponse>> fetchMe() async {
    try {
      final response = await _apiClient.get(ApiConstants.me);
      final meResponse = MeResponse.fromJson(response);
      return Success(meResponse);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ApiResult<bool>> updatePassword(UpdatePasswordRequest request) async {
    try {
      await _apiClient.put(ApiConstants.updatePassword, data: request.toJson());
      return Success(true);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ApiResult<bool>> updateProfile(UpdateProfileRequest request) async {
    try {
      await _apiClient.put(ApiConstants.updateProfile, data: request.toJson());
      return Success(true);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ApiResult<bool>> deactivateAccount(String password) async {
    try {
      await _apiClient.post(
        ApiConstants.deactivate,
        data: {'password': password},
      );
      return Success(true);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<void> logout() async {
    await StorageManager.deleteToken();
    _apiClient.clearToken();
  }
}
