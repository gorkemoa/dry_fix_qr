import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/order_view_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';

class OrderDetailView extends StatefulWidget {
  final int orderId;

  const OrderDetailView({super.key, required this.orderId});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderViewModel>().fetchOrderDetail(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final viewModel = context.watch<OrderViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Sipariş Detayı #${widget.orderId}"),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: viewModel.isDetailLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            )
          : viewModel.errorMessage != null
          ? Center(
              child: Text(
                viewModel.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : viewModel.orderDetail == null
          ? const Center(child: Text("Sipariş bulunamadı."))
          : SingleChildScrollView(
              padding: EdgeInsets.all(SizeTokens.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusCard(viewModel.orderDetail!.order),
                  SizedBox(height: SizeTokens.p16),
                  _buildSectionTitle("Ürünler"),
                  ...viewModel.orderDetail!.items.map(
                    (item) => _buildProductItem(item),
                  ),
                  SizedBox(height: SizeTokens.p16),
                  _buildSectionTitle("Teslimat Adresi"),
                  _buildAddressCard(viewModel.orderDetail!.address),
                  SizedBox(height: SizeTokens.p16),
                  if (viewModel.orderDetail!.order.notes != null) ...[
                    _buildSectionTitle("Sipariş Notu"),
                    _buildNoteCard(viewModel.orderDetail!.order.notes!),
                    SizedBox(height: SizeTokens.p16),
                  ],
                  _buildSummaryCard(viewModel.orderDetail!.order),
                  SizedBox(height: SizeTokens.p32),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeTokens.p8, left: SizeTokens.p4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: SizeTokens.f16,
          fontWeight: FontWeight.bold,
          color: AppColors.darkBlue,
        ),
      ),
    );
  }

  Widget _buildStatusCard(dynamic order) {
    Color statusColor = AppColors.blue;
    String statusText = order.status;

    switch (order.status.toLowerCase()) {
      case 'paid':
        statusColor = Colors.green;
        statusText = "Ödendi";
        break;
      case 'shipped':
        statusColor = AppColors.blue;
        statusText = "Kargolandı";
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = "İptal Edildi";
        break;
    }

    return Container(
      padding: EdgeInsets.all(SizeTokens.p16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sipariş Durumu",
                style: TextStyle(
                  fontSize: SizeTokens.f12,
                  color: AppColors.gray,
                ),
              ),
              SizedBox(height: SizeTokens.p4),
              Text(
                statusText,
                style: TextStyle(
                  fontSize: SizeTokens.f16,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Tarih",
                style: TextStyle(
                  fontSize: SizeTokens.f12,
                  color: AppColors.gray,
                ),
              ),
              SizedBox(height: SizeTokens.p4),
              Text(
                order.purchasedAt.split('T')[0],
                style: TextStyle(
                  fontSize: SizeTokens.f14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(dynamic item) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeTokens.p8),
      padding: EdgeInsets.all(SizeTokens.p12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(SizeTokens.r8),
            child: Image.network(
              item.product.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: SizeTokens.p12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: TextStyle(
                    fontSize: SizeTokens.f14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: SizeTokens.p4),
                Text(
                  "Adet: ${item.quantity}",
                  style: TextStyle(
                    fontSize: SizeTokens.f12,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (item.tokenPriceAtPurchase > 0)
                Text(
                  "${item.tokenPriceAtPurchase} DryPara",
                  style: TextStyle(
                    fontSize: SizeTokens.f14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
              if (item.priceAtPurchase != "0.00")
                Text(
                  "${item.priceAtPurchase} ₺",
                  style: TextStyle(
                    fontSize: SizeTokens.f12,
                    color: AppColors.gray,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(dynamic address) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeTokens.p16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address.fullName,
            style: TextStyle(
              fontSize: SizeTokens.f16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
          SizedBox(height: SizeTokens.p4),
          Text(
            address.phone,
            style: TextStyle(fontSize: SizeTokens.f14, color: AppColors.gray),
          ),
          SizedBox(height: SizeTokens.p8),
          Text(
            "${address.addressLine1}${address.addressLine2 != null ? '\n${address.addressLine2}' : ''}",
            style: TextStyle(
              fontSize: SizeTokens.f14,
              color: AppColors.darkBlue,
            ),
          ),
          Text(
            "${address.district} / ${address.city}",
            style: TextStyle(
              fontSize: SizeTokens.f14,
              color: AppColors.darkBlue,
            ),
          ),
          if (address.notes != null) ...[
            SizedBox(height: SizeTokens.p8),
            Text(
              "Not: ${address.notes}",
              style: TextStyle(
                fontSize: SizeTokens.f12,
                color: AppColors.gray,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNoteCard(String note) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeTokens.p16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r12),
      ),
      child: Text(
        note,
        style: TextStyle(
          fontSize: SizeTokens.f14,
          color: AppColors.darkBlue,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildSummaryCard(dynamic order) {
    return Container(
      padding: EdgeInsets.all(SizeTokens.p16),
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.circular(SizeTokens.r12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Toplam Harcama",
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                "${order.totalTokenSpent} DryPara",
                style: TextStyle(
                  fontSize: SizeTokens.f18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          if (order.totalPrice != "0.00") ...[
            SizedBox(height: SizeTokens.p8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Toplam Tutar",
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  "${order.totalPrice} ₺",
                  style: TextStyle(
                    fontSize: SizeTokens.f16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
