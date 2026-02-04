import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/order_view_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import 'widgets/order_item.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderViewModel>().fetchOrders();
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
      context.read<OrderViewModel>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = context.watch<OrderViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.darkBlue,
            size: SizeTokens.p20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Siparişlerim",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: SizeTokens.f18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.darkBlue),
            )
          : viewModel.errorMessage != null
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(SizeTokens.p32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: Colors.red.shade300,
                      size: SizeTokens.p48,
                    ),
                    SizedBox(height: SizeTokens.p16),
                    Text(
                      viewModel.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: SizeTokens.f14,
                      ),
                    ),
                    SizedBox(height: SizeTokens.p24),
                    SizedBox(
                      width: SizeTokens.p8 * 20, // 160
                      child: ElevatedButton(
                        onPressed: () => viewModel.fetchOrders(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(SizeTokens.r8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text("Tekrar Dene"),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : viewModel.orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_basket_outlined,
                    color: AppColors.gray.withOpacity(0.3),
                    size: SizeTokens.p64,
                  ),
                  SizedBox(height: SizeTokens.p16),
                  Text(
                    "Henüz siparişiniz bulunmamaktadır.",
                    style: TextStyle(
                      fontSize: SizeTokens.f14,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () => viewModel.refresh(),
              color: AppColors.darkBlue,
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(SizeTokens.p24),
                itemCount:
                    viewModel.orders.length + (viewModel.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < viewModel.orders.length) {
                    return OrderItem(order: viewModel.orders[index]);
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.darkBlue,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
    );
  }
}
