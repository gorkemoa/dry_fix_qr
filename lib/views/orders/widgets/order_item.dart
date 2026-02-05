import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';
import '../../../models/order_model.dart';
import '../order_detail_view.dart';
import '../../../core/utils/date_utils.dart';

class OrderItem extends StatelessWidget {
  final OrderModel order;

  const OrderItem({super.key, required this.order});

  Color _getStatusColor() {
    switch (order.status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'shipped':
        return AppColors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.gray;
    }
  }

  String _getStatusText() {
    switch (order.status.toLowerCase()) {
      case 'paid':
        return 'Teslim Edildi';
      case 'shipped':
        return 'Kargolandı';
      case 'cancelled':
        return 'İptal Edildi';
      default:
        return order.status;
    }
  }

  IconData _getStatusIcon() {
    switch (order.status.toLowerCase()) {
      case 'paid':
        return Icons.check_circle_rounded;
      case 'shipped':
        return Icons.local_shipping_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeTokens.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Padding(
            padding: EdgeInsets.all(SizeTokens.p16),
            child: Row(
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
                    SizedBox(height: SizeTokens.p4),
                    RichText(
                      text: TextSpan(
                        text: "Toplam: ",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: SizeTokens.f14,
                          fontFamily: 'Inter',
                        ),
                        children: [
                          TextSpan(
                            text: "${order.totalPrice} TL",
                            style: TextStyle(
                              color: AppColors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeTokens.f14,
                              fontFamily: 'Inter',
                            ),
                          ),
                          if (order.totalTokenSpent > 0)
                            TextSpan(
                              text: " + ${order.totalTokenSpent} DP",
                              style: TextStyle(
                                color: AppColors.darkBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeTokens.f14,
                                fontFamily: 'Inter',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OrderDetailView(orderId: order.id),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeTokens.p10,
                      vertical: 0,
                    ),
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeTokens.r6),
                    ),
                  ),
                  child: Text(
                    "Detaylar",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeTokens.f18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Body Section
          Padding(
            padding: EdgeInsets.all(SizeTokens.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Row
                Row(
                  children: [
                    Icon(
                      _getStatusIcon(),
                      color: _getStatusColor(),
                      size: SizeTokens.p20,
                    ),
                    SizedBox(width: SizeTokens.p8),
                    Text(
                      _getStatusText(),
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: SizeTokens.f14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeTokens.p8),
                Text(
                  "${order.items.length} üründen ${order.items.fold(0, (sum, item) => sum + item.quantity)} adet",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: SizeTokens.f14,
                  ),
                ),

                // Notes Section (If Exists)
                if (order.notes != null && order.notes!.isNotEmpty) ...[
                  SizedBox(height: SizeTokens.p8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(SizeTokens.p8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          size: 16,
                          color: Colors.orange.shade800,
                        ),
                        SizedBox(width: SizeTokens.p8),
                        Expanded(
                          child: Text(
                            order.notes!,
                            style: TextStyle(
                              fontSize: SizeTokens.f12,
                              color: Colors.black87,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Product Images
                if (order.items.isNotEmpty) ...[
                  SizedBox(height: SizeTokens.p12),
                  SizedBox(
                    height: 60,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: order.items.length,
                      separatorBuilder: (c, i) =>
                          SizedBox(width: SizeTokens.p8),
                      itemBuilder: (context, index) {
                        final item = order.items[index];
                        return Container(
                          width: 60,
                          height: 60,
                          padding: EdgeInsets.all(
                            4,
                          ), // Use manual 4 as SizeTokens.p4 might be missing or to match lint fix
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(SizeTokens.r8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              item.product.image,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey,
                                  size: 20,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
