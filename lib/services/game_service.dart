import '../app/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/network/api_result.dart';
import '../core/network/api_exception.dart';
import '../core/utils/logger.dart';
import '../models/game_result_model.dart';

class GameService {
  final ApiClient _apiClient;

  GameService(this._apiClient);

  Future<ApiResult<GameResultModel>> finishMemoryMatch(
    GameResultRequest request,
  ) async {
    try {
      Logger.request('POST', ApiConstants.finishMemoryMatch, request.toJson());
      final response = await _apiClient.post(
        ApiConstants.finishMemoryMatch,
        data: request.toJson(),
      );
      Logger.response(ApiConstants.finishMemoryMatch, response);
      final model = GameResultModel.fromJson(response as Map<String, dynamic>);
      return Success(model);
    } on ApiException catch (e) {
      Logger.error('GameService.finishMemoryMatch failed', e.message);
      return Failure(e.message);
    } catch (e, st) {
      Logger.error(
        'GameService.finishMemoryMatch unexpected error',
        e.toString(),
        st,
      );
      return Failure(e.toString());
    }
  }
}
