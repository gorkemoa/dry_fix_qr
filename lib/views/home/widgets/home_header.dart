import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final int tokenBalance;
  final int cartItemCount;
  final VoidCallback? onCartTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.tokenBalance,
    this.cartItemCount = 0,
    this.onCartTap,
  });

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Günaydın";
    } else if (hour >= 12 && hour < 18) {
      return "İyi Günler";
    } else if (hour >= 18 && hour < 22) {
      return "İyi Akşamlar";
    } else {
      return "İyi Geceler";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.blue,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              SizeTokens.p24,
              SizeTokens.p32,
              SizeTokens.p24,
              SizeTokens.p80,
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
                          "Merhaba",
                          style: TextStyle(
                            fontSize: SizeTokens.f24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          userName.split(' ').first,
                          style: TextStyle(
                            fontSize: SizeTokens.f24 + 4,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          _greeting,
                          style: TextStyle(
                            fontSize: SizeTokens.f14,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: SizeTokens.p48,
                      width: SizeTokens.p48,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: -SizeTokens.p97,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/mascot.png',
                    height: SizeTokens.p280,
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    top: SizeTokens.p145, // Aligned with the dark blue board
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "$tokenBalance",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeTokens.f24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(width: SizeTokens.p4),
                        Text(
                          "DryPara",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeTokens.f12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
