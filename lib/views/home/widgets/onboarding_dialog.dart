import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';
import '../../../core/widgets/dp_symbol.dart';

class OnboardingDialog extends StatelessWidget {
  const OnboardingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: SizeTokens.p24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeTokens.r32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mascot Header
              Padding(
                padding: EdgeInsets.all(SizeTokens.p32),
                child: Column(
                  children: [
                    Text(
                      "Hoş Geldin!",
                      style: TextStyle(
                        fontSize: SizeTokens.f24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeTokens.p16),
                    Text(
                      "DryFix dünyasına adım attın. İşte bilmen gerekenler:",
                      style: TextStyle(
                        fontSize: SizeTokens.f14,
                        color: AppColors.gray,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeTokens.p24),

                    // Feature 1
                    _buildFeatureItem(
                      icon: Icons.qr_code_scanner_rounded,
                      title: "QR Kod Tarat",
                      description:
                          "Ürünlerin üzerindeki QR kodları taratarak puan kazan.",
                    ),
                    SizedBox(height: SizeTokens.p20),

                    // Feature 2: Shopping
                    _buildFeatureItem(
                      icon: Icons.shopping_basket_outlined,
                      title: "Mağazada Harca",
                      description:
                          "Biriktirdiğin DryParaları mağazamızda dilediğince kullanabilirsin.",
                    ),
                    SizedBox(height: SizeTokens.p24),

                    // Feature 3: Highlighted DryPara Section
                    Container(
                      padding: EdgeInsets.all(SizeTokens.p20),
                      decoration: BoxDecoration(
                        color: AppColors.blue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(SizeTokens.r20),
                        border: Border.all(
                          color: AppColors.blue.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          const DpSymbol(size: 64, color: AppColors.blue),
                          SizedBox(height: SizeTokens.p12),
                          Text(
                            "DryPara Kazan",
                            style: TextStyle(
                              fontSize: SizeTokens.f18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBlue,
                            ),
                          ),
                          SizedBox(height: SizeTokens.p8),
                          Text(
                            "Kazandığın her puan DryPara'dır. Bu simgeyi gördüğün yerlerde kazancın seni bekliyor!",
                            style: TextStyle(
                              fontSize: SizeTokens.f12,
                              color: AppColors.gray,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: SizeTokens.p32),

                    // Dismiss Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(SizeTokens.r16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Hadi Başlayalım!",
                          style: TextStyle(
                            fontSize: SizeTokens.f16,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }

  Widget _buildFeatureItem({
    IconData? icon,
    Widget? customIcon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(SizeTokens.p10),
          child: customIcon ?? Icon(icon, color: AppColors.blue, size: 34),
        ),
        SizedBox(width: SizeTokens.p16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: SizeTokens.f16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
              SizedBox(height: SizeTokens.p4),
              Text(
                description,
                style: TextStyle(
                  fontSize: SizeTokens.f12,
                  color: AppColors.gray,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
