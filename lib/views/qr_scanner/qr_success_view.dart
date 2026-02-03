import 'package:flutter/material.dart';
import '../../models/qr_verify_response.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';

class QrSuccessView extends StatelessWidget {
  final QrVerifyResponse response;

  const QrSuccessView({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.withOpacity(0.1), AppColors.background],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(SizeTokens.p24),
            child: Column(
              children: [
                SizedBox(height: SizeTokens.p32),

                // Success Animation / Icon
                Container(
                  padding: EdgeInsets.all(SizeTokens.p32),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.green.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: SizeTokens.p32 * 3,
                  ),
                ),

                SizedBox(height: SizeTokens.p24),

                Text(
                  "Başarılı!",
                  style: TextStyle(
                    fontSize: SizeTokens.f24 * 1.2,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                    letterSpacing: 1.2,
                  ),
                ),

                SizedBox(height: SizeTokens.p8),

                Text(
                  response.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeTokens.f16,
                    color: AppColors.gray,
                  ),
                ),

                SizedBox(height: SizeTokens.p32),

                // Points Earned Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(SizeTokens.p24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SizeTokens.r20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Kazanılan Puan",
                        style: TextStyle(
                          fontSize: SizeTokens.f14,
                          color: AppColors.gray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: SizeTokens.p8),
                      Text(
                        "+${response.earned ?? response.qr?.tokenValue ?? 0}",
                        style: TextStyle(
                          fontSize: SizeTokens.f32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blue,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Yeni Bakiyeniz",
                            style: TextStyle(color: AppColors.gray),
                          ),
                          Text(
                            "${response.balance ?? '---'} Puan",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: SizeTokens.p24),

                // Product Card
                if (response.product != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(SizeTokens.p16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(SizeTokens.r20),
                      border: Border.all(
                        color: AppColors.blue.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(SizeTokens.r12),
                          child: Image.network(
                            response.product!.image,
                            width: SizeTokens.p32 * 2.5,
                            height: SizeTokens.p32 * 2.5,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: SizeTokens.p32 * 2.5,
                              height: SizeTokens.p32 * 2.5,
                              color: AppColors.background,
                              child: const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        SizedBox(width: SizeTokens.p16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ürün Bilgisi",
                                style: TextStyle(
                                  fontSize: SizeTokens.f12,
                                  color: AppColors.gray,
                                ),
                              ),
                              SizedBox(height: SizeTokens.p4),
                              Text(
                                response.product!.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkBlue,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: SizeTokens.p32 * 1.5),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SizeTokens.r12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Ana Sayfaya Dön",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                SizedBox(height: SizeTokens.p16),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.blue, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SizeTokens.r12),
                      ),
                    ),
                    child: const Text(
                      "Yeni QR Tara",
                      style: TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: SizeTokens.p32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
