import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/responsive/size_tokens.dart';
import '../../../core/widgets/dp_symbol.dart';
import 'memory_game_button.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final int tokenBalance;
  final int cartItemCount;
  final VoidCallback? onCartTap;
  final VoidCallback? onNotificationTap;
  final bool isGamePlayable;
  final DateTime? nextGamePlayableAt;
  final VoidCallback? onGameTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.tokenBalance,
    this.cartItemCount = 0,
    this.onCartTap,
    this.onNotificationTap,
    this.isGamePlayable = false,
    this.nextGamePlayableAt,
    this.onGameTap,
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

  String get _firstName {
    final normalized = userName.trim();
    if (normalized.isEmpty) {
      return 'Kullanıcı';
    }

    return normalized.split(RegExp(r'\s+')).first;
  }

  double _getNameFontSize() {
    final baseFontSize = (SizeTokens.f24 + 4).toDouble();
    const maxCharacterCount = 7;
    final characterCount = _firstName.length;

    if (characterCount <= maxCharacterCount) {
      return baseFontSize;
    }

    return baseFontSize * (maxCharacterCount / characterCount);
  }

  @override
  Widget build(BuildContext context) {
    final firstName = _firstName;
    final nameFontSize = _getNameFontSize();

    return Container(
      width: double.infinity,
      color: AppColors.blue,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              SizeTokens.p24,
              SizeTokens.p10,
              SizeTokens.p24,
              SizeTokens.p80,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
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
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              firstName,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontSize: nameFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                                height: 1,
                              ),
                            ),
                          ),
                          Text(
                            _greeting,
                            style: TextStyle(
                              fontSize: SizeTokens.f14,
                              // ignore: deprecated_member_use
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: SizeTokens.p12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: SizeTokens.p48,
                          width: SizeTokens.p48,
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: onNotificationTap,
                          ),
                        ),
                        SizedBox(height: SizeTokens.p8),
                        MemoryGameButton(
                          isPlayable: isGamePlayable,
                          nextPlayableAt: nextGamePlayableAt,
                          onTap: onGameTap,
                        ),
                      ],
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
                        DpSymbol(size: SizeTokens.p24, color: Colors.white),
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
