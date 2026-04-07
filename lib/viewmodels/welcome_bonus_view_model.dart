import 'package:flutter/foundation.dart';
import '../core/network/api_result.dart';
import '../services/welcome_bonus_service.dart';
import '../core/utils/logger.dart';

class WelcomeBonusViewModel extends ChangeNotifier {
  final WelcomeBonusService _welcomeBonusService;

  WelcomeBonusViewModel(this._welcomeBonusService);

  bool _isLoading = false;
  bool _isClaimed = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isClaimed => _isClaimed;
  String? get errorMessage => _errorMessage;

  Future<bool> claimBonus() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    Logger.info('WelcomeBonusViewModel: claiming welcome bonus...');

    final result = await _welcomeBonusService.claimWelcomeBonus();

    if (result is Success<WelcomeBonusClaimResponse>) {
      _isClaimed = true;
      Logger.info('WelcomeBonusViewModel: bonus claimed successfully');
      _isLoading = false;
      notifyListeners();
      return true;
    } else if (result is Failure<WelcomeBonusClaimResponse>) {
      _errorMessage = result.errorMessage;
      Logger.error('WelcomeBonusViewModel: claim failed', _errorMessage ?? '');
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
