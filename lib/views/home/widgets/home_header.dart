import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final int tokenBalance;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.tokenBalance,
  });

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
          Expanded(
            child: Column(
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
                SizedBox(height: SizeTokens.p4),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeTokens.p8,
                    vertical: SizeTokens.p4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SizeTokens.r20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wallet,
                        color: AppColors.blue,
                        size: SizeTokens.f14,
                      ),
                      SizedBox(width: SizeTokens.p4),
                      Text(
                        "Bakiye: $tokenBalance",
                        style: TextStyle(
                          fontSize: SizeTokens.f14 * 0.9,
                          color: AppColors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
