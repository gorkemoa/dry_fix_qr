import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../models/product_model.dart';
import '../../viewmodels/home_view_model.dart';
import '../../viewmodels/history_view_model.dart';
import '../orders/orders_view.dart';

class OrderSuccessView extends StatelessWidget {
  final List<ProductModel> items;

  const OrderSuccessView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    // Group items by ID to show quantities
    final Map<int, List<ProductModel>> groupedItems = {};
    for (var item in items) {
      if (!groupedItems.containsKey(item.id)) {
        groupedItems[item.id] = [];
      }
      groupedItems[item.id]!.add(item);
    }

    final successItems = groupedItems.values.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE8F6F1), // Softer mint green background
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mascot Character - Larger as in screenshot
                  Center(
                    child: Image.asset(
                      'assets/Adsız tasarım (16).png',
                      height: getProportionateScreenHeight(350),
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: SizeTokens.p10),

                  // Success Text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeTokens.p24),
                    child: Column(
                      children: [
                        Text(
                          "Siparişini Aldık!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeTokens.f32 * 1.1,
                            fontWeight: FontWeight.w900,
                            color: AppColors.darkBlue,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: SizeTokens.p10),
                        Text(
                          "Siparişin başarıyla tamamlandı.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeTokens.f18,
                            color: AppColors.gray.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeTokens.p24),

                  // Items Card - Flexible with indicators for scrollability
                  Flexible(
                    flex: successItems.length > 1 ? 4 : 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: SizeTokens.p24),
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxHeight: successItems.length > 1
                              ? getProportionateScreenHeight(320)
                              : double.infinity,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(SizeTokens.r24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(SizeTokens.r24),
                          child: ShaderMask(
                            shaderCallback: (Rect rect) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white,
                                  Colors.white,
                                  Colors.white.withOpacity(
                                    successItems.length > 1 ? 0.0 : 1.0,
                                  ),
                                ],
                                stops: const [0.0, 0.90, 1.0],
                              ).createShader(rect);
                            },
                            blendMode: BlendMode.dstIn,
                            child: Scrollbar(
                              thumbVisibility: successItems.length > 1,
                              thickness: 4,
                              radius: const Radius.circular(10),
                              child: SingleChildScrollView(
                                physics: successItems.length > 1
                                    ? const BouncingScrollPhysics()
                                    : const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.all(SizeTokens.p20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ...successItems.map((group) {
                                      final item = group.first;
                                      final quantity = group.length;
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: group == successItems.last
                                              ? 0
                                              : SizeTokens.p16,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 64,
                                              height: 64,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF5F5F7),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      SizeTokens.r12,
                                                    ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      SizeTokens.r12,
                                                    ),
                                                child: Image.network(
                                                  item.image,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => const Icon(
                                                        Icons.inventory_2,
                                                        color: AppColors.gray,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: SizeTokens.p16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.name,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: SizeTokens.f16,
                                                      color: AppColors.darkBlue,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    "$quantity Adet",
                                                    style: TextStyle(
                                                      color: AppColors.gray,
                                                      fontSize: SizeTokens.f14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    "${item.tokenPrice * quantity} DryPara",
                                                    style: TextStyle(
                                                      color: const Color(
                                                        0xFF00C2FF,
                                                      ), // Vibrant cyan from shot
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: SizeTokens.f14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    // Extra padding at bottom to ensure shader doesn't hide text too much
                                    if (successItems.length > 1)
                                      const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),

            // Navigation Buttons
            Padding(
              padding: EdgeInsets.fromLTRB(
                SizeTokens.p24,
                0,
                SizeTokens.p24,
                SizeTokens.p24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Go to Order Detail Button (Light Blue)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const OrdersView(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF91B8EF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SizeTokens.r24),
                        ),
                      ),
                      child: Text(
                        "Sipariş Detayına Git",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: SizeTokens.f18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeTokens.p12),
                  // Return Home Button (Dark Blue)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<HomeViewModel>().init();
                        context.read<HistoryViewModel>().fetchHistory();
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SizeTokens.r24),
                        ),
                      ),
                      child: Text(
                        "Ana Sayfaya Dön",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: SizeTokens.f18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
