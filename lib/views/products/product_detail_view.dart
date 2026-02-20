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
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
                // Hero Image Slider
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 400, // Slightly taller for slider
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
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemCount: widget.product.images.length,
                          itemBuilder: (context, index) {
                            return InteractiveViewer(
                              minScale: 1.0,
                              maxScale: 4.0,
                              child: Image.network(
                                widget.product.images[index],
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
                            );
                          },
                        ),
                      ),
                    ),
                    // Image Indicators
                    if (widget.product.images.length > 1)
                      Padding(
                        padding: EdgeInsets.only(bottom: SizeTokens.p16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.product.images.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: _currentPage == index ? 24 : 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? AppColors.blue
                                    : Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
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
                Text(
                  widget.product.description,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: SizeTokens.f14,
                    color: AppColors.gray,
                    height: 1.6,
                  ),
                ),

                // Gallery Section
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
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.product.images.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(width: SizeTokens.p12),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: _buildGalleryThumb(
                          widget.product.images[index],
                          isActive: _currentPage == index,
                        ),
                      );
                    },
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

  Widget _buildGalleryThumb(String imageUrl, {bool isActive = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeTokens.r16),
        border: Border.all(
          color: isActive ? AppColors.blue : Colors.transparent,
          width: 2,
        ),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
