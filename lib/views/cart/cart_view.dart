import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_tokens.dart';
import '../../viewmodels/product_view_model.dart';
import 'checkout_view.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductViewModel>();
    final cartItems = viewModel.cart;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Sepetim",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: () {
                // Show confirmation dialog before clearing
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Sepeti Boşalt"),
                    content: const Text(
                      "Tüm ürünleri sepetten çıkarmak istiyor musunuz?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text("İptal"),
                      ),
                      TextButton(
                        onPressed: () {
                          viewModel.clearCart();
                          Navigator.pop(ctx);
                        },
                        child: const Text("Evet, Boşalt"),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: SizeTokens.p64,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: SizeTokens.p16),
                  Text(
                    "Sepetiniz boş",
                    style: TextStyle(
                      fontSize: SizeTokens.f16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : Builder(
              builder: (context) {
                // Group items logic
                final Map<int, List<dynamic>> groupedItems = {};
                for (var item in cartItems) {
                  if (!groupedItems.containsKey(item.id)) {
                    groupedItems[item.id] = [];
                  }
                  groupedItems[item.id]!.add(item);
                }

                final uniqueItems = groupedItems.values
                    .map((list) => list.first)
                    .toList();

                return ListView.separated(
                  padding: EdgeInsets.all(SizeTokens.p16),
                  itemCount: uniqueItems.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: SizeTokens.p12),
                  itemBuilder: (context, index) {
                    final product = uniqueItems[index]; // First instance
                    final quantity = groupedItems[product.id]!.length;

                    return Container(
                      padding: EdgeInsets.all(SizeTokens.p12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(SizeTokens.r8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                SizeTokens.r8,
                              ),
                              border: Border.all(color: Colors.grey.shade100),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                product.image,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: SizeTokens.p12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: SizeTokens.f14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkBlue,
                                  ),
                                ),
                                SizedBox(height: SizeTokens.p4),
                                Row(
                                  children: [
                                    Text(
                                      "${product.price} TL",
                                      style: TextStyle(
                                        fontSize: SizeTokens.f14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blue,
                                      ),
                                    ),
                                    if (product.tokenPrice > 0)
                                      Text(
                                        " + ${product.tokenPrice} DP",
                                        style: TextStyle(
                                          fontSize: SizeTokens.f12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.darkBlue,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Quantity Controls
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.grey,
                                  size: 24,
                                ),
                                onPressed: () {
                                  viewModel.removeFromCart(product);
                                },
                                constraints: BoxConstraints(),
                                padding: EdgeInsets.all(4),
                              ),
                              Text(
                                "$quantity",
                                style: TextStyle(
                                  fontSize: SizeTokens.f16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkBlue,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: AppColors.blue,
                                  size: 24,
                                ),
                                onPressed: () {
                                  viewModel.addToCart(product);
                                },
                                constraints: BoxConstraints(),
                                padding: EdgeInsets.all(4),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Container(
              padding: EdgeInsets.all(SizeTokens.p16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Toplam Tutar",
                          style: TextStyle(
                            fontSize: SizeTokens.f14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${viewModel.cartTotalPrice.toStringAsFixed(2)} TL",
                              style: TextStyle(
                                fontSize: SizeTokens.f18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blue,
                              ),
                            ),
                            if (viewModel.cartTotalTokenPrice > 0)
                              Text(
                                "+ ${viewModel.cartTotalTokenPrice} DP",
                                style: TextStyle(
                                  fontSize: SizeTokens.f12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkBlue,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: SizeTokens.p16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CheckoutView(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(SizeTokens.r8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Siparişi Tamamla",
                          style: TextStyle(
                            fontSize: SizeTokens.f16,
                            fontWeight: FontWeight.bold,
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
}
