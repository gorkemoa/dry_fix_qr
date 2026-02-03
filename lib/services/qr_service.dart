import '../core/network/api_client.dart';
import '../core/network/api_result.dart';
import '../core/network/api_exception.dart';
import '../app/api_constants.dart';
import '../models/qr_verify_response.dart';

class QrService {
  final ApiClient _apiClient;

  QrService(this._apiClient);

  Future<ApiResult<QrVerifyResponse>> verifyQr(String code) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.verifyQr,
        data: {'code': code},
      );

      final qrResponse = QrVerifyResponse.fromJson(response);
      return Success(qrResponse);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
