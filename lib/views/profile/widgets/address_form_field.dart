import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';

class AddressFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData? icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;

  const AddressFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: SizeTokens.f14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeTokens.p8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          style: TextStyle(color: AppColors.darkBlue, fontSize: SizeTokens.f14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.gray.withOpacity(0.5),
              fontSize: SizeTokens.f14,
            ),
            prefixIcon: icon != null
                ? Icon(icon, color: AppColors.blue, size: SizeTokens.p20)
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(SizeTokens.p16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeTokens.r12),
              borderSide: BorderSide(color: AppColors.gray.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeTokens.r12),
              borderSide: BorderSide(color: AppColors.gray.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeTokens.r12),
              borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeTokens.r12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }
}
