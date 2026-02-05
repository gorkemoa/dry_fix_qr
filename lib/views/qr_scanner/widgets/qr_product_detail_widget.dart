import 'package:flutter/material.dart';
import '../../../models/qr_verify_response.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';

class QrProductDetailWidget extends StatelessWidget {
  final ProductVerifyDetail product;

  const QrProductDetailWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.darkBlue,
            size: SizeTokens.p24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          product.name,
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: SizeTokens.f18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: SizeTokens.p100 * 3,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Hero(
                tag: 'product_${product.id}',
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.inventory_2_outlined,
                    size: SizeTokens.p100,
                    color: AppColors.gray,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(SizeTokens.p24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: TextStyle(
                            fontSize: SizeTokens.f24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeTokens.p12,
                          vertical: SizeTokens.p6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(SizeTokens.r20),
                        ),
                        child: Text(
                          "${product.tokenPrice} DP",
                          style: const TextStyle(
                            color: AppColors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeTokens.p16),
                  Text(
                    "Ürün Açıklaması",
                    style: TextStyle(
                      fontSize: SizeTokens.f18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  SizedBox(height: SizeTokens.p8),
                  Text(
                    "Bu ürün DryFix kalitesiyle üretilmiştir. QR kodunuzu okutarak kazandığınız DryParalar ile bu ürüne sahip olabilirsiniz.",
                    style: TextStyle(
                      fontSize: SizeTokens.f16,
                      color: AppColors.gray,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: SizeTokens.p32),
                  SizedBox(
                    width: double.infinity,
                    height: SizeTokens.p50 + SizeTokens.p6,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Purchase
                      },
                      child: const Text("Hemen Satın Al"),
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
