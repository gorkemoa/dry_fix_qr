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
    // Orange color from the design image

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
                Text(
                  address.title,
                  style: TextStyle(
                    color: AppColors.darkBlue.withOpacity(0.9),
                    fontSize: SizeTokens.f16,
                    fontWeight: FontWeight.bold,
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
          ),
          Divider(height: 1, color: const Color.fromARGB(255, 188, 188, 188)),

          // Body Section
          Padding(
            padding: EdgeInsets.all(SizeTokens.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.fullName,
                  style: TextStyle(
                    color: AppColors.darkBlue,
                    fontSize: SizeTokens.f14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: SizeTokens.p6),
                Text(
                  address.neighborhood,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: SizeTokens.f14,
                  ),
                ),
                SizedBox(height: SizeTokens.p4),
                Text(
                  "${address.addressLine1}${address.addressLine2 != null ? ' ${address.addressLine2}' : ''}",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: SizeTokens.f14,
                  ),
                ),
                SizedBox(height: SizeTokens.p4),
                Text(
                  "${address.district}/${address.city}",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: SizeTokens.f14,
                  ),
                ),
                SizedBox(height: SizeTokens.p4),
                Text(
                  address.phone,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: SizeTokens.f14,
                  ),
                ),
                SizedBox(height: SizeTokens.p16),

                // Footer Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        child: const Text(
                          "Adresi Düzenle",
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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
