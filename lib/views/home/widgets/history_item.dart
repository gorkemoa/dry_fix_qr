import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';
import '../../../models/history_model.dart' as model;

import '../../../core/utils/date_utils.dart';

class HistoryItem extends StatelessWidget {
  final model.HistoryItem item;

  const HistoryItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    bool isCredit = item.direction == 'credit';
    return Container(
      padding: EdgeInsets.symmetric(vertical: SizeTokens.p12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.darkBlue.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(SizeTokens.p8),
            decoration: BoxDecoration(
              color: (isCredit ? Colors.green : AppColors.blue).withOpacity(
                0.1,
              ),
              borderRadius: BorderRadius.circular(SizeTokens.r8),
            ),
            child: Icon(
              isCredit ? Icons.add_rounded : Icons.remove_rounded,
              color: isCredit ? Colors.green : AppColors.blue,
              size: 20,
            ),
          ),
          SizedBox(width: SizeTokens.p16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.note.toLowerCase().contains('qr okuma kazancı')
                      ? 'QR Okuma Kazancı'
                      : item.note,
                  style: TextStyle(
                    fontSize: SizeTokens.f14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlue,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  DateFormatter.toTurkish(item.createdAt),
                  style: TextStyle(
                    fontSize: SizeTokens.f12,
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${isCredit ? '+' : '-'}${item.tokenAmount} DryPara",
            style: TextStyle(
              fontSize: SizeTokens.f16,
              fontWeight: FontWeight.bold,
              color: isCredit ? Colors.green : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
