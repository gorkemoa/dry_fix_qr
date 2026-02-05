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
        return 'Ödendi';
      case 'shipped':
        return 'Kargolandı';
      case 'cancelled':
        return 'İptal Edildi';
      default:
        return order.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeTokens.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r8),
        border: Border.all(color: const Color.fromARGB(255, 188, 188, 188)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeTokens.p16,
              vertical: SizeTokens.p12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sipariş #${order.id}",
                  style: TextStyle(
                    color: AppColors.darkBlue.withOpacity(0.9),
                    fontSize: SizeTokens.f16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeTokens.p8,
                    vertical: SizeTokens.p4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: _getStatusColor().withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontSize: SizeTokens.f10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: const Color.fromARGB(255, 188, 188, 188)),

          // Body Section
          Padding(
            padding: EdgeInsets.all(SizeTokens.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  "Tarih:",
                  DateFormatter.toTurkish(order.purchasedAt),
                ),
                SizedBox(height: SizeTokens.p4),
                _buildInfoRow("Ürün Adeti:", "${order.itemsCount} Adet"),
                SizedBox(height: SizeTokens.p4),
                _buildInfoRow("Toplam Tutar:", "${order.totalPrice} TL"),
                if (order.totalTokenSpent > 0) ...[
                  SizedBox(height: SizeTokens.p4),
                  _buildInfoRow(
                    "Harcanan Token:",
                    "${order.totalTokenSpent} DryPara",
                  ),
                ],

                SizedBox(height: SizeTokens.p16),

                // Footer Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 38,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  OrderDetailView(orderId: order.id),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.darkBlue,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(SizeTokens.r8),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeTokens.p16,
                          ),
                        ),
                        child: const Text(
                          "Detayları Gör",
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label ",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: SizeTokens.f14,
          ),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.black87, fontSize: SizeTokens.f14),
        ),
      ],
    );
  }
}
