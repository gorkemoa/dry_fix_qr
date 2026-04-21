import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/responsive/size_tokens.dart';

class MemoryGameResultOverlay extends StatelessWidget {
  final List<Color> overlayGradientColors;
  final String mascotAsset;
  final List<Color> cardGradientColors;
  final Color borderColor;
  final Color shadowColor;
  final IconData statusIcon;
  final Color statusColor;
  final String title;
  final Color titleColor;
  final double titleLetterSpacing;
  final bool showTitleDivider;
  final Color? dividerColor;
  final Widget description;
  final Widget infoCard;
  final List<Widget> bottomChildren;
  final double mascotSpacing;

  const MemoryGameResultOverlay({
    super.key,
    required this.overlayGradientColors,
    required this.mascotAsset,
    required this.cardGradientColors,
    required this.borderColor,
    required this.shadowColor,
    required this.statusIcon,
    required this.statusColor,
    required this.title,
    required this.titleColor,
    required this.description,
    required this.infoCard,
    required this.bottomChildren,
    this.titleLetterSpacing = 0,
    this.showTitleDivider = false,
    this.dividerColor,
    this.mascotSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    final dividerAccent = dividerColor ?? titleColor;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: overlayGradientColors,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: SizeTokens.p20),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: SizeTokens.p300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  mascotAsset,
                  height: SizeTokens.p145,
                  fit: BoxFit.contain,
                ),
                if (mascotSpacing > 0) SizedBox(height: mascotSpacing),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: cardGradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(SizeTokens.r20),
                    border: Border.all(color: borderColor, width: SizeTokens.p2),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: SizeTokens.p18,
                        spreadRadius: SizeTokens.p2,
                        offset: Offset(0, SizeTokens.p6),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(SizeTokens.p20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    
                      _MemoryGameResultHeading(
                        title: title,
                        color: titleColor,
                        letterSpacing: titleLetterSpacing,
                      ),
                      if (showTitleDivider) ...[
                        SizedBox(height: SizeTokens.p6),
                        Container(
                          height: SizeTokens.p2,
                          width: SizeTokens.p48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                dividerAccent,
                                Colors.transparent,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(SizeTokens.r4),
                          ),
                        ),
                      ],
                      SizedBox(height: SizeTokens.p10),
                      description,
                      SizedBox(height: SizeTokens.p12),
                      infoCard,
                      ...bottomChildren,
                    ],
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

class MemoryGameResultInfoCard extends StatelessWidget {
  final Color accentColor;
  final double borderAlpha;
  final Widget child;

  const MemoryGameResultInfoCard({
    super.key,
    required this.accentColor,
    required this.child,
    this.borderAlpha = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeTokens.p12,
        vertical: SizeTokens.p10,
      ),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(SizeTokens.r12),
        border: Border.all(color: accentColor.withValues(alpha: borderAlpha)),
      ),
      child: child,
    );
  }
}

class MemoryGameDpInlineText extends StatelessWidget {
  final Object amount;
  final String suffix;
  final TextStyle style;
  final String prefix;
  final TextAlign textAlign;

  const MemoryGameDpInlineText({
    super.key,
    required this.amount,
    required this.suffix,
    required this.style,
    this.prefix = '',
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = style.color ?? Colors.white;

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          if (prefix.isNotEmpty) TextSpan(text: prefix),
          TextSpan(text: '$amount '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeTokens.p4),
              child: SvgPicture.asset(
                'assets/DPara.svg',
                width: SizeTokens.p16,
                height: SizeTokens.p16,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
          TextSpan(text: suffix),
        ],
      ),
      textAlign: textAlign,
    );
  }
}

class _MemoryGameResultStatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MemoryGameResultStatusChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeTokens.p10,
        vertical: SizeTokens.p4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(SizeTokens.r20),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: SizeTokens.p16),
          SizedBox(width: SizeTokens.p4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: SizeTokens.f11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MemoryGameResultHeading extends StatelessWidget {
  final String title;
  final Color color;
  final double letterSpacing;

  const _MemoryGameResultHeading({
    required this.title,
    required this.color,
    required this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: SizeTokens.f20,
        fontWeight: FontWeight.w900,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
