import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_view_model.dart';
import '../../viewmodels/history_view_model.dart';
import '../../viewmodels/game_view_model.dart';
import '../transactions/transactions_view.dart';
import '../profile/profile_view.dart';
import '../qr_scanner/qr_scanner_view.dart';
import '../orders/orders_view.dart';
import '../products/products_view.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../app/app_theme.dart';
import '../products/product_detail_view.dart';
import 'widgets/home_header.dart';
import 'widgets/home_card.dart';
import 'widgets/history_item.dart';
import 'widgets/banner_slider.dart';
import '../../viewmodels/banner_view_model.dart';
import '../../viewmodels/product_view_model.dart';
import '../cart/cart_view.dart';
import '../notifications/notifications_view.dart';
import '../../core/storage/storage_manager.dart';
import 'widgets/onboarding_dialog.dart';
import 'memory_game_view.dart';

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
      context.read<BannerViewModel>().init();
      context.read<GameViewModel>().init();
      _checkOnboarding();
    });
  }

  void _checkOnboarding() {
    if (!StorageManager.isOnboardingShown()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const OnboardingDialog(),
      );
      StorageManager.setOnboardingShown();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = context.watch<HomeViewModel>();
    final historyViewModel = context.watch<HistoryViewModel>();
    final productViewModel = context.watch<ProductViewModel>();
    final bannerViewModel = context.watch<BannerViewModel>();
    final gameViewModel = context.watch<GameViewModel>();

    return Scaffold(
      backgroundColor: AppColors.blue,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.blue,
          onRefresh: () async {
            await Future.wait([
              context.read<HomeViewModel>().init(),
              context.read<HistoryViewModel>().fetchHistory(),
              context.read<GameViewModel>().init(),
              context.read<BannerViewModel>().refresh(),
            ]);
          },
          child: viewModel.isLoading && viewModel.user == null
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
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
                        isGamePlayable: gameViewModel.isPlayable,
                        nextGamePlayableAt: gameViewModel.nextPlayableAt,
                        onGameTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const MemoryGameView(),
                            ),
                          );
                        },
                        onCartTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const CartView()),
                          );
                        },
                        onNotificationTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const NotificationsView(),
                            ),
                          );
                        },
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(SizeTokens.r40),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: SizeTokens.p40),
                            // Grid Section
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeTokens.p24,
                              ),
                              child: GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                mainAxisSpacing: SizeTokens.p20,
                                crossAxisSpacing: SizeTokens.p20,
                                childAspectRatio: 1.2,
                                children: [
                                  HomeCard(
                                    title: "QR Tara",
                                    subtitle: "Hızlı İşlem",
                                    icon: Icons.qr_code_scanner_rounded,
                                    iconColor: AppColors.darkBlue,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const QrScannerView(),
                                        ),
                                      );
                                    },
                                  ),
                                  HomeCard(
                                    title: "Kazandıklarım",
                                    subtitle: "Durum Takibi",
                                    icon: Icons.shopping_bag_outlined,
                                    iconColor: AppColors.darkBlue,
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
                                    icon: Icons.shopping_cart_outlined,
                                    iconColor: AppColors.darkBlue,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const ProductsView(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Banner Slider Section
                            if (bannerViewModel.banners.isNotEmpty) ...[
                              BannerSlider(
                                banners: bannerViewModel.banners,
                                onBannerTap: (banner) async {
                                  final product = await context
                                      .read<BannerViewModel>()
                                      .onBannerTapped(banner);
                                  if (product != null && context.mounted) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ProductDetailView(product: product),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],

                            // History Section Header
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeTokens.p24,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Son İşlemler",
                                    style: TextStyle(
                                      fontSize: SizeTokens.f18,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF114B62),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const TransactionsView(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Tümünü Gör",
                                      style: TextStyle(
                                        color: AppColors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizeTokens.f14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // History List
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                SizeTokens.p24,
                                SizeTokens.p10,
                                SizeTokens.p24,
                                SizeTokens.p10,
                              ),
                              child: historyViewModel.isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.darkBlue,
                                      ),
                                    )
                                  : Column(
                                      children: historyViewModel.items
                                          .take(5)
                                          .map(
                                            (item) => HistoryItem(item: item),
                                          )
                                          .toList(),
                                    ),
                            ),
                            SizedBox(height: SizeTokens.p32),
                          ],
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(color: AppColors.background),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
