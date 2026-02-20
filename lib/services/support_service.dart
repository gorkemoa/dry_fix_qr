import '../core/network/api_client.dart';
import '../core/network/api_result.dart';
import '../core/network/api_exception.dart';
import '../app/api_constants.dart';
import '../models/support_message_model.dart';

class SupportService {
  final ApiClient _apiClient;

  SupportService(this._apiClient);

  Future<ApiResult<SupportMessageResponse>> fetchSupportMessages({
    int page = 1,
    int perPage = 20,
    int? userId,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'per_page': perPage,
      };
      if (userId != null) {
        queryParams['user_id'] = userId;
      }

      final response = await _apiClient.get(
        ApiConstants.supportMessages,
        queryParameters: queryParams,
      );

      final supportResponse = SupportMessageResponse.fromJson(response);
      return Success(supportResponse);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ApiResult<SupportMessageDetailResponse>> fetchSupportMessageDetail(
    int id,
  ) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.supportMessageDetail(id),
      );
      final detailResponse = SupportMessageDetailResponse.fromJson(response);
      return Success(detailResponse);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ApiResult<SupportMessage>> createSupportMessage({
    required String title,
    required String message,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.supportMessages,
        data: {'title': title, 'message': message},
      );

      final detailResponse = SupportMessageDetailResponse.fromJson(response);
      return Success(detailResponse.data);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
