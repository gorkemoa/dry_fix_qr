import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/qr_verify_response.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../viewmodels/home_view_model.dart';
import '../../viewmodels/history_view_model.dart';

class QrSuccessView extends StatelessWidget {
  final QrVerifyResponse response;

  const QrSuccessView({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final earnedValue = response.earned ?? response.qr?.tokenValue ?? 0;
    final balanceValue = response.balance ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        color: AppColors.background,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: SizeTokens.p24),
                  child: Column(
                    children: [
                      SizedBox(height: SizeTokens.p32),

                      // Success Animation / Icon
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF10B981,
                                ).withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 90,
                              height: 90,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: SizeTokens.p24),

                      Text(
                        "İşlem Başarılı!",
                        style: TextStyle(
                          fontSize: SizeTokens.f24 * 1.1,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkBlue,
                        ),
                      ),

                      SizedBox(height: SizeTokens.p8),

                      Text(
                        response.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeTokens.f14,
                          color: AppColors.gray.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: SizeTokens.p32),

                      // Points Earned Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(SizeTokens.r24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(SizeTokens.p16),
                              child: Column(
                                children: [
                                  Text(
                                    "KAZANILAN DRYPARA",
                                    style: TextStyle(
                                      fontSize: SizeTokens.f12,
                                      color: AppColors.gray,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: SizeTokens.p12),
                                  Text(
                                    "+$earnedValue",
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF10B981),
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeTokens.p24,
                                vertical: SizeTokens.p20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Toplam Bakiyeniz",
                                    style: TextStyle(
                                      color: AppColors.gray,
                                      fontSize: SizeTokens.f14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "$balanceValue DP",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.darkBlue,
                                      fontSize: SizeTokens.f16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: SizeTokens.p20),

                      // Product Card
                      if (response.product != null)
                        InkWell(
                          onTap: () {
                            // Navigation can be added here if needed
                          },
                          borderRadius: BorderRadius.circular(SizeTokens.r24),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(SizeTokens.p16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                SizeTokens.r24,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(
                                      SizeTokens.r16,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      SizeTokens.r16,
                                    ),
                                    child: Image.network(
                                      response.product!.image,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Center(
                                                child: Icon(
                                                  Icons.format_paint,
                                                  color: AppColors.darkBlue,
                                                  size: 28,
                                                ),
                                              ),
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                SizedBox(width: SizeTokens.p16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Ürün Bilgisi",
                                        style: TextStyle(
                                          fontSize: SizeTokens.f12,
                                          color: AppColors.gray,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        response.product!.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.darkBlue,
                                          fontSize: SizeTokens.f14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: AppColors.gray.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ),

                      SizedBox(height: SizeTokens.p32),
                    ],
                  ),
                ),
              ),

              // Action Buttons
              Padding(
                padding: EdgeInsets.all(SizeTokens.p24),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<HomeViewModel>().init();
                      context.read<HistoryViewModel>().fetchHistory();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SizeTokens.r16),
                      ),
                      elevation: 4,
                      shadowColor: AppColors.darkBlue.withOpacity(0.3),
                    ),
                    child: Text(
                      "Ana Sayfaya Dön",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: SizeTokens.f16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
