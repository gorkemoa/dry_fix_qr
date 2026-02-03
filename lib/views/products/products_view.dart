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
        title: const Text("Ürünler"),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: EdgeInsets.all(SizeTokens.p16),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(SizeTokens.r12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.darkBlue.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: viewModel.setSearchQuery,
                    decoration: InputDecoration(
                      hintText: "Ürün ara...",
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.gray,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: AppColors.gray,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                viewModel.setSearchQuery("");
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: SizeTokens.p16,
                        vertical: SizeTokens.p12,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: SizeTokens.p12),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: "Tümü",
                        isSelected: viewModel.inStock == null,
                        onTap: () => viewModel.setInStockFilter(null),
                      ),
                      SizedBox(width: SizeTokens.p8),
                      _FilterChip(
                        label: "Stokta Olanlar",
                        isSelected: viewModel.inStock == true,
                        onTap: () => viewModel.setInStockFilter(true),
                      ),
                      SizedBox(width: SizeTokens.p8),
                      _FilterChip(
                        label: "Tükenenler",
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
                    child: CircularProgressIndicator(color: AppColors.blue),
                  )
                : viewModel.errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          viewModel.errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: SizeTokens.f16,
                          ),
                        ),
                        SizedBox(height: SizeTokens.p16),
                        ElevatedButton(
                          onPressed: () => viewModel.fetchProducts(),
                          child: const Text("Tekrar Dene"),
                        ),
                      ],
                    ),
                  )
                : viewModel.products.isEmpty
                ? Center(
                    child: Text(
                      "Aradığınız kriterlere uygun ürün bulunamadı.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeTokens.f16,
                        color: AppColors.gray,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => viewModel.refresh(),
                    color: AppColors.blue,
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: SizeTokens.p16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
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
                              // Product detail navigation can be added here
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.blue,
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
          horizontal: SizeTokens.p16,
          vertical: SizeTokens.p8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue : AppColors.white,
          borderRadius: BorderRadius.circular(SizeTokens.r20),
          border: Border.all(
            color: isSelected
                ? AppColors.blue
                : AppColors.gray.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.darkBlue,
            fontSize: SizeTokens.f12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
