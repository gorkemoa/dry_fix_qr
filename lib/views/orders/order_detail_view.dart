import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/order_view_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../core/utils/date_utils.dart';
import '../../models/order_detail_model.dart';

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
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Sipariş Detayı",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
              padding: EdgeInsets.all(SizeTokens.p16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStatusSection(viewModel.orderDetail!.order),
                  SizedBox(height: SizeTokens.p16),

                  // items list
                  ...viewModel.orderDetail!.items.map(
                    (item) => _buildProductItem(item),
                  ),

                  SizedBox(height: SizeTokens.p16),
                  _buildSectionTitle("Teslimat Adresi"),
                  _buildAddressCard(viewModel.orderDetail!.address),

                  SizedBox(height: SizeTokens.p16),
                  _buildPaymentSummary(viewModel.orderDetail!.order),

                  if (viewModel.orderDetail!.order.notes != null &&
                      viewModel.orderDetail!.order.notes!.isNotEmpty) ...[
                    SizedBox(height: SizeTokens.p16),
                    _buildSectionTitle("Sipariş Notu"),
                    _buildNoteCard(viewModel.orderDetail!.order.notes!),
                  ],
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
              size: SizeTokens.p48,
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

  Widget _buildStatusSection(OrderDetailModel order) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (order.status.toLowerCase()) {
      case 'paid':
        statusColor = Colors.green;
        statusText = "Ödeme Alındı"; // Or 'Ödendi'
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'shipped':
        statusColor = AppColors.blue;
        statusText = "Kargolandı";
        statusIcon = Icons.local_shipping_rounded;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = "İptal Edildi";
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = AppColors.gray;
        statusText = order.status;
        statusIcon = Icons.info_rounded;
    }

    return Container(
      padding: EdgeInsets.all(SizeTokens.p16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormatter.toTurkish(order.purchasedAt),
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: SizeTokens.f14,
                    ),
                  ),
                  SizedBox(height: SizeTokens.p4),
                  Text(
                    "Sipariş No: #${order.id}",
                    style: TextStyle(
                      fontSize: SizeTokens.f12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeTokens.p12,
                  vertical: SizeTokens.p6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, color: statusColor, size: SizeTokens.p16),
                    SizedBox(width: SizeTokens.p6),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: SizeTokens.f12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(OrderItemModel item) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeTokens.p10),
      padding: EdgeInsets.all(SizeTokens.p12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 70,
            padding: EdgeInsets.all(SizeTokens.p4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(SizeTokens.r8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                item.product.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey,
                  size: SizeTokens.p24,
                ),
              ),
            ),
          ),
          SizedBox(width: SizeTokens.p16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: SizeTokens.f14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlue,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: SizeTokens.p4),
                Text(
                  "${item.quantity} Adet",
                  style: TextStyle(
                    fontSize: SizeTokens.f13,
                    color: AppColors.gray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: SizeTokens.p8),
                Text(
                  "${item.tokenPriceAtPurchase} DryPara",
                  style: TextStyle(
                    fontSize: SizeTokens.f14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(OrderAddressModel address) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeTokens.p16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColors.darkBlue,
                size: SizeTokens.p20,
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
          Divider(height: 24, color: Colors.grey.shade200),
          _buildAddressRow(Icons.phone_outlined, address.phone),
          SizedBox(height: SizeTokens.p8),
          _buildAddressRow(
            Icons.map_outlined,
            "${address.district} / ${address.city}",
          ),
          SizedBox(height: SizeTokens.p8),
          _buildAddressRow(Icons.home_outlined, address.addressLine1),
          if (address.addressLine2 != null &&
              address.addressLine2!.isNotEmpty) ...[
            SizedBox(height: SizeTokens.p4),
            Padding(
              padding: EdgeInsets.only(left: 28), // 20 icon + 8 spacer
              child: Text(
                address.addressLine2!,
                style: TextStyle(
                  fontSize: SizeTokens.f13,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddressRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        SizedBox(width: SizeTokens.p12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: SizeTokens.f13,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteCard(String note) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeTokens.p12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(SizeTokens.r8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.note_alt_outlined,
            color: Colors.orange.shade800,
            size: 20,
          ),
          SizedBox(width: SizeTokens.p8),
          Expanded(
            child: Text(
              note,
              style: TextStyle(
                fontSize: SizeTokens.f13,
                color: Colors.black87,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(OrderDetailModel order) {
    return Container(
      padding: EdgeInsets.all(SizeTokens.p16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ödeme Özeti",
            style: TextStyle(
              fontSize: SizeTokens.f16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
          Divider(height: 24, color: Colors.grey.shade200),
          _buildSummaryRow("Sipariş Tutarı", "${order.totalPrice} TL"),
          if (order.totalTokenSpent > 0) ...[
            SizedBox(height: SizeTokens.p8),
            _buildSummaryRow(
              "Harcanan Puan",
              "${order.totalTokenSpent} DP",
              valueColor: AppColors.darkBlue,
            ),
          ],
          SizedBox(height: SizeTokens.p12),
          const Divider(height: 1),
          SizedBox(height: SizeTokens.p12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Toplam",
                style: TextStyle(
                  fontSize: SizeTokens.f16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${order.totalPrice} TL",
                    style: TextStyle(
                      color: AppColors.blue,
                      fontSize: SizeTokens.f18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (order.totalTokenSpent > 0)
                    Text(
                      "+ ${order.totalTokenSpent} DP",
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: SizeTokens.f12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: SizeTokens.f14,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: SizeTokens.f14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
