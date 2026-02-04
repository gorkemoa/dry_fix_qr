import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../core/responsive/size_tokens.dart';
import '../../models/history_model.dart' as model;
import '../../core/utils/date_utils.dart';

class TransactionDetailView extends StatelessWidget {
  final model.HistoryItem item;

  const TransactionDetailView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    bool isCredit = item.direction == 'credit';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("İşlem Detayı"),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkBlue),
        titleTextStyle: TextStyle(
          color: AppColors.darkBlue,
          fontSize: SizeTokens.f18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeTokens.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(SizeTokens.p24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(SizeTokens.r24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(SizeTokens.p16),
                    decoration: BoxDecoration(
                      color: (isCredit ? Colors.green : Colors.red).withOpacity(
                        0.1,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCredit
                          ? Icons.add_chart_rounded
                          : Icons.shopping_cart_checkout_rounded,
                      color: isCredit ? Colors.green : Colors.red,
                      size: 32,
                    ),
                  ),
                  SizedBox(height: SizeTokens.p16),
                  Text(
                    "${isCredit ? '+' : '-'}${item.tokenAmount} DP",
                    style: TextStyle(
                      fontSize: SizeTokens.f32,
                      fontWeight: FontWeight.bold,
                      color: isCredit ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(height: SizeTokens.p8),
                  Text(
                    item.reason == 'qr_scan' ? 'QR Okuma Kazancı' : item.note,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeTokens.f16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  SizedBox(height: SizeTokens.p4),
                  Text(
                    DateFormatter.toTurkish(item.createdAt),
                    style: TextStyle(
                      fontSize: SizeTokens.f14,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeTokens.p24),

            // Details Section
            Text(
              "İşlem Bilgileri",
              style: TextStyle(
                fontSize: SizeTokens.f18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
            SizedBox(height: SizeTokens.p16),
            Container(
              padding: EdgeInsets.all(SizeTokens.p20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(SizeTokens.r20),
              ),
              child: Column(
                children: [
                  _buildDetailRow("İşlem ID", "#${item.id}"),
                  const Divider(height: 32),
                  _buildDetailRow(
                    "İşlem Tipi",
                    isCredit ? "Yükleme" : "Harcama",
                  ),
                  const Divider(height: 32),
                  _buildDetailRow("Açıklama", item.note),
                  if (item.orderId != null) ...[
                    const Divider(height: 32),
                    _buildDetailRow("Sipariş No", "#${item.orderId}"),
                  ],
                ],
              ),
            ),

            if (item.qr != null) ...[
              SizedBox(height: SizeTokens.p24),
              Text(
                "QR ve Ürün Bilgileri",
                style: TextStyle(
                  fontSize: SizeTokens.f18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
              SizedBox(height: SizeTokens.p16),
              Container(
                padding: EdgeInsets.all(SizeTokens.p16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(SizeTokens.r20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(SizeTokens.r12),
                        image: DecorationImage(
                          image: NetworkImage(item.qr!.product.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: SizeTokens.p16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.qr!.product.name,
                            style: TextStyle(
                              fontSize: SizeTokens.f16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBlue,
                            ),
                          ),
                          SizedBox(height: SizeTokens.p4),
                          Text(
                            "Kod: ${item.qr!.code}",
                            style: TextStyle(
                              fontSize: SizeTokens.f14,
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: SizeTokens.p32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: SizeTokens.f14,
              color: AppColors.gray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: SizeTokens.f14,
              color: AppColors.darkBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
