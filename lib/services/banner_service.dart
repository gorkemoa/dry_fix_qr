import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import '../core/network/api_client.dart';
import '../core/network/api_result.dart';
import '../core/network/api_exception.dart';
import '../app/api_constants.dart';
import '../core/utils/logger.dart';
import '../models/banner_model.dart';

class BannerService {
  final ApiClient _apiClient;

  BannerService(this._apiClient);

  Future<String> _getDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        final vendorId = info.identifierForVendor ?? '';
        if (vendorId.isNotEmpty) return 'ios-$vendorId';
        return 'ios-${info.utsname.machine}';
      } else if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        final androidId = info.id;
        if (androidId.isNotEmpty) return 'android-$androidId';
        return 'android-${info.model}';
      }
    } catch (e) {
      Logger.warning('BannerService: Could not get device id: $e');
    }
    return 'unknown-device';
  }

  Future<void> clickBanner(int bannerId) async {
    try {
      final deviceId = await _getDeviceId();
      await _apiClient.post(
        ApiConstants.bannerClick(bannerId),
        data: {'device_id': deviceId},
      );
      Logger.info('BannerService: click registered for banner id=$bannerId, device=$deviceId');
    } on ApiException catch (e) {
      Logger.error('BannerService: clickBanner API error', e.message);
    } catch (e) {
      Logger.error('BannerService: clickBanner error', e.toString());
    }
  }

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
