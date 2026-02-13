import 'package:flutter/material.dart';
import '../../../models/notification_model.dart';
import '../../../core/responsive/size_tokens.dart';
import '../../../app/app_theme.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onTap;

  const NotificationItemWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeTokens.p12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(SizeTokens.r12),
          child: Padding(
            padding: EdgeInsets.all(SizeTokens.p16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(),
                SizedBox(width: SizeTokens.p16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                color: AppColors.darkBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeTokens.f16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            _formatDate(item.createdAt),
                            style: TextStyle(
                              color: AppColors.gray,
                              fontSize: SizeTokens.f12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeTokens.p4),
                      Text(
                        item.body,
                        style: TextStyle(
                          color: AppColors.gray,
                          fontSize: SizeTokens.f14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: EdgeInsets.all(SizeTokens.p10),
      decoration: BoxDecoration(
        color: AppColors.blue.withOpacity(0.9),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(SizeTokens.r8),
      ),
      child: Icon(
        Icons.notifications_outlined,
        color: AppColors.white,
        size: SizeTokens.p24,
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h';
      } else {
        return '${date.day}.${date.month}.${date.year}';
      }
    } catch (e) {
      return '';
    }
  }
}
