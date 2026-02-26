import '../core/network/api_client.dart';
import '../core/network/api_result.dart';
import '../core/network/api_exception.dart';
import '../app/api_constants.dart';
import '../models/banner_model.dart';

class BannerService {
  final ApiClient _apiClient;

  BannerService(this._apiClient);

  Future<ApiResult<BannerResponse>> fetchBanners() async {
    try {
      final response = await _apiClient.get(ApiConstants.banners);
      final bannerResponse = BannerResponse.fromJson(response);
      return Success(bannerResponse);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
