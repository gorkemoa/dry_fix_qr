import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';
import '../../../models/address_model.dart';

class AddressItem extends StatelessWidget {
  final Address address;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AddressItem({
    super.key,
    required this.address,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeTokens.p16),
      padding: EdgeInsets.all(SizeTokens.p16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: address.isDefault
            ? Border.all(color: AppColors.blue.withOpacity(0.3), width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(SizeTokens.p8),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(SizeTokens.r10),
                    ),
                    child: Icon(
                      _getIconForTitle(address.title),
                      color: AppColors.blue,
                      size: SizeTokens.p18,
                    ),
                  ),
                  SizedBox(width: SizeTokens.p12),
                  Text(
                    address.title,
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: SizeTokens.f16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (address.isDefault) ...[
                    SizedBox(width: SizeTokens.p8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeTokens.p8,
                        vertical: SizeTokens.p2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(SizeTokens.r20),
                      ),
                      child: Text(
                        "Varsayılan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeTokens.f10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  if (onEdit != null)
                    IconButton(
                      onPressed: onEdit,
                      icon: Icon(
                        Icons.edit_outlined,
                        color: AppColors.gray,
                        size: SizeTokens.p20,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  if (onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.redAccent,
                        size: SizeTokens.p20,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: SizeTokens.p12),
          Text(
            address.fullName,
            style: TextStyle(
              color: AppColors.darkBlue,
              fontSize: SizeTokens.f14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: SizeTokens.p4),
          Text(
            address.phone,
            style: TextStyle(color: AppColors.gray, fontSize: SizeTokens.f13),
          ),
          SizedBox(height: SizeTokens.p8),
          Text(
            "${address.addressLine1}${address.addressLine2 != null ? ' ${address.addressLine2}' : ''}",
            style: TextStyle(
              color: AppColors.darkBlue.withOpacity(0.8),
              fontSize: SizeTokens.f13,
              height: 1.4,
            ),
          ),
          Text(
            "${address.neighborhood} ${address.district} / ${address.city}",
            style: TextStyle(
              color: AppColors.darkBlue.withOpacity(0.8),
              fontSize: SizeTokens.f13,
              height: 1.4,
            ),
          ),
          if (address.postalCode.isNotEmpty)
            Text(
              address.postalCode,
              style: TextStyle(color: AppColors.gray, fontSize: SizeTokens.f12),
            ),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains("ev")) return Icons.home_rounded;
    if (lowerTitle.contains("iş") || lowerTitle.contains("ofis")) {
      return Icons.business_rounded;
    }
    return Icons.location_on_rounded;
  }
}
