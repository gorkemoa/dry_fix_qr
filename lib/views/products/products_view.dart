import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/product_view_model.dart';
import '../../viewmodels/home_view_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import 'widgets/product_item.dart';

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
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.darkBlue,
            size: SizeTokens.p24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "DryPara Mağazası",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: SizeTokens.f18,
            fontWeight: FontWeight.bold,
          ),
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
                  color: AppColors.blue,
                  size: SizeTokens.f16,
                ),
                SizedBox(width: SizeTokens.p8),
                Text(
                  "${homeViewModel.user?.tokenBalance ?? 0} DP",
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: SizeTokens.f13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Simplified Category Bar from image
          Container(
            color: AppColors.white,
            padding: EdgeInsets.only(bottom: SizeTokens.p16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: SizeTokens.p24),
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _FilterChip(label: "Tümü", isSelected: true, onTap: () {}),
                  SizedBox(width: SizeTokens.p12),
                  _FilterChip(
                    label: "İç Cephe",
                    isSelected: false,
                    onTap: () {},
                  ),
                  SizedBox(width: SizeTokens.p12),
                  _FilterChip(
                    label: "Dış Cephe",
                    isSelected: false,
                    onTap: () {},
                  ),
                  SizedBox(width: SizeTokens.p12),
                  _FilterChip(label: "Astar", isSelected: false, onTap: () {}),
                ],
              ),
            ),
          ),

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
                              // Handle purchase or detail
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeTokens.p20,
          vertical: SizeTokens.p10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue : AppColors.white,
          borderRadius: BorderRadius.circular(SizeTokens.r24),
          border: Border.all(
            color: isSelected
                ? AppColors.blue
                : AppColors.gray.withOpacity(0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.darkBlue,
            fontSize: SizeTokens.f14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
