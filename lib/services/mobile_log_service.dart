import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:geolocator/geolocator.dart';

import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../app/api_constants.dart';
import '../core/utils/logger.dart';

/// Kayıt ya da uygulama açılışında cihaz & konum bilgilerini
/// backend'e raporlayan servis.
///
/// Hiçbir alan zorunlu değildir; erişilebilen bilgiler toplanır,
/// erişilemeyenler null olarak bırakılır.
class MobileLogService {
  final ApiClient _apiClient;

  MobileLogService(this._apiClient);

  /// Cihaz, uygulama ve konum bilgilerini toplayıp API'ye gönderir.
  /// Hata durumunda kullanıcıya bir şey yansıtmaz, sadece loglar.
  Future<void> sendMobileLog({
    String screen = 'register',
    String action = 'register',
  }) async {
    try {
      // ── Konum bilgisi ──
      double? lat;
      double? lng;
      try {
        final hasPermission = await _checkLocationPermission();
        if (hasPermission) {
          final position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.low,
              timeLimit: Duration(seconds: 5),
            ),
          );
          lat = position.latitude;
          lng = position.longitude;
          Logger.debug('Location fetched: lat=$lat, lng=$lng');
        } else {
          Logger.warning('Location permission not granted, skipping location.');
        }
      } catch (e) {
        Logger.warning('Could not fetch location: $e');
      }

      // ── Cihaz bilgisi ──
      String? os;
      String? osVersion;
      String? deviceModel;
      try {
        final deviceInfo = DeviceInfoPlugin();
        if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          os = 'ios';
          osVersion = iosInfo.systemVersion;
          deviceModel = iosInfo.utsname.machine;
        } else if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          os = 'android';
          osVersion = androidInfo.version.release;
          deviceModel = androidInfo.model;
        }
        Logger.debug(
          'Device info: os=$os, version=$osVersion, model=$deviceModel',
        );
      } catch (e) {
        Logger.warning('Could not fetch device info: $e');
      }

      // ── Uygulama bilgisi ──
      int? buildNumber;
      String? appVersion;
      try {
        final packageInfo = await PackageInfo.fromPlatform();
        buildNumber = int.tryParse(packageInfo.buildNumber);
        appVersion = packageInfo.version;
        Logger.debug('App info: version=$appVersion, build=$buildNumber');
      } catch (e) {
        Logger.warning('Could not fetch package info: $e');
      }

      // ── JSON body oluştur ──
      final Map<String, dynamic> jsonData = {
        'screen': screen,
        'action': action,
      };

      // Device bilgisi ekle
      final Map<String, dynamic> deviceData = {};
      if (os != null) deviceData['os'] = os;
      if (osVersion != null) deviceData['version'] = osVersion;
      if (deviceModel != null) deviceData['model'] = deviceModel;
      if (deviceData.isNotEmpty) jsonData['device'] = deviceData;

      // App bilgisi ekle
      final Map<String, dynamic> appData = {};
      if (buildNumber != null) appData['build'] = buildNumber;
      if (appVersion != null) appData['version'] = appVersion;
      if (appData.isNotEmpty) jsonData['app'] = appData;

      final Map<String, dynamic> body = {'json_data': jsonData};

      // Konum bilgisi ekle
      if (lat != null) body['lat'] = lat;
      if (lng != null) body['lng'] = lng;

      Logger.info('Sending mobile log: $body');

      await _apiClient.post(ApiConstants.mobileLogs, data: body);

      Logger.info('Mobile log sent successfully.');
    } on ApiException catch (e) {
      Logger.error('Mobile log API error', e.message);
    } catch (e, stackTrace) {
      Logger.error('Mobile log unexpected error', e.toString(), stackTrace);
    }
  }

  /// Konum izni kontrolü –
  /// İzin verilmemişse istemez, sadece mevcut duruma bakar.
  Future<bool> _checkLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }
}
