import '../core/network/api_client.dart';
import '../core/network/api_result.dart';
import '../core/network/api_exception.dart';
import '../app/api_constants.dart';
import '../models/notification_model.dart';

class NotificationApiService {
  final ApiClient _apiClient;

  NotificationApiService(this._apiClient);

  Future<ApiResult<NotificationResponse>> fetchNotifications({
    int page = 1,
    int perPage = 20,
    String status = 'sent',
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.notifications,
        queryParameters: {'page': page, 'per_page': perPage, 'status': status},
      );

      final notificationResponse = NotificationResponse.fromJson(response);
      return Success(notificationResponse);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ApiResult<NotificationItem>> fetchNotificationDetail(int id) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.notificationDetail(id),
      );

      final detailResponse = NotificationDetailResponse.fromJson(response);
      return Success(detailResponse.data);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
