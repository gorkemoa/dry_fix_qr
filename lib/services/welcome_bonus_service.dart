import '../core/network/api_client.dart';
import '../core/network/api_result.dart';
import '../core/network/api_exception.dart';
import '../app/api_constants.dart';
import '../core/utils/logger.dart';

class WelcomeBonusClaimResponse {
  final bool success;
  final String? message;

  WelcomeBonusClaimResponse({required this.success, this.message});

  factory WelcomeBonusClaimResponse.fromJson(Map<String, dynamic> json) {
    return WelcomeBonusClaimResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }
}

class WelcomeBonusService {
  final ApiClient _apiClient;

  WelcomeBonusService(this._apiClient);

  Future<ApiResult<WelcomeBonusClaimResponse>> claimWelcomeBonus() async {
    try {
      Logger.request('POST', ApiConstants.welcomeBonusClaim, null);
      final response = await _apiClient.post(
        ApiConstants.welcomeBonusClaim,
        data: {},
      );
      final result = WelcomeBonusClaimResponse.fromJson(response);
      Logger.response(ApiConstants.welcomeBonusClaim, response);
      return Success(result);
    } on ApiException catch (e) {
      Logger.error('WelcomeBonusService.claimWelcomeBonus failed', e.message);
      return Failure(e.message);
    } catch (e, st) {
      Logger.error('WelcomeBonusService.claimWelcomeBonus unexpected error', e.toString(), st);
      return Failure(e.toString());
    }
  }
}
