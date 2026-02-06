import 'package:dry_fix_qr/views/qr_scanner/qr_scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/qr_verify_response.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../viewmodels/home_view_model.dart';
import '../../viewmodels/history_view_model.dart';
import '../products/product_detail_view.dart';
import '../../models/product_model.dart';

class QrSuccessView extends StatelessWidget {
  final QrVerifyResponse response;

  const QrSuccessView({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final earnedValue = response.earned ?? response.qr?.tokenValue ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: SizeTokens.p24),
                child: Column(
                  children: [
                    // Mascot Character
                    Center(
                      child: Image.asset(
                        'assets/Adsız tasarım (10).png',
                        height: getProportionateScreenHeight(250),
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Title
                    Text(
                      "İşlem Başarılı !",
                      style: TextStyle(
                        fontSize: SizeTokens.f24 * 1.2,
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkBlue,
                      ),
                    ),

                    SizedBox(height: SizeTokens.p8),

                    // Subtitle
                    Text(
                      "QR doğrulandı, token yüklendi",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeTokens.f16,
                        color: AppColors.gray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: SizeTokens.p32),

                    // Main Info Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(SizeTokens.p24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(SizeTokens.r32),
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
                            "Kazanılan DryPara",
                            style: TextStyle(
                              fontSize: SizeTokens.f16,
                              color: AppColors.gray,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: SizeTokens.p8),
                          Text(
                            "+$earnedValue",
                            style: TextStyle(
                              fontSize: SizeTokens.f32 * 2,
                              fontWeight: FontWeight.w800,
                              color: const Color(
                                0xFF22C55E,
                              ), // Professional green
                            ),
                          ),
                          SizedBox(height: SizeTokens.p20),

                          // Product Info Indicator
                          if (response.product != null)
                            InkWell(
                              onTap: () {
                                final product = response.product!;
                                final productModel = ProductModel(
                                  id: product.id,
                                  name: product.name,
                                  description: '', // Missing in verify detail
                                  image: product.image,
                                  price: product.price,
                                  tokenPrice: product.tokenPrice,
                                  stock: product.stock,
                                  isActive: product.isActive,
                                  canBuy: true,
                                  createdAt: '',
                                  updatedAt: '',
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailView(
                                      product: productModel,
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(
                                SizeTokens.r20,
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(SizeTokens.p16),
                                decoration: BoxDecoration(
                                  color: AppColors.background.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(
                                    SizeTokens.r20,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          SizeTokens.r8,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(SizeTokens.p4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          SizeTokens.r4,
                                        ),
                                        child: Image.network(
                                          response.product!.image,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.format_paint,
                                                    color: AppColors.gray,
                                                    size: 20,
                                                  ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: SizeTokens.p12),
                                    Container(
                                      width: 2,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.gray.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(2),
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
                                      size: 20,
                                    ),
                                  ],
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

            // Navigation Buttons
            Padding(
              padding: EdgeInsets.all(SizeTokens.p24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Scan Again Button (Light Blue)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const QrScannerView(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF94B9F0,
                        ), // Lighter blue
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SizeTokens.r24),
                        ),
                      ),
                      child: Text(
                        "Tekrar Qr Tara",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: SizeTokens.f18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeTokens.p12),
                  // Return Home Button (Dark Blue)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<HomeViewModel>().init();
                        context.read<HistoryViewModel>().fetchHistory();
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SizeTokens.r24),
                        ),
                      ),
                      child: Text(
                        "Ana Sayfaya Dön",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: SizeTokens.f18,
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
    );
  }
}
