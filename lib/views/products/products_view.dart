import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/product_view_model.dart';
import '../../viewmodels/home_view_model.dart';import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../core/widgets/dp_symbol.dart';
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
  final TextEditingController _searchController = TextEditingController();

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
  void deactivate() {
    context.read<ProductViewModel>().resetFilters();
    super.deactivate();
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

  void _showSortBottomSheet(BuildContext context, ProductViewModel viewModel) {
    final options = [
      (ProductSortOrder.none, 'Varsayılan'),
      (ProductSortOrder.tokenAsc, 'DryPara: Azdan Çoğa'),
      (ProductSortOrder.tokenDesc, 'DryPara: Çoktan Aza'),
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(SizeTokens.r20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                SizeTokens.p16,
                SizeTokens.p16,
                SizeTokens.p16,
                SizeTokens.p32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: SizeTokens.p40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.titleLight,
                        borderRadius: BorderRadius.circular(SizeTokens.r4),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeTokens.p16),
                  Text(
                    'Sıralama',
                    style: TextStyle(
                      fontSize: SizeTokens.f18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  SizedBox(height: SizeTokens.p8),
                  ...options.map((entry) {
                    final (order, label) = entry;
                    final isSelected = viewModel.sortOrder == order;
                    return InkWell(
                      onTap: () {
                        viewModel.setSortOrder(order);
                        setSheetState(() {});
                        Navigator.pop(ctx);
                      },
                      borderRadius: BorderRadius.circular(SizeTokens.r8),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeTokens.p12,
                          horizontal: SizeTokens.p8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: SizeTokens.f14,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? AppColors.darkBlue
                                      : AppColors.gray,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_rounded,
                                color: AppColors.darkBlue,
                                size: SizeTokens.p20,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
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
        title: const Text(
          "Mağaza",
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
                  "${homeViewModel.user?.tokenBalance ?? 0} ",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: SizeTokens.f13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DpSymbol(size: SizeTokens.p24, color: AppColors.white),
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
      body: RefreshIndicator(
        onRefresh: () => viewModel.refresh(),
        color: AppColors.darkBlue,
        child: CustomScrollView(
          controller: _scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // Search Bar + Sort (scrolls with content)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  SizeTokens.p16,
                  SizeTokens.p16,
                  SizeTokens.p16,
                  SizeTokens.p8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: SizeTokens.p48,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(SizeTokens.r12),
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: AppColors.darkBlue.withOpacity( 0.3),
                            width: 1.2,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: SizeTokens.f14,
                          ),
                          cursorColor: AppColors.darkBlue,
                          onChanged: (v) =>
                              context.read<ProductViewModel>().setSearchQuery(v),
                          decoration: InputDecoration(
                            hintText: 'Ürün ara...',
                            hintStyle: TextStyle(
                              color: AppColors.darkBlue,
                              fontSize: SizeTokens.f14,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: AppColors.darkBlue,
                              size: SizeTokens.p20,
                            ),
                            suffixIcon: viewModel.searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.close_rounded,
                                      color: AppColors.darkBlue,
                                      size: SizeTokens.p20,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      context
                                          .read<ProductViewModel>()
                                          .setSearchQuery('');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: SizeTokens.p12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: SizeTokens.p8),
                    GestureDetector(
                      onTap: () => _showSortBottomSheet(context, viewModel),
                      child: Container(
                        width: SizeTokens.p48,
                        height: SizeTokens.p48,
                        decoration: BoxDecoration(
                          color: viewModel.sortOrder != ProductSortOrder.none
                              ? AppColors.darkBlue
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(SizeTokens.r12),
                          border: Border.all(
                            color: viewModel.sortOrder != ProductSortOrder.none
                                // ignore: deprecated_member_use
                                ? AppColors.darkBlue.withOpacity(0.3)
                                // ignore: deprecated_member_use
                                : AppColors.darkBlue.withOpacity(0.3),
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          Icons.sort_rounded,
                          color: viewModel.sortOrder != ProductSortOrder.none
                              ? AppColors.white
                              : AppColors.darkBlue,
                          size: SizeTokens.p24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Category Filter Chips
            if (viewModel.availableCategories.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: SizeTokens.p40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: SizeTokens.p16),
                    itemCount: viewModel.availableCategories.length + 1,
                    separatorBuilder: (_, __) =>
                        SizedBox(width: SizeTokens.p8),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        final isSelected =
                            viewModel.selectedCategoryId == null;
                        return _CategoryChip(
                          label: 'Tümü',
                          isSelected: isSelected,
                          onTap: () =>
                              context.read<ProductViewModel>().setCategory(null),
                        );
                      }
                      final category =
                          viewModel.availableCategories[index - 1];
                      final isSelected =
                          viewModel.selectedCategoryId == category.id;
                      return _CategoryChip(
                        label: category.name,
                        isSelected: isSelected,
                        onTap: () => context
                            .read<ProductViewModel>()
                            .setCategory(category.id),
                      );
                    },
                  ),
                ),
              ),

            // Products
            if (viewModel.isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.darkBlue),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  SizeTokens.p16,
                  SizeTokens.p8,
                  SizeTokens.p16,
                  SizeTokens.p16,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: SizeTokens.p16,
                    mainAxisSpacing: SizeTokens.p16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
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
                    childCount:
                        viewModel.products.length +
                        (viewModel.hasMore ? 2 : 0),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: SizeTokens.p16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkBlue : AppColors.white,
          borderRadius: BorderRadius.circular(SizeTokens.r20),
          border: Border.all(
            color: isSelected ? AppColors.darkBlue : AppColors.gray,
            width: 1.2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: SizeTokens.f13,
              fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.white : const Color(0xFF4A5072),
            ),
          ),
        ),
      ),
    );
  }
}
