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
        title: const Text("Siparişlerim"),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: viewModel.isLoading
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
                    onPressed: () => viewModel.fetchOrders(),
                    child: const Text("Tekrar Dene"),
                  ),
                ],
              ),
            )
          : viewModel.orders.isEmpty
          ? Center(
              child: Text(
                "Henüz siparişiniz bulunmamaktadır.",
                style: TextStyle(
                  fontSize: SizeTokens.f16,
                  color: AppColors.gray,
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => viewModel.refresh(),
              color: AppColors.blue,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(SizeTokens.p16),
                itemCount:
                    viewModel.orders.length + (viewModel.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < viewModel.orders.length) {
                    return OrderItem(order: viewModel.orders[index]);
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.blue),
                      ),
                    );
                  }
                },
              ),
            ),
    );
  }
}
