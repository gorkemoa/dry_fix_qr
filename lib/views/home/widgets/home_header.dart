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
    return Container(
      padding: EdgeInsets.fromLTRB(
        SizeTokens.p24,
        SizeTokens.p24,
        SizeTokens.p24,
        SizeTokens.p24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hoş geldiniz,",
                    style: TextStyle(
                      fontSize: SizeTokens.f14,
                      color: AppColors.gray,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: SizeTokens.f20,
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
                  border: Border.all(
                    color: AppColors.darkBlue.withOpacity(0.1),
                  ),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.darkBlue,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: SizeTokens.p20),
          Container(
            padding: EdgeInsets.all(SizeTokens.p16),
            decoration: BoxDecoration(
              color: AppColors.darkBlue,
              borderRadius: BorderRadius.circular(SizeTokens.r16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: SizeTokens.p12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DryPara Bakiyesi",
                      style: TextStyle(
                        fontSize: SizeTokens.f12,
                        color: AppColors.white.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      "$tokenBalance DryPara",
                      style: TextStyle(
                        fontSize: SizeTokens.f18,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
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
