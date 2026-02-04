import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';

import 'package:flutter_svg/flutter_svg.dart';

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
              Row(
                children: [
                  SvgPicture.asset('assets/dry_fix.svg', height: 30, width: 30),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
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
          SizedBox(height: SizeTokens.p24),
          // Balance Card
          Container(
            padding: EdgeInsets.all(SizeTokens.p24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF001A3D), Color(0xFF002452)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(SizeTokens.r12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkBlue.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(SizeTokens.p12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SizeTokens.r12),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(width: SizeTokens.p16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${userName.toUpperCase()} DRYPARA BAKİYESİ",
                        style: TextStyle(
                          fontSize: SizeTokens.f12,
                          color: Colors.white.withOpacity(0.6),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "$tokenBalance",
                            style: TextStyle(
                              fontSize: SizeTokens.f32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: SizeTokens.p4),
                          Text(
                            "DryPara",
                            style: TextStyle(
                              fontSize: SizeTokens.f16,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
