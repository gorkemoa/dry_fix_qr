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
          border: Border.all(color: AppColors.darkBlue.withOpacity(0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: ClipRRect(
                      child: Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.inventory_2_outlined,
                              color: AppColors.gray,
                              size: 32,
                            ),
                      ),
                    ),
                  ),
                  if (product.stock <= 5 && product.stock > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade800,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Text(
                          "Son ${product.stock}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (product.stock == 0)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.vertical(),
                        ),
                        child: const Center(
                          child: Text(
                            "TÜKENDİ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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
                  SizedBox(
                    height: 40,
                    child: Text(
                      product.name,
                      style: TextStyle(
                        fontSize: SizeTokens.f14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkBlue,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (product.tokenPrice != 0)
                    Text(
                      "${product.tokenPrice} DryPara",
                      style: TextStyle(
                        fontSize: SizeTokens.f16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue,
                      ),
                    ),
                  if (product.price != "0.00")
                    Text(
                      "${product.price} DryPara",
                      style: TextStyle(
                        fontSize: SizeTokens.f12,
                        color: AppColors.gray,
                        decoration: product.tokenPrice != 0
                            ? TextDecoration.none
                            : TextDecoration.none,
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
