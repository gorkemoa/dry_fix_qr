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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => OrderDetailView(orderId: order.id)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: SizeTokens.p16),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sipariş #${order.id}",
                  style: TextStyle(
                    fontSize: SizeTokens.f16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                    letterSpacing: -0.5,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeTokens.p12,
                    vertical: SizeTokens.p4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.05),
                    borderRadius: BorderRadius.circular(SizeTokens.r20),
                    border: Border.all(
                      color: _getStatusColor().withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: TextStyle(
                      fontSize: SizeTokens.f12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeTokens.p16),
            Row(
              children: [
                _buildInfoItem(
                  Icons.inventory_2_outlined,
                  "${order.itemsCount} Ürün",
                ),
                SizedBox(width: SizeTokens.p24),
                _buildInfoItem(
                  Icons.account_balance_wallet_outlined,
                  "${order.totalTokenSpent} DryPara",
                ),
              ],
            ),
            if (order.notes != null && order.notes!.isNotEmpty) ...[
              SizedBox(height: SizeTokens.p16),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(SizeTokens.p12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(SizeTokens.r8),
                ),
                child: Text(
                  order.notes!,
                  style: TextStyle(
                    fontSize: SizeTokens.f13,
                    color: AppColors.gray,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            SizedBox(height: SizeTokens.p16),
            const Divider(height: 1),
            SizedBox(height: SizeTokens.p16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormatter.toTurkish(order.purchasedAt),
                  style: TextStyle(
                    fontSize: SizeTokens.f12,
                    color: AppColors.gray,
                  ),
                ),
                Text(
                  "${order.totalPrice} DryPara",
                  style: TextStyle(
                    fontSize: SizeTokens.f18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.gray),
        SizedBox(width: SizeTokens.p6),
        Text(
          label,
          style: TextStyle(
            fontSize: SizeTokens.f13,
            color: AppColors.gray,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
