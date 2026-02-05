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
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Siparişlerim",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.darkBlue),
            )
          : viewModel.errorMessage != null
          ? _buildErrorView(viewModel)
          : viewModel.orders.isEmpty
          ? _buildEmptyView()
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

  Widget _buildErrorView(OrderViewModel viewModel) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeTokens.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(SizeTokens.p24),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: SizeTokens.p48,
              ),
            ),
            SizedBox(height: SizeTokens.p24),
            Text(
              "Bir Sorun Oluştu",
              style: TextStyle(
                color: AppColors.darkBlue,
                fontSize: SizeTokens.f18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SizeTokens.p8),
            Text(
              viewModel.errorMessage ??
                  "Siparişler yüklenirken bir hata oluştu.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gray, fontSize: SizeTokens.f14),
            ),
            SizedBox(height: SizeTokens.p32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: viewModel.fetchOrders,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  padding: EdgeInsets.symmetric(vertical: SizeTokens.p16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeTokens.r16),
                  ),
                ),
                child: const Text("Tekrar Dene"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeTokens.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(SizeTokens.p32),
              decoration: BoxDecoration(
                color: AppColors.darkBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(SizeTokens.r32),
              ),
              child: Icon(
                Icons.shopping_basket_outlined,
                color: AppColors.darkBlue.withOpacity(0.2),
                size: SizeTokens.p64,
              ),
            ),
            SizedBox(height: SizeTokens.p32),
            Text(
              "Sipariş Bulunamadı",
              style: TextStyle(
                color: AppColors.darkBlue,
                fontSize: SizeTokens.f20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SizeTokens.p12),
            Text(
              "Henüz bir sipariş vermemişsiniz.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.gray,
                fontSize: SizeTokens.f14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
