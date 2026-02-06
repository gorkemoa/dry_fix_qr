import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_tokens.dart';
import '../../models/product_model.dart';
import '../../viewmodels/product_view_model.dart';
import '../cart/checkout_view.dart';

class ProductDetailView extends StatelessWidget {
  final ProductModel product;

  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              SizeTokens.p24,
              MediaQuery.of(context).padding.top + SizeTokens.p16,
              SizeTokens.p24,
              SizeTokens.p100 + SizeTokens.p24, // Space for bottom bar
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image with Rounded Corners
                Container(
                  height: 350, // Fixed height for hero image look
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SizeTokens.r24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(SizeTokens.r24),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey,
                              size: SizeTokens.p64,
                            ),
                          ),
                        ),
                        // Dark gradient overlay for better text contrast if we put text on image,
                        // but here we just want the image clean.
                      ],
                    ),
                  ),
                ),
                SizedBox(height: SizeTokens.p24),

                // Title
                Text(
                  product.name,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: SizeTokens.f24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                SizedBox(height: SizeTokens.p8),

                // Price Section (Placed near title for emphasis)
                Row(
                  children: [
                    Text(
                      "${product.price} TL",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: SizeTokens.f20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue,
                      ),
                    ),
                    if (product.tokenPrice > 0) ...[
                      SizedBox(width: SizeTokens.p8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeTokens.p8,
                          vertical: SizeTokens.p4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.darkBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(SizeTokens.r8),
                        ),
                        child: Text(
                          "+${product.tokenPrice} DP",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: SizeTokens.f12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkBlue,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: SizeTokens.p24),

                // Description Title
                Text(
                  "Açıklama", // "Description"
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: SizeTokens.f18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                SizedBox(height: SizeTokens.p12),

                // Description Text
                Text(
                  product.description,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: SizeTokens.f14,
                    color: AppColors.gray,
                    height: 1.6,
                  ),
                ),

                // Gallery Section Placeholder (mimicking the style)
                SizedBox(height: SizeTokens.p24),
                Text(
                  "Galeri",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: SizeTokens.f18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                SizedBox(height: SizeTokens.p12),
                Row(
                  children: [
                    // Just showing the main image as a thumbnail to mimic the gallery view
                    _buildGalleryThumb(product.image),
                    SizedBox(width: SizeTokens.p12),
                    _buildGalleryThumb(product.image, opacity: 0.5),
                    SizedBox(width: SizeTokens.p12),
                    _buildGalleryThumb(
                      product.image,
                      opacity: 0.5,
                      showPlus: true,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Floating Top Bar Buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + SizeTokens.p24,
            left: SizeTokens.p32, // Indent inside the image area
            right: SizeTokens.p32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.pop(context),
                ),
                _buildCircularButton(
                  icon: Icons.share_outlined,
                  onTap: () {
                    // Placeholder for share functionality
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(SizeTokens.p24),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: product.canBuy && product.stock > 0
                        ? () {
                            final viewModel = context.read<ProductViewModel>();
                            viewModel.addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Ürün sepete eklendi"),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue, // Secondary Color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SizeTokens.r16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Sepete Ekle",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: SizeTokens.f16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: SizeTokens.p16),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: product.canBuy && product.stock > 0
                        ? () {
                            final viewModel = context.read<ProductViewModel>();
                            viewModel.addToCart(product);
                            // Navigate to checkout
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CheckoutView(),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkBlue, // Primary Color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SizeTokens.r16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      product.stock <= 0 ? "Stokta Yok" : "Hemen Al",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: SizeTokens.f16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.4), // Semi-transparent grey
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildGalleryThumb(
    String imageUrl, {
    double opacity = 1.0,
    bool showPlus = false,
  }) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeTokens.r16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: opacity < 1.0
              ? ColorFilter.mode(
                  Colors.white.withOpacity(0.6),
                  BlendMode.lighten,
                )
              : null,
        ),
      ),
      child: showPlus
          ? Center(
              child: Text(
                "+5",
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeTokens.f16,
                ),
              ),
            )
          : null,
    );
  }
}
