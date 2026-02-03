import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';
import '../../../models/order_model.dart';
import '../order_detail_view.dart';

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
        padding: EdgeInsets.all(SizeTokens.p16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(SizeTokens.r12),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkBlue.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeTokens.p8,
                    vertical: SizeTokens.p4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SizeTokens.r8),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: TextStyle(
                      fontSize: SizeTokens.f14 * 0.8,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeTokens.p12),
            Row(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: SizeTokens.p16,
                  color: AppColors.gray,
                ),
                SizedBox(width: SizeTokens.p4),
                Text(
                  "${order.itemsCount} Ürün",
                  style: TextStyle(
                    fontSize: SizeTokens.f14,
                    color: AppColors.gray,
                  ),
                ),
                SizedBox(width: SizeTokens.p16),
                Icon(
                  Icons.toll_outlined,
                  size: SizeTokens.p16,
                  color: AppColors.gray,
                ),
                SizedBox(width: SizeTokens.p4),
                Text(
                  "${order.totalTokenSpent} DryPara",
                  style: TextStyle(
                    fontSize: SizeTokens.f14,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
            if (order.notes != null) ...[
              SizedBox(height: SizeTokens.p12),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(SizeTokens.p8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(SizeTokens.r8),
                ),
                child: Text(
                  order.notes!,
                  style: TextStyle(
                    fontSize: SizeTokens.f14,
                    color: AppColors.darkBlue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            SizedBox(height: SizeTokens.p12),
            Divider(color: AppColors.gray.withOpacity(0.1)),
            SizedBox(height: SizeTokens.p8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.purchasedAt,
                  style: TextStyle(
                    fontSize: SizeTokens.f14 * 0.8,
                    color: AppColors.gray,
                  ),
                ),
                Text(
                  "${order.totalPrice} ₺",
                  style: TextStyle(
                    fontSize: SizeTokens.f16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
