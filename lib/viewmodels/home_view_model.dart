import 'package:flutter/foundation.dart';
import '../core/utils/logger.dart';

class HomeViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    Logger.info("HomeViewModel Initializing...");

    // Simulate API call for home data
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  void refresh() {
    init();
  }
}
