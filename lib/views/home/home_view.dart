import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_view_model.dart';
import '../../viewmodels/history_view_model.dart';
import '../transactions/transactions_view.dart';
import '../profile/update_password_view.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../app/app_theme.dart';
import 'widgets/home_header.dart';
import 'widgets/home_card.dart';
import 'widgets/history_item.dart';

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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.titleLight.withOpacity(0.3),
                    AppColors.background,
                  ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeHeader(
                        userName: viewModel.user?.name ?? "Kullanıcı",
                        tokenBalance: viewModel.user?.tokenBalance ?? 0,
                      ),

                      // Grid Section
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeTokens.p24,
                        ),
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: SizeTokens.p16,
                          crossAxisSpacing: SizeTokens.p16,
                          children: [
                            HomeCard(
                              title: "QR Tara",
                              subtitle: "Hızlıca işle",
                              icon: Icons.qr_code_scanner,
                              iconColor: AppColors.blue,
                              onTap: () {},
                            ),
                            HomeCard(
                              title: "İşlerim",
                              subtitle: "Bekleyenler",
                              icon: Icons.assignment_outlined,
                              iconColor: AppColors.blue,
                              onTap: () {},
                            ),
                            HomeCard(
                              title: "Profilim",
                              subtitle: "Ayarlar ve Bilgi",
                              icon: Icons.person_outline,
                              iconColor: AppColors.darkBlue,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const UpdatePasswordView(),
                                  ),
                                );
                              },
                            ),
                            HomeCard(
                              title: "Destek",
                              subtitle: "Yardım al",
                              icon: Icons.help_outline,
                              iconColor: AppColors.gray,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: SizeTokens.p32),

                      // History Section
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeTokens.p24,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Son İşlemler",
                              style: TextStyle(
                                fontSize: SizeTokens.f18,
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
                                "Hepsini Gör",
                                style: TextStyle(color: AppColors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeTokens.p24,
                        ),
                        child: historyViewModel.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.blue,
                                ),
                              )
                            : Column(
                                children: historyViewModel.items
                                    .take(5)
                                    .map((item) => HistoryItem(item: item))
                                    .toList(),
                              ),
                      ),

                      SizedBox(height: SizeTokens.p24),

                      // Bottom Banner
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeTokens.p24,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(SizeTokens.p20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.darkBlue, AppColors.blue],
                            ),
                            borderRadius: BorderRadius.circular(SizeTokens.r20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Mobil Uygulamamızı\nKeşfedin",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: SizeTokens.f16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: SizeTokens.p8),
                                    Text(
                                      "Tüm özellikler parmaklarınızın ucunda.",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: SizeTokens.f14 * 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.rocket_launch,
                                color: Colors.white,
                                size: SizeTokens.p32 * 1.5,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: SizeTokens.p32),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
