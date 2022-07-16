import 'package:flutter/material.dart';

class Fonts {
  static String get body => "Lato";
  static String get title => "Barlow";
}

class FontSizes {
  static double scale = 1;

  static double get body => 14 * scale;
  static double get bodySm => 12 * scale;

  static double get title => 16 * scale;
  static double get xLarge => 28 * scale;
  static double get large => 22 * scale;
}

class TextStyles {
  static TextStyle get bodyFont => TextStyle(fontFamily: Fonts.body);
  static TextStyle get titleFont => TextStyle(fontFamily: Fonts.title);
  static TextStyle get titleXLargeWhite => TextStyle(
      fontFamily: Fonts.title, fontSize: FontSizes.xLarge, color: Colors.white);
  static TextStyle get titleXLarge =>
      TextStyle(fontFamily: Fonts.title, fontSize: FontSizes.xLarge);

  static TextStyle get title => titleFont.copyWith(fontSize: FontSizes.title);
  static TextStyle get titleWhite =>
      titleFont.copyWith(fontSize: FontSizes.title, color: Colors.white);
  static TextStyle get titleLight =>
      title.copyWith(fontWeight: FontWeight.w300);

  static TextStyle get body =>
      bodyFont.copyWith(fontSize: FontSizes.body, fontWeight: FontWeight.w300);
  static TextStyle get bodyWhite => bodyFont.copyWith(
      fontSize: FontSizes.body,
      fontWeight: FontWeight.w300,
      color: Colors.white);
  static TextStyle get bodyWhiteLarge => bodyFont.copyWith(
      fontSize: FontSizes.large,
      fontWeight: FontWeight.w300,
      color: Colors.white);
  static TextStyle get bodySm => body.copyWith(fontSize: FontSizes.bodySm);
}
