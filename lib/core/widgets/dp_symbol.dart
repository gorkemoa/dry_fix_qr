import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../responsive/size_tokens.dart';

class DpSymbol extends StatelessWidget {
  final double? size;
  final Color? color;

  const DpSymbol({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/DPara.svg',
      height: size ?? SizeTokens.p24,
      width: size ?? SizeTokens.p24,
      colorFilter: ColorFilter.mode(color ?? Colors.white, BlendMode.srcIn),
    );
  }
}
