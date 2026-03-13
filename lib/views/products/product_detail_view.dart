import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_tokens.dart';
import '../../core/widgets/dp_symbol.dart';
import '../../models/product_model.dart';
import '../../viewmodels/product_view_model.dart';
import '../cart/checkout_view.dart';

class ProductDetailView extends StatefulWidget {
  final ProductModel product;

  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
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
                // Hero Image
                Container(
                  height: 400,
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
                    child: InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 4.0,
                      child: Image.network(
                        widget.product.image,
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
                    ),
                  ),
                ),
                SizedBox(height: SizeTokens.p24),

                // Title
                Text(
                  widget.product.name,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: SizeTokens.f24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                SizedBox(height: SizeTokens.p8),

                // Price Section
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeTokens.p8,
                        vertical: SizeTokens.p4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(SizeTokens.r8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${widget.product.tokenPrice} ",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: SizeTokens.f20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blue,
                            ),
                          ),
                          DpSymbol(size: SizeTokens.p32, color: AppColors.blue),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeTokens.p24),

                // Description Title
                Text(
                  "Açıklama",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: SizeTokens.f18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                SizedBox(height: SizeTokens.p12),

                // Description Text
                if (widget.product.description != null)
                Text(
                  widget.product.description!,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: SizeTokens.f14,
                    color: AppColors.gray,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          // Floating Top Bar Buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + SizeTokens.p24,
            left: SizeTokens.p32,
            right: SizeTokens.p32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.pop(context),
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
                    onPressed: widget.product.canBuy && widget.product.stock > 0
                        ? () {
                            final viewModel = context.read<ProductViewModel>();
                            viewModel.addToCart(widget.product);
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
                      backgroundColor: AppColors.blue,
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
                    onPressed: widget.product.canBuy && widget.product.stock > 0
                        ? () {
                            final viewModel = context.read<ProductViewModel>();
                            viewModel.addToCart(widget.product);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CheckoutView(),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SizeTokens.r16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      widget.product.stock <= 0 ? "Stokta Yok" : "Hemen Al",
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
          color: Colors.black.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
