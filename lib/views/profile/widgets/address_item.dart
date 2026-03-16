import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';
import '../../../models/address_model.dart';

class AddressItem extends StatelessWidget {
  final Address address;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSetDefault;

  const AddressItem({
    super.key,
    required this.address,
    this.onEdit,
    this.onDelete,
    this.onSetDefault,
  });

  bool get _isShipping => address.addressType == 'shipping';
  bool get _isCorporate => address.billingType == 'corporate';

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
                Row(
                  children: [
                    Icon(
                      _isShipping
                          ? Icons.local_shipping_outlined
                          : Icons.receipt_long_outlined,
                      size: SizeTokens.f16,
                      color: AppColors.darkBlue.withOpacity(0.6),
                    ),
                    SizedBox(width: SizeTokens.p8),
                    Text(
                      address.title,
                      style: TextStyle(
                        color: AppColors.darkBlue.withOpacity(0.9),
                        fontSize: SizeTokens.f16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (!_isShipping)
                      Container(
                        margin: EdgeInsets.only(right: SizeTokens.p6),
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeTokens.p8,
                          vertical: SizeTokens.p4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          _isCorporate ? "Kurumsal" : "Bireysel",
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: SizeTokens.f10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (address.isDefault)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeTokens.p8,
                          vertical: SizeTokens.p4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          "Varsayılan",
                          style: TextStyle(
                            color: AppColors.blue,
                            fontSize: SizeTokens.f10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
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
                // Full name (shipping & individual billing)
                if (address.fullName.isNotEmpty) ...[
                  Text(
                    address.fullName,
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: SizeTokens.f14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeTokens.p6),
                ],

                // Shipping-specific: neighborhood, city/district
                if (_isShipping) ...[
                  if (address.neighborhood.isNotEmpty)
                    Text(
                      address.neighborhood,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: SizeTokens.f14,
                      ),
                    ),
                  SizedBox(height: SizeTokens.p4),
                ],

                // Address line
                if (address.addressLine1.isNotEmpty)
                  Text(
                    address.addressLine1,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: SizeTokens.f14,
                    ),
                  ),

                // City/District (shipping)
                if (_isShipping &&
                    (address.district.isNotEmpty || address.city.isNotEmpty)) ...[
                  SizedBox(height: SizeTokens.p4),
                  Text(
                    "${address.district}/${address.city}",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: SizeTokens.f14,
                    ),
                  ),
                ],

                // Phone
                if (address.phone.isNotEmpty) ...[
                  SizedBox(height: SizeTokens.p4),
                  Text(
                    address.phone,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: SizeTokens.f14,
                    ),
                  ),
                ],

                // Postal code (shipping)
                if (_isShipping &&
                    address.postalCode != null &&
                    address.postalCode!.isNotEmpty) ...[
                  SizedBox(height: SizeTokens.p4),
                  Text(
                    address.postalCode!,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: SizeTokens.f14,
                    ),
                  ),
                ],

                // Corporate billing details
                if (!_isShipping && _isCorporate) ...[
                  if (address.billingCompanyTitle != null &&
                      address.billingCompanyTitle!.isNotEmpty) ...[
                    SizedBox(height: SizeTokens.p12),
                    Container(
                      padding: EdgeInsets.all(SizeTokens.p12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(SizeTokens.r8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.business_rounded,
                                size: 16,
                                color: AppColors.darkBlue,
                              ),
                              SizedBox(width: SizeTokens.p8),
                              Expanded(
                                child: Text(
                                  address.billingCompanyTitle!,
                                  style: TextStyle(
                                    color: AppColors.darkBlue,
                                    fontSize: SizeTokens.f13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (address.billingTaxOffice != null ||
                              address.billingTaxNumber != null) ...[
                            SizedBox(height: SizeTokens.p4),
                            Text(
                              "${address.billingTaxOffice ?? ''} / ${address.billingTaxNumber ?? ''}",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: SizeTokens.f12,
                              ),
                            ),
                          ],
                          if (address.billingInvoiceEmail != null &&
                              address.billingInvoiceEmail!.isNotEmpty) ...[
                            SizedBox(height: SizeTokens.p4),
                            Text(
                              address.billingInvoiceEmail!,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: SizeTokens.f12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],

                // Individual billing details
                if (!_isShipping && !_isCorporate) ...[
                  if (address.billingIdentityNumber != null &&
                      address.billingIdentityNumber!.isNotEmpty) ...[
                    SizedBox(height: SizeTokens.p8),
                    Row(
                      children: [
                        Icon(
                          Icons.credit_card_outlined,
                          size: 14,
                          color: AppColors.gray,
                        ),
                        SizedBox(width: SizeTokens.p6),
                        Text(
                          "TC: ${address.billingIdentityNumber!}",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: SizeTokens.f12,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (address.billingInvoiceEmail != null &&
                      address.billingInvoiceEmail!.isNotEmpty) ...[
                    SizedBox(height: SizeTokens.p4),
                    Text(
                      address.billingInvoiceEmail!,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: SizeTokens.f12,
                      ),
                    ),
                  ],
                ],

                SizedBox(height: SizeTokens.p16),

                // Footer Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Delete Button
                        InkWell(
                          onTap: onDelete,
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.grey.shade600,
                                size: 22,
                              ),
                              SizedBox(width: SizeTokens.p4),
                              Text(
                                "Sil",
                                style: TextStyle(
                                  color: AppColors.darkBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeTokens.f14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (onSetDefault != null) ...[
                          SizedBox(width: SizeTokens.p16),
                          InkWell(
                            onTap: onSetDefault,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star_border_rounded,
                                  color: AppColors.blue,
                                  size: 20,
                                ),
                                SizedBox(width: SizeTokens.p4),
                                Text(
                                  "Varsayılan Yap",
                                  style: TextStyle(
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: SizeTokens.f13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Edit Button
                    SizedBox(
                      height: 38,
                      child: OutlinedButton(
                        onPressed: onEdit,
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
                        child: Text(
                          "Adresi Düzenle",
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeTokens.f10,
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
}

