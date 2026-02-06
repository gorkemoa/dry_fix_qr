import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/product_view_model.dart';
import '../../viewmodels/home_view_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import 'widgets/product_item.dart';
import 'product_detail_view.dart';
import '../cart/cart_view.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().fetchProducts();
      context.read<HomeViewModel>().init();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductViewModel>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = context.watch<ProductViewModel>();
    final homeViewModel = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.white,
            size: SizeTokens.p24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "DryPara Mağazası",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: SizeTokens.p16),
            padding: EdgeInsets.symmetric(
              horizontal: SizeTokens.p12,
              vertical: SizeTokens.p6,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.white,
                  size: SizeTokens.f16,
                ),
                SizedBox(width: SizeTokens.p8),
                Text(
                  "${homeViewModel.user?.tokenBalance ?? 0} DP",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: SizeTokens.f13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartView()),
          );
        },
        backgroundColor: AppColors.darkBlue,
        shape: const CircleBorder(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 28,
            ),
            if (viewModel.cartCount > 0)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    '${viewModel.cartCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Product Grid
          Expanded(
            child: viewModel.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.darkBlue),
                  )
                : RefreshIndicator(
                    onRefresh: () => viewModel.refresh(),
                    color: AppColors.darkBlue,
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(SizeTokens.p16),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: SizeTokens.p16,
                        mainAxisSpacing: SizeTokens.p16,
                      ),
                      itemCount:
                          viewModel.products.length +
                          (viewModel.hasMore ? 2 : 0),
                      itemBuilder: (context, index) {
                        if (index < viewModel.products.length) {
                          return ProductItem(
                            product: viewModel.products[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailView(
                                    product: viewModel.products[index],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.darkBlue,
                            ),
                          );
                        }
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
