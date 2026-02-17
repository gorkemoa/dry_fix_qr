import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/splash_view_model.dart';

class SplashView extends StatefulWidget {
  final Widget destination;
  const SplashView({super.key, required this.destination});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<SplashViewModel>();
      viewModel.init().then((_) {
        viewModel.controller?.addListener(() {
          if (viewModel.controller != null &&
              viewModel.controller!.value.position >=
                  viewModel.controller!.value.duration) {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => widget.destination),
              );
            }
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Responsive ölçüler için SizeConfig başlatılıyor
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Consumer<SplashViewModel>(
        builder: (context, viewModel, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Video Oynatıcı Alanı
                if (viewModel.isInitialized && viewModel.controller != null)
                  Container(
                    width: SizeConfig.screenWidth * 0.85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SizeTokens.r20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: AspectRatio(
                      aspectRatio: viewModel.controller!.value.aspectRatio,
                      child: VideoPlayer(viewModel.controller!),
                    ),
                  )
                else
                  SizedBox(
                    height: SizeConfig.screenWidth * 0.85,
                    width: SizeConfig.screenWidth * 0.85,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.darkBlue,
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: SizeTokens.p48),

                // Hoşgeldiniz Metni
                Text(
                  "Hoşgeldiniz",
                  style: TextStyle(
                    fontSize: SizeTokens.f24,
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),

                SizedBox(height: SizeTokens.p32),

                // Yükleme Göstergesi (Dönme şeyi)
                const CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
