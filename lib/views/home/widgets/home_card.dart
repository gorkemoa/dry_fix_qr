import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';

class HomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const HomeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeTokens.r12),
        border: Border.all(color: AppColors.darkBlue.withOpacity(0.08)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(SizeTokens.r12),
          child: Padding(
            padding: EdgeInsets.all(SizeTokens.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(SizeTokens.p8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(SizeTokens.r8),
                  ),
                  child: Icon(icon, color: iconColor, size: SizeTokens.p24),
                ),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: SizeTokens.f16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: SizeTokens.p2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: SizeTokens.f12,
                    color: AppColors.gray,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
