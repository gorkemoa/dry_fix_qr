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
    bool isStokta = product.stock > 0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(SizeTokens.p8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F5F7),
                    borderRadius: BorderRadius.circular(SizeTokens.r16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.inventory_2_outlined,
                      color: AppColors.gray.withOpacity(0.5),
                      size: 40,
                    ),
                  ),
                ),
                if (isStokta)
                  Positioned(
                    top: SizeTokens.p16,
                    right: SizeTokens.p16,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeTokens.p8,
                        vertical: SizeTokens.p4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(SizeTokens.p4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        "STOKTA",
                        style: TextStyle(
                          fontSize: SizeTokens.f10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue,
                        ),
                      ),
                    ),
                  )
                else
                  Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.all(SizeTokens.p8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(SizeTokens.r16),
                      ),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeTokens.p12,
                            vertical: SizeTokens.p6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(SizeTokens.r8),
                          ),
                          child: Text(
                            "TÜKENDİ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeTokens.f10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(
              SizeTokens.p12,
              0,
              SizeTokens.p12,
              SizeTokens.p12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: SizeTokens.f14 * 2.8, // 2 lines approx
                  child: Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: SizeTokens.f14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(height: SizeTokens.p8),
                Row(
                  children: [
                    Text(
                      "${product.tokenPrice} DryPara",
                      style: TextStyle(
                        fontSize: SizeTokens.f14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue,
                      ),
                    ),
                    if (product.price != "0.00" &&
                        double.parse(product.price) > product.tokenPrice) ...[
                      SizedBox(width: SizeTokens.p8),
                      Text(
                        "${product.price} TL",
                        style: TextStyle(
                          fontSize: SizeTokens.f11,
                          color: AppColors.gray.withOpacity(0.6),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: SizeTokens.p12),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: isStokta ? onTap : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SizeTokens.r8),
                      ),
                    ),
                    child: Text(
                      "Satın Al",
                      style: TextStyle(
                        fontSize: SizeTokens.f13,
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
    );
  }
}
