import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';

class AddressFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool isRequired;
  final Widget? prefix;

  const AddressFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.isRequired = true,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: AppColors.darkBlue, // Darker gray for labels
              fontSize: SizeTokens.f14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.darkBlue),
                ),
            ],
          ),
        ),
        SizedBox(height: SizeTokens.p8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          style: TextStyle(
            color: AppColors.darkBlue,
            fontSize: SizeTokens.f14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: SizeTokens.f14,
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: prefix,
            filled: true,
            fillColor: AppColors.background, // Light gray as in image
            contentPadding: EdgeInsets.symmetric(
              horizontal: SizeTokens.p16,
              vertical: maxLines > 1 ? SizeTokens.p12 : 0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeTokens.r6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.blue, width: 1.2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }
}
