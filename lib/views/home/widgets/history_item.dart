import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';
import '../../../models/history_model.dart' as model;

class HistoryItem extends StatelessWidget {
  final model.HistoryItem item;

  const HistoryItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeTokens.p12),
      padding: EdgeInsets.all(SizeTokens.p12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r16),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlue.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(SizeTokens.p8),
            decoration: BoxDecoration(
              color:
                  (item.direction == 'credit' ? Colors.green : AppColors.blue)
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(SizeTokens.r12),
            ),
            child: Icon(
              item.direction == 'credit'
                  ? Icons.add_circle_outline
                  : Icons.remove_circle_outline,
              color: item.direction == 'credit' ? Colors.green : AppColors.blue,
              size: SizeTokens.p20,
            ),
          ),
          SizedBox(width: SizeTokens.p16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.note,
                  style: TextStyle(
                    fontSize: SizeTokens.f14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlue,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.createdAt,
                  style: TextStyle(
                    fontSize: SizeTokens.f14 * 0.8,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${item.direction == 'credit' ? '+' : '-'}${item.tokenAmount}",
            style: TextStyle(
              fontSize: SizeTokens.f16,
              fontWeight: FontWeight.bold,
              color: item.direction == 'credit' ? Colors.green : Colors.red,
            ),
          ),
          SizedBox(width: SizeTokens.p8),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.gray),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
