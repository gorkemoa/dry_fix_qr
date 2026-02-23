import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';
import '../../../core/widgets/dp_symbol.dart';
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isStokta ? onTap : null,
          borderRadius: BorderRadius.circular(SizeTokens.r20),
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
                    if (!isStokta)
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
                                borderRadius: BorderRadius.circular(
                                  SizeTokens.r8,
                                ),
                              ),
                              child: Text(
                                "STOKTA YOK",
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
                          "${product.tokenPrice}",
                          style: TextStyle(
                            fontSize: SizeTokens.f14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blue,
                          ),
                        ),
                        SizedBox(width: SizeTokens.p4),
                        DpSymbol(size: SizeTokens.p20, color: AppColors.blue),
                        if (product.price != "0.00" &&
                            double.parse(product.price) >
                                product.tokenPrice) ...[
                          SizedBox(width: SizeTokens.p8),
                          Text(
                            "${product.price}",
                            style: TextStyle(
                              fontSize: SizeTokens.f11,
                              color: AppColors.gray.withOpacity(0.6),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: SizeTokens.p2),
                          DpSymbol(
                            size: SizeTokens.p16,
                            color: AppColors.gray.withOpacity(0.6),
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
                          "Puan kullan",
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
        ),
      ),
    );
  }
}
