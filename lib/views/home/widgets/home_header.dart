import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  const HomeHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeTokens.p24,
        vertical: SizeTokens.p16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hoş geldin,",
                style: TextStyle(
                  fontSize: SizeTokens.f16,
                  color: AppColors.gray,
                ),
              ),
              Text(
                userName,
                style: TextStyle(
                  fontSize: SizeTokens.f20 * 1.2,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(SizeTokens.r12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkBlue.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.menu, color: AppColors.darkBlue),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
