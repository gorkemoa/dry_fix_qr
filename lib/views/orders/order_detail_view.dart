import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/order_view_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../core/utils/date_utils.dart';

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
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.darkBlue,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Sipariş Detayı",
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: SizeTokens.f18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: viewModel.isDetailLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.darkBlue),
            )
          : viewModel.errorMessage != null
          ? _buildErrorView(viewModel.errorMessage!)
          : viewModel.orderDetail == null
          ? const Center(child: Text("Sipariş bulunamadı."))
          : SingleChildScrollView(
              padding: EdgeInsets.all(SizeTokens.p24),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusSection(viewModel.orderDetail!.order),
                  SizedBox(height: SizeTokens.p24),
                  _buildSectionTitle("Ürünler"),
                  ...viewModel.orderDetail!.items.map(
                    (item) => _buildProductItem(item),
                  ),
                  SizedBox(height: SizeTokens.p24),
                  _buildSectionTitle("Teslimat Adresi"),
                  _buildAddressCard(viewModel.orderDetail!.address),
                  if (viewModel.orderDetail!.order.notes != null &&
                      viewModel.orderDetail!.order.notes!.isNotEmpty) ...[
                    SizedBox(height: SizeTokens.p24),
                    _buildSectionTitle("Sipariş Notu"),
                    _buildNoteCard(viewModel.orderDetail!.order.notes!),
                  ],
                  SizedBox(height: SizeTokens.p32),
                  _buildSummaryCard(viewModel.orderDetail!.order),
                  SizedBox(height: SizeTokens.p32),
                ],
              ),
            ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeTokens.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.red.shade300,
              size: 48,
            ),
            SizedBox(height: SizeTokens.p16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.darkBlue,
                fontSize: SizeTokens.f14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeTokens.p12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: SizeTokens.f14,
          fontWeight: FontWeight.bold,
          color: AppColors.darkBlue,
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  Widget _buildStatusSection(dynamic order) {
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
      padding: EdgeInsets.all(SizeTokens.p20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r12),
        border: Border.all(color: AppColors.darkBlue.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(SizeTokens.p10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: statusColor,
              size: 24,
            ),
          ),
          SizedBox(width: SizeTokens.p16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sipariş #${order.id}",
                  style: TextStyle(
                    fontSize: SizeTokens.f16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                Text(
                  DateFormatter.toTurkish(order.purchasedAt),
                  style: TextStyle(
                    fontSize: SizeTokens.f12,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeTokens.p12,
              vertical: SizeTokens.p4,
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(SizeTokens.r20),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: SizeTokens.f12,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(dynamic item) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeTokens.p12),
      padding: EdgeInsets.all(SizeTokens.p12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r12),
        border: Border.all(color: AppColors.darkBlue.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(SizeTokens.r8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(SizeTokens.r8),
              child: Image.network(
                item.product.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.gray,
                  size: 20,
                ),
              ),
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
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlue,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${item.quantity} Adet",
                  style: TextStyle(
                    fontSize: SizeTokens.f12,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${item.tokenPriceAtPurchase} DryPara",
            style: TextStyle(
              fontSize: SizeTokens.f14,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(dynamic address) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeTokens.p20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r12),
        border: Border.all(color: AppColors.darkBlue.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.blue,
                size: 18,
              ),
              SizedBox(width: SizeTokens.p8),
              Text(
                address.fullName,
                style: TextStyle(
                  fontSize: SizeTokens.f14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeTokens.p12),
          Text(
            address.phone,
            style: TextStyle(fontSize: SizeTokens.f13, color: AppColors.gray),
          ),
          SizedBox(height: SizeTokens.p4),
          Text(
            "${address.addressLine1}${address.addressLine2 != null ? ', ${address.addressLine2}' : ''}",
            style: TextStyle(
              fontSize: SizeTokens.f13,
              color: AppColors.darkBlue,
            ),
          ),
          Text(
            "${address.district} / ${address.city}",
            style: TextStyle(
              fontSize: SizeTokens.f13,
              color: AppColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(String note) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeTokens.p16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(SizeTokens.r8),
        border: Border.all(color: AppColors.darkBlue.withOpacity(0.05)),
      ),
      child: Text(
        note,
        style: TextStyle(
          fontSize: SizeTokens.f13,
          color: AppColors.gray,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildSummaryCard(dynamic order) {
    return Container(
      padding: EdgeInsets.all(SizeTokens.p24),
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.circular(SizeTokens.r16),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            "Sipariş Toplamı",
            "${order.totalTokenSpent} DryPara",
            isTotal: true,
          ),
          if (order.totalPrice != "0.00") ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Colors.white10, height: 1),
            ),
            _buildSummaryRow("Nakit Tutar", "${order.totalPrice} DryPara"),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.white : Colors.white70,
            fontSize: isTotal ? SizeTokens.f14 : SizeTokens.f13,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTotal ? SizeTokens.f20 : SizeTokens.f16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
