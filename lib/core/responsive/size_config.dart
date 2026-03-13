import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  // Cap at 844 (iPhone 13 height) to prevent over-scaling on large devices
  double screenHeight = SizeConfig.screenHeight.clamp(0.0, 844.0);
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate width as per screen size
double getProportionateScreenWidth(double inputWidth) {
  // Cap at 390 (iPhone 13 width) to prevent over-scaling on large devices
  double screenWidth = SizeConfig.screenWidth.clamp(0.0, 390.0);
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}
