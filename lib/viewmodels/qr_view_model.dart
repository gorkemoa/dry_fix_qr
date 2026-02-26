import 'package:flutter/foundation.dart';
import '../core/network/api_result.dart';
import '../services/qr_service.dart';
import '../services/mobile_log_service.dart';
import '../models/qr_verify_response.dart';
import '../core/utils/logger.dart';

class QrViewModel extends ChangeNotifier {
  final QrService _qrService;
  final MobileLogService _mobileLogService;

  QrViewModel(this._qrService, this._mobileLogService);

  bool _isLoading = false;
  String? _errorMessage;
  QrVerifyResponse? _lastScanResult;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  QrVerifyResponse? get lastScanResult => _lastScanResult;

  Future<bool> verifyQr(String code) async {
    _isLoading = true;
    _errorMessage = null;
    _lastScanResult = null;
    notifyListeners();

    Logger.info("Verifying QR code: $code");
    final result = await _qrService.verifyQr(code);

    bool success = false;
    if (result is Success<QrVerifyResponse>) {
      _lastScanResult = result.data;
      if (!_lastScanResult!.success) {
        _errorMessage = _lastScanResult!.message;
      } else {
        success = true;
      }
      Logger.info("QR Verification Result: ${_lastScanResult?.result}");
      if (success) {
        // QR başarılı – cihaz/konum bilgilerini arka planda gönder (fire-and-forget)
        _mobileLogService.sendMobileLog(screen: 'qr', action: 'qr_scan');
      }
    } else if (result is Failure<QrVerifyResponse>) {
      _errorMessage = result.errorMessage;
      Logger.error("QR Verification Failed", _errorMessage ?? "Unknown error");
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _lastScanResult = null;
    notifyListeners();
  }
}
