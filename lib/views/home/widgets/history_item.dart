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
      margin: EdgeInsets.only(bottom: SizeTokens.p12),
      padding: EdgeInsets.all(SizeTokens.p16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(SizeTokens.p10),
            decoration: BoxDecoration(
              color: (isCredit ? Colors.green : Colors.red).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCredit ? Icons.add_rounded : Icons.remove_rounded,
              color: isCredit ? Colors.green : Colors.red,
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
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                SizedBox(height: SizeTokens.p4),
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
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${isCredit ? '+' : '-'}${item.tokenAmount} ",
                  style: TextStyle(
                    fontSize: SizeTokens.f16,
                    fontWeight: FontWeight.bold,
                    color: isCredit ? Colors.green : Colors.red,
                    fontFamily: 'Inter',
                  ),
                ),
                TextSpan(
                  text: "DP",
                  style: TextStyle(
                    fontSize: SizeTokens.f10,
                    fontWeight: FontWeight.bold,
                    color: (isCredit ? Colors.green : Colors.red).withOpacity(
                      0.7,
                    ),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
