import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';
import '../../../models/history_model.dart' as model;
import '../../../core/utils/date_utils.dart';

class HistoryItem extends StatefulWidget {
  final model.HistoryItem item;

  const HistoryItem({super.key, required this.item});

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    bool isCredit = widget.item.direction == 'credit';

    return Container(
      margin: EdgeInsets.only(bottom: SizeTokens.p12),
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (value) {
            setState(() {
              _isExpanded = value;
            });
          },
          tilePadding: EdgeInsets.symmetric(
            horizontal: SizeTokens.p16,
            vertical: SizeTokens.p8,
          ),
          trailing: Icon(
            _isExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: AppColors.gray,
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(SizeTokens.p10),
                decoration: BoxDecoration(
                  color: (isCredit ? Colors.green : Colors.red).withOpacity(
                    0.08,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCredit ? Icons.add_rounded : Icons.remove_rounded,
                  color: isCredit ? Colors.green : Colors.red,
                  size: SizeTokens.p20,
                ),
              ),
              SizedBox(width: SizeTokens.p16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.note.toLowerCase().contains(
                            'qr okuma kazancı',
                          )
                          ? 'QR Okuma Kazancı'
                          : widget.item.note,
                      style: TextStyle(
                        fontSize: SizeTokens.f14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    SizedBox(height: SizeTokens.p4),
                    Text(
                      DateFormatter.toTurkish(widget.item.createdAt),
                      style: TextStyle(
                        fontSize: SizeTokens.f12,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                SizeTokens.p16,
                0,
                SizeTokens.p16,
                SizeTokens.p16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  SizedBox(height: SizeTokens.p16),
                  _buildDetailRow("İşlem No", "#${widget.item.id}"),
                  SizedBox(height: SizeTokens.p12),
                  _buildDetailRow(
                    "Tam Tarih",
                    DateFormatter.toTurkish(widget.item.createdAt),
                  ),
                  SizedBox(height: SizeTokens.p12),
                  _buildDetailRow(
                    "İşlem Tipi",
                    isCredit ? "Yükleme (Kazanç)" : "Harcama",
                  ),
                  SizedBox(height: SizeTokens.p12),
                  _buildDetailRow(
                    "İşlem Nedeni",
                    _getReasonText(widget.item.reason),
                  ),
                  SizedBox(height: SizeTokens.p12),
                  _buildDetailRow(
                    "Miktar",
                    "${isCredit ? '+' : '-'}${widget.item.tokenAmount} DP",
                    isValueColored: true,
                    isCredit: isCredit,
                  ),
                  SizedBox(height: SizeTokens.p12),
                  _buildDetailRow("Açıklama", widget.item.note),
                  if (widget.item.orderId != null) ...[
                    SizedBox(height: SizeTokens.p12),
                    _buildDetailRow("Sipariş No", "#${widget.item.orderId}"),
                  ],
                  if (widget.item.qr != null) ...[
                    SizedBox(height: SizeTokens.p16),
                    Container(
                      padding: EdgeInsets.all(SizeTokens.p12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(SizeTokens.r12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: SizeTokens.p50,
                            height: SizeTokens.p50,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(
                                SizeTokens.r8,
                              ),
                              border: Border.all(
                                color: AppColors.gray.withOpacity(0.1),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  widget.item.qr!.product.image,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: SizeTokens.p12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.item.qr!.product.name,
                                  style: TextStyle(
                                    fontSize: SizeTokens.f13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkBlue,
                                  ),
                                ),
                                Text(
                                  "Ürün Kodu: ${widget.item.qr!.code}",
                                  style: TextStyle(
                                    fontSize: SizeTokens.f11,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isValueColored = false,
    bool isCredit = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: SizeTokens.f12,
              color: AppColors.gray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: SizeTokens.f12,
              color: isValueColored
                  ? (isCredit ? Colors.green : Colors.red)
                  : AppColors.darkBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _getReasonText(String reason) {
    switch (reason) {
      case 'qr_scan':
        return 'QR Okuma';
      case 'purchase':
        return 'Satın Alma';
      default:
        if (reason.isEmpty) return 'Belirtilmedi';
        return reason[0].toUpperCase() + reason.substring(1);
    }
  }
}
