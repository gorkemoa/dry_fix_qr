import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/order_view_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import '../../core/utils/date_utils.dart';
import '../../models/order_detail_model.dart';
import '../../models/product_model.dart';
import '../products/product_detail_view.dart';

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
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(SizeTokens.p16),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildStatusSection(viewModel.orderDetail!.order),
                        SizedBox(height: SizeTokens.p16),
                        _buildSectionTitle(
                          viewModel.orderDetail!.items.length > 1
                              ? "Sipariş Edilen Ürünler"
                              : "Sipariş Edilen Ürün",
                        ),

                        // items list
                        ...viewModel.orderDetail!.items.map(
                          (item) => _buildProductItem(item),
                        ),

                        SizedBox(height: SizeTokens.p16),
                        _buildSectionTitle("Teslimat Adresi"),
                        _buildAddressCard(viewModel.orderDetail!.address),

                        SizedBox(height: SizeTokens.p16),
                        _buildSectionTitle("Ödeme Detayı"),
                        _buildPaymentSummary(viewModel.orderDetail!.order),

                        if (viewModel.orderDetail!.order.notes != null &&
                            viewModel.orderDetail!.order.notes!.isNotEmpty) ...[
                          SizedBox(height: SizeTokens.p16),
                          _buildSectionTitle("Sipariş Notu"),
                          _buildNoteCard(viewModel.orderDetail!.order.notes!),
                        ],
                        SizedBox(height: SizeTokens.p32),
                      ],
                    ),
                  ),
                ),
              ],
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
      padding: EdgeInsets.only(bottom: SizeTokens.p12, left: SizeTokens.p4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: SizeTokens.f18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildStatusSection(OrderDetailModel order) {
    Color statusColor;
    String statusText;

    switch (order.status.toLowerCase()) {
      case 'paid':
        statusColor = const Color(0xFF4CAF50);
        statusText = "Ödeme Alındı";
        break;
      case 'shipped':
        statusColor = AppColors.blue;
        statusText = "Kargolandı";
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = "İptal Edildi";
        break;
      default:
        statusColor = AppColors.gray;
        statusText = order.status;
    }

    return Container(
      padding: EdgeInsets.all(SizeTokens.p16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormatter.toTurkish(order.purchasedAt),
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeTokens.f14,
                ),
              ),
              SizedBox(height: SizeTokens.p4),
              Text(
                "Sipariş No: #${order.id}",
                style: TextStyle(
                  fontSize: SizeTokens.f12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeTokens.p12,
              vertical: SizeTokens.p8,
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: statusColor, size: 18),
                SizedBox(width: SizeTokens.p6),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: SizeTokens.f12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(OrderItemModel item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailView(
              product: ProductModel(
                id: item.product.id,
                name: item.product.name,
                description: "", // Not in OrderProductModel
                image: item.product.image,
                price: item.product.price,
                tokenPrice: item.product.tokenPrice,
                stock: 0, // Not in OrderProductModel
                isActive: true,
                canBuy: true,
                createdAt: "",
                updatedAt: "",
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: SizeTokens.p12),
        padding: EdgeInsets.all(SizeTokens.p12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(SizeTokens.r12),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(SizeTokens.r12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(SizeTokens.r12),
                child: Image.network(
                  item.product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
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
                    style: TextStyle(
                      fontSize: SizeTokens.f16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: SizeTokens.p4),
                  Text(
                    "${item.quantity} Adet",
                    style: TextStyle(
                      fontSize: SizeTokens.f12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: SizeTokens.p4),
                  Text(
                    "${item.tokenPriceAtPurchase} DP",
                    style: TextStyle(
                      fontSize: SizeTokens.f14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00B4D8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: SizeTokens.p16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(OrderAddressModel address) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(SizeTokens.p16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(SizeTokens.r12),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.fullName,
                style: TextStyle(
                  fontSize: SizeTokens.f18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: SizeTokens.p8),
              Text(
                address.phone,
                style: TextStyle(
                  fontSize: SizeTokens.f14,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: SizeTokens.p4),
              Text(
                "${address.district}/${address.city}",
                style: TextStyle(
                  fontSize: SizeTokens.f14,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: SizeTokens.p16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  "${address.addressLine1} ${address.addressLine2 ?? ''}",
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: SizeTokens.f13,
                    color: Colors.grey.shade500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: -15,
          top: -30,
          child: Image.asset(
            'assets/mascot_order_detail.png',
            width: 190,
            height: 190,
            fit: BoxFit.contain,
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
        borderRadius: BorderRadius.circular(SizeTokens.r12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPaymentRow(
            "Alış Tarihi",
            DateFormatter.toTurkish(order.purchasedAt),
          ),
          Divider(height: SizeTokens.p24, color: Colors.grey.shade100),
          _buildPaymentRow("Harcanan Puan", "${order.totalTokenSpent} DP"),
          SizedBox(height: SizeTokens.p16),
          Container(
            padding: EdgeInsets.all(SizeTokens.p12),
            decoration: BoxDecoration(
              color: AppColors.darkBlue.withOpacity(0.03),
              borderRadius: BorderRadius.circular(SizeTokens.r8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Toplam",
                  style: TextStyle(
                    fontSize: SizeTokens.f16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      " ${order.totalTokenSpent} DP",
                      style: TextStyle(
                        fontSize: SizeTokens.f20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: SizeTokens.f14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: SizeTokens.f14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
