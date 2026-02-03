import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/product_view_model.dart';
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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().fetchProducts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.darkBlue,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Ürünler",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: SizeTokens.f18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            color: AppColors.white,
            padding: EdgeInsets.fromLTRB(
              SizeTokens.p24,
              SizeTokens.p8,
              SizeTokens.p24,
              SizeTokens.p16,
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: viewModel.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: "Ürün ara...",
                    hintStyle: TextStyle(
                      color: AppColors.gray.withOpacity(0.5),
                      fontSize: SizeTokens.f14,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.darkBlue.withOpacity(0.5),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: SizeTokens.p16,
                      vertical: SizeTokens.p12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SizeTokens.r8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SizeTokens.r8),
                      borderSide: const BorderSide(
                        color: AppColors.darkBlue,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: SizeTokens.p16),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _FilterChip(
                        label: "Tümü",
                        isSelected: viewModel.inStock == null,
                        onTap: () => viewModel.setInStockFilter(null),
                      ),
                      SizedBox(width: SizeTokens.p8),
                      _FilterChip(
                        label: "Stokta",
                        isSelected: viewModel.inStock == true,
                        onTap: () => viewModel.setInStockFilter(true),
                      ),
                      SizedBox(width: SizeTokens.p8),
                      _FilterChip(
                        label: "Tükenen",
                        isSelected: viewModel.inStock == false,
                        onTap: () => viewModel.setInStockFilter(false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Product Grid
          Expanded(
            child: viewModel.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.darkBlue),
                  )
                : viewModel.errorMessage != null
                ? _buildErrorView(viewModel)
                : viewModel.products.isEmpty
                ? _buildEmptyView()
                : RefreshIndicator(
                    onRefresh: () => viewModel.refresh(),
                    color: AppColors.darkBlue,
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(SizeTokens.p24),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.608,
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
                            onTap: () {},
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

  Widget _buildErrorView(ProductViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Colors.red.shade300,
            size: 48,
          ),
          SizedBox(height: SizeTokens.p16),
          Text(
            viewModel.errorMessage!,
            style: TextStyle(
              fontSize: SizeTokens.f14,
              color: AppColors.darkBlue,
            ),
          ),
          SizedBox(height: SizeTokens.p16),
          ElevatedButton(
            onPressed: () => viewModel.fetchProducts(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkBlue,
              elevation: 0,
            ),
            child: const Text("Tekrar Dene"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            color: AppColors.gray.withOpacity(0.3),
            size: 64,
          ),
          SizedBox(height: SizeTokens.p16),
          Text(
            "Ürün bulunamadı.",
            style: TextStyle(fontSize: SizeTokens.f14, color: AppColors.gray),
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
          horizontal: SizeTokens.p16,
          vertical: SizeTokens.p8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkBlue : AppColors.background,
          borderRadius: BorderRadius.circular(SizeTokens.r8),
          border: Border.all(
            color: isSelected
                ? AppColors.darkBlue
                : AppColors.darkBlue.withOpacity(0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.darkBlue,
            fontSize: SizeTokens.f12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
