import 'package:flutter/material.dart';

class UniversalVariables {
  static final Color whiteColor = Color(0xFFFFFFFF);
  static final Color blueColor = Color(0xff2b9ed4);
  static final Color blackColor = Color(0xff19191b);
  static final Color greyColor = Color(0xff8f8f8f);
  static final Color userCircleBackground = Color(0xff2b2b33);
  static final Color onlineDotColor = Color(0xff46dc64);
  static final Color lightBlueColor = Color(0xff0077d7);
  static final Color separatorColor = Color(0xff272c35);

  static final Color gradientColorStart = Color(0xff00b6f3);
  static final Color gradientColorEnd = Color(0xff0184dc);
  static final Color smileEmojiColor = Color(0xFFFFCC00);
  static final Color inputColor = Color(0x7366D8A7);
  static const kPrimaryColor = Color(0xFF0B6BEA);
  static const kContentColorLightTheme = Color(0xFF1D1D35);
  static const kContentColorDarkTheme = Color(0xFFF5FCF9);
  static const kErrorColor = Color(0xFFF03738);
  static const defaultFont = "Times New Roman";
  static final Gradient fabGradient = LinearGradient(
      colors: [gradientColorStart, gradientColorEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
}
