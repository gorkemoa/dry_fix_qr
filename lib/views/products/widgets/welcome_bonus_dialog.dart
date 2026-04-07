import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_config.dart';
import '../../../core/responsive/size_tokens.dart';
import '../../../core/widgets/dp_symbol.dart';
import '../../../viewmodels/welcome_bonus_view_model.dart';
import '../../../viewmodels/home_view_model.dart';

class WelcomeBonusDialog extends StatefulWidget {
  const WelcomeBonusDialog({super.key});

  @override
  State<WelcomeBonusDialog> createState() => _WelcomeBonusDialogState();
}

class _WelcomeBonusDialogState extends State<WelcomeBonusDialog>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 4));
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _scaleController.forward();
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Path _drawStar(Size size) {
    final path = Path();
    const int points = 5;
    final double angle = (2 * pi) / points;
    final double halfAngle = angle / 2;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = size.width / 2;
    final innerR = outerR * 0.4;
    for (int i = 0; i < points; i++) {
      final x1 = cx + outerR * cos(i * angle - pi / 2);
      final y1 = cy + outerR * sin(i * angle - pi / 2);
      final x2 = cx + innerR * cos(i * angle + halfAngle - pi / 2);
      final y2 = cy + innerR * sin(i * angle + halfAngle - pi / 2);
      if (i == 0) {
        path.moveTo(x1, y1);
      } else {
        path.lineTo(x1, y1);
      }
      path.lineTo(x2, y2);
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = context.watch<WelcomeBonusViewModel>();

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // ── Confetti ──────────────────────────────────────────────
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 35,
            gravity: 0.22,
            emissionFrequency: 0.04,
            colors: const [
              Color(0xFF002452),
              Color(0xFF0094BF),
              Color(0xFFFFD700),
              Color(0xFFFF6B6B),
              Color(0xFF4ECDC4),
              Color(0xFFFFFFFF),
            ],
            createParticlePath: _drawStar,
          ),
        ),

        // ── Dialog ────────────────────────────────────────────────
        ScaleTransition(
          scale: _scaleAnimation,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(horizontal: SizeTokens.p16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeTokens.r24),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: AppColors.darkBlue.withOpacity(0.25),
                    blurRadius: 40,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(SizeTokens.r24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── HEADER: mascot bölümü ──────────────────────
                    Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        // Gradient arka plan
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF001A3A), Color(0xFF003D8F)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          height: SizeTokens.p240,
                        ),
                        // Büyük dekoratif daire – sol üst
                        Positioned(
                          left: -SizeTokens.p40,
                          top: -SizeTokens.p40,
                          child: Container(
                            width: SizeTokens.p200,
                            height: SizeTokens.p200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white
                                  // ignore: deprecated_member_use
                                  .withOpacity(0.05),
                            ),
                          ),
                        ),
                        // Orta daire – sağ alt
                        Positioned(
                          right: -SizeTokens.p32,
                          bottom: -SizeTokens.p32,
                          child: Container(
                            width: SizeTokens.p145,
                            height: SizeTokens.p145,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white
                                  // ignore: deprecated_member_use
                                  .withOpacity(0.05),
                            ),
                          ),
                        ),
                        // Küçük altın nokta
                        Positioned(
                          right: SizeTokens.p32,
                          top: SizeTokens.p24,
                          child: Container(
                            width: SizeTokens.p12,
                            height: SizeTokens.p12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFFD700)
                                  // ignore: deprecated_member_use
                                  .withOpacity(0.7),
                            ),
                          ),
                        ),
                        // Küçük mavi nokta
                        Positioned(
                          left: SizeTokens.p24,
                          bottom: SizeTokens.p32,
                          child: Container(
                            width: SizeTokens.p8,
                            height: SizeTokens.p8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF0094BF)
                                  // ignore: deprecated_member_use
                                  .withOpacity(0.8),
                            ),
                          ),
                        ),
                        // Maskot + başlık
                        Positioned.fill(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/hosgeldinbonus.png',
                                height: SizeTokens.p145,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: SizeTokens.p12),
                              Text(
                                '🎉 Hoş Geldin!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeTokens.f20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.3,
                                ),
                              ),
                              SizedBox(height: SizeTokens.p4),
                              Text(
                                'Sana özel bir sürpriz hazırladık',
                                style: TextStyle(
                                  // ignore: deprecated_member_use
                                  color: Colors.white.withOpacity(0.72),
                                  fontSize: SizeTokens.f13,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // ── BODY: ödül + buton ─────────────────────────
                    Container(
                      color: AppColors.white,
                      padding: EdgeInsets.fromLTRB(
                        SizeTokens.p24,
                        SizeTokens.p24,
                        SizeTokens.p24,
                        SizeTokens.p20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Shimmer ödül badge
                          AnimatedBuilder(
                            animation: _shimmerController,
                            builder: (context, child) {
                              return Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: SizeTokens.p14,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(SizeTokens.r16),
                                  gradient: LinearGradient(
                                    colors: const [
                                      Color(0xFFF0F5FF),
                                      Color(0xFFD6E6FF),
                                      Color(0xFFF0F5FF),
                                    ],
                                    stops: [
                                      (_shimmerController.value - 0.3)
                                          .clamp(0.0, 1.0),
                                      _shimmerController.value
                                          .clamp(0.0, 1.0),
                                      (_shimmerController.value + 0.3)
                                          .clamp(0.0, 1.0),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFF0094BF)
                                        // ignore: deprecated_member_use
                                        .withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: child,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '+ 1.000 ',
                                  style: TextStyle(
                                    color: AppColors.darkBlue,
                                    fontSize: SizeTokens.f24,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                DpSymbol(
                                  size: SizeTokens.p32,
                                  color: AppColors.darkBlue,
                                ),
                                SizedBox(width: SizeTokens.p8),
                                Text(
                                  'DryPara',
                                  style: TextStyle(
                                    color: AppColors.darkBlue,
                                    fontSize: SizeTokens.f16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: SizeTokens.p16),

                          Text(
                            'Mağazamıza ilk girişine özel 1.000 DryPara seni bekliyor. Hemen cüzdanına ekle, dilediğin ürünlerde kullan!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.gray,
                              fontSize: SizeTokens.f13,
                              height: 1.55,
                              fontFamily: 'Inter',
                            ),
                          ),

                          SizedBox(height: SizeTokens.p24),

                          if (viewModel.errorMessage != null)
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: SizeTokens.p12),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(SizeTokens.p12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius:
                                      BorderRadius.circular(SizeTokens.r8),
                                  border: Border.all(
                                    color: Colors.red.shade200,
                                  ),
                                ),
                                child: Text(
                                  viewModel.errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: SizeTokens.f12,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ),

                          // Cüzdana Ekle butonu
                          SizedBox(
                            width: double.infinity,
                            height: SizeTokens.p56,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF002452),
                                    Color(0xFF0056A0)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius:
                                    BorderRadius.circular(SizeTokens.r16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF002452)
                                        // ignore: deprecated_member_use
                                        .withOpacity(0.35),
                                    blurRadius: 14,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: viewModel.isLoading
                                    ? null
                                    : () async {
                                        final success =
                                            await viewModel.claimBonus();
                                        if (success && context.mounted) {
                                          context.read<HomeViewModel>().init();
                                          Navigator.of(context).pop();
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: AppColors.white,
                                  disabledBackgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(SizeTokens.r16),
                                  ),
                                  elevation: 0,
                                ),
                                child: viewModel.isLoading
                                    ? SizedBox(
                                        width: SizeTokens.p24,
                                        height: SizeTokens.p24,
                                        child: CircularProgressIndicator(
                                          color: AppColors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons
                                                .account_balance_wallet_rounded,
                                            size: SizeTokens.p20,
                                            color: AppColors.white,
                                          ),
                                          SizedBox(width: SizeTokens.p8),
                                          Text(
                                            'Cüzdana Ekle',
                                            style: TextStyle(
                                              fontSize: SizeTokens.f16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),

                          SizedBox(height: SizeTokens.p8),

                          TextButton(
                            onPressed: viewModel.isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.gray,
                            ),
                            child: Text(
                              'Şimdi değil',
                              style: TextStyle(
                                color: AppColors.gray,
                                fontSize: SizeTokens.f13,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
