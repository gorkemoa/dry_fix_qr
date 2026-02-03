import '../core/network/api_client.dart';
import '../core/network/api_result.dart';
import '../core/network/api_exception.dart';
import '../app/api_constants.dart';
import '../models/history_model.dart';

class HistoryService {
  final ApiClient _apiClient;

  HistoryService(this._apiClient);

  Future<ApiResult<HistoryResponse>> fetchHistory({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.history,
        queryParameters: {'page': page, 'per_page': perPage},
      );

      final historyResponse = HistoryResponse.fromJson(response);
      return Success(historyResponse);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
