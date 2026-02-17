import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import '../core/utils/logger.dart';

class SplashViewModel extends ChangeNotifier {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  VideoPlayerController? get controller => _controller;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    Logger.info("SplashViewModel: Initializing video...");
    _controller = VideoPlayerController.asset("assets/splash.mp4");

    try {
      await _controller!.initialize();
      _isInitialized = true;
      _controller!.setLooping(false);
      _controller!.play();
      Logger.info("SplashViewModel: Video initialized and playing.");
    } catch (e) {
      Logger.error(
        "SplashViewModel: Video initialization failed",
        e.toString(),
      );
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
