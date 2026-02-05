import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_view_model.dart';
import '../../viewmodels/history_view_model.dart';
import '../transactions/transactions_view.dart';
import '../profile/profile_view.dart';
import '../qr_scanner/qr_scanner_view.dart';
import '../orders/orders_view.dart';
import '../products/products_view.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../app/app_theme.dart';
import 'widgets/home_header.dart';
import 'widgets/home_card.dart';
import 'widgets/history_item.dart';
import '../../viewmodels/product_view_model.dart';
import '../cart/cart_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().init();
      context.read<HistoryViewModel>().fetchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = context.watch<HomeViewModel>();
    final historyViewModel = context.watch<HistoryViewModel>();
    final productViewModel = context.watch<ProductViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.blue,
          onRefresh: () async {
            await Future.wait([
              context.read<HomeViewModel>().init(),
              context.read<HistoryViewModel>().fetchHistory(),
            ]);
          },
          child: viewModel.isLoading && viewModel.user == null
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.darkBlue),
                )
              : CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(
                      child: HomeHeader(
                        userName: viewModel.user?.name ?? "Kullanıcı",
                        tokenBalance: viewModel.user?.tokenBalance ?? 0,
                        cartItemCount: productViewModel.cartCount,
                        onCartTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const CartView()),
                          );
                        },
                      ),
                    ),

                    // Grid Section
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: SizeTokens.p24),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: SizeTokens.p20,
                          crossAxisSpacing: SizeTokens.p20,
                          childAspectRatio: 1.0,
                        ),
                        delegate: SliverChildListDelegate([
                          HomeCard(
                            title: "QR Tara",
                            subtitle: "Hızlı İşlem",
                            icon: Icons.qr_code_scanner_rounded,
                            iconColor: AppColors.blue,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const QrScannerView(),
                                ),
                              );
                            },
                          ),
                          HomeCard(
                            title: "Siparişlerim",
                            subtitle: "Durum Takibi",
                            icon: Icons.inventory_2_outlined,
                            iconColor: AppColors.blue,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const OrdersView(),
                                ),
                              );
                            },
                          ),
                          HomeCard(
                            title: "Profilim",
                            subtitle: "Hesap Bilgileri",
                            icon: Icons.person_outline_rounded,
                            iconColor: AppColors.darkBlue,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ProfileView(),
                                ),
                              );
                            },
                          ),
                          HomeCard(
                            title: "Mağaza",
                            subtitle: "Yeni Ürünler",
                            icon: Icons.storefront_outlined,
                            iconColor: const Color(0xFF00BFA5),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ProductsView(),
                                ),
                              );
                            },
                          ),
                        ]),
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: SizeTokens.p32)),

                    // History Section Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeTokens.p24,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Son İşlemler",
                              style: TextStyle(
                                fontSize: SizeTokens.f20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const TransactionsView(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Tümünü Gör",
                                style: TextStyle(
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // History List
                    SliverPadding(
                      padding: EdgeInsets.all(SizeTokens.p24),
                      sliver: historyViewModel.isLoading
                          ? const SliverToBoxAdapter(
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.darkBlue,
                                ),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return HistoryItem(
                                    item: historyViewModel.items[index],
                                  );
                                },
                                childCount: historyViewModel.items.length > 5
                                    ? 5
                                    : historyViewModel.items.length,
                              ),
                            ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: SizeTokens.p32)),
                  ],
                ),
        ),
      ),
    );
  }
}
