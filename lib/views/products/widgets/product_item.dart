import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';
import '../../../models/product_model.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductItem({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(SizeTokens.r16),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkBlue.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Product Image
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SizeTokens.r16),
                        topRight: Radius.circular(SizeTokens.r16),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SizeTokens.r16),
                        topRight: Radius.circular(SizeTokens.r16),
                      ),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.gray,
                            ),
                      ),
                    ),
                  ),
                  if (product.stock <= 5 && product.stock > 0)
                    Positioned(
                      top: SizeTokens.p8,
                      right: SizeTokens.p8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeTokens.p8,
                          vertical: SizeTokens.p4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(SizeTokens.r8),
                        ),
                        child: Text(
                          "Son ${product.stock}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeTokens.f12 * 0.8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (product.stock == 0)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SizeTokens.r16),
                            topRight: Radius.circular(SizeTokens.r16),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "TÜKENDİ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeTokens.f14,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Product Info
            Padding(
              padding: EdgeInsets.all(SizeTokens.p12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: SizeTokens.f14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBlue,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: SizeTokens.p4),
                  if (product.tokenPrice != 0) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.toll_outlined,
                          size: SizeTokens.p16,
                          color: AppColors.blue,
                        ),
                        SizedBox(width: SizeTokens.p4),
                        Text(
                          "${product.tokenPrice} DryPara",
                          style: TextStyle(
                            fontSize: SizeTokens.f14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeTokens.p4),
                  ],
                  if (product.price != "0.00")
                    Text(
                      "${product.price} ₺",
                      style: TextStyle(
                        fontSize: SizeTokens.f12,
                        color: AppColors.gray,
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
