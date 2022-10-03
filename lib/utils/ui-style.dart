import 'package:flutter/material.dart';

class Fonts {
  static String get body => "Lato";
  static String get title => "Barlow";
}

class AppColors {
  static Color primeColor = Colors.red.shade800;
  static Color white = Colors.white;
  static Color secondaryColor = Color.fromARGB(255, 244, 182, 218);
  static Color lightGrey = const Color.fromARGB(255, 235, 239, 241);
  static Color darkOrange = Color.fromARGB(213, 255, 192, 46);
  static Color grey = Color.fromARGB(212, 120, 119, 117);
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
  static TextStyle get detailProductName => TextStyle(
      fontFamily: Fonts.title,
      fontSize: FontSizes.xLarge,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 56, 53, 53));

  static TextStyle get bodyFont => TextStyle(fontFamily: Fonts.body);
  static TextStyle get bodyFontBold =>
      TextStyle(fontFamily: Fonts.body, fontWeight: FontWeight.bold);
  static TextStyle get titleFont => TextStyle(fontFamily: Fonts.title);
  static TextStyle get headingFont => TextStyle(
      fontFamily: Fonts.title,
      fontSize: FontSizes.title,
      fontWeight: FontWeight.bold,
      color: Colors.black);
  static TextStyle get headingFontGray => TextStyle(
      fontFamily: Fonts.title,
      fontSize: FontSizes.title,
      fontWeight: FontWeight.bold,
      color: Colors.grey);
  static TextStyle get subHeadingFont => TextStyle(
      fontFamily: Fonts.body, fontSize: FontSizes.body, color: Colors.grey);
  static TextStyle get titleXLargeWhite => TextStyle(
      fontFamily: Fonts.title, fontSize: FontSizes.xLarge, color: Colors.white);
  static TextStyle get titleXLargePrimary => TextStyle(
      fontFamily: Fonts.title,
      fontSize: FontSizes.xLarge,
      color: AppColors.primeColor);
  static TextStyle get titleXLargePrimaryBold => TextStyle(
      fontFamily: Fonts.title,
      fontWeight: FontWeight.w900,
      fontSize: FontSizes.xLarge,
      color: AppColors.primeColor);
  static TextStyle get titleXLarge =>
      TextStyle(fontFamily: Fonts.title, fontSize: FontSizes.xLarge);
  static TextStyle get titleXLargeBold => TextStyle(
      fontFamily: Fonts.title,
      fontSize: FontSizes.xLarge,
      fontWeight: FontWeight.w800);
  static TextStyle get titleLarge =>
      TextStyle(fontFamily: Fonts.title, fontSize: FontSizes.large);
  static TextStyle get titleLargeBold => TextStyle(
      fontFamily: Fonts.title,
      fontSize: FontSizes.large,
      fontWeight: FontWeight.bold);
  static TextStyle get title => titleFont.copyWith(fontSize: FontSizes.title);
  static TextStyle get titleLast =>
      titleFont.copyWith(fontSize: FontSizes.body);
  static TextStyle get titleWhite =>
      titleFont.copyWith(fontSize: FontSizes.title, color: Colors.white);
  static TextStyle get titleLight =>
      title.copyWith(fontWeight: FontWeight.w300);

  static TextStyle get body =>
      bodyFont.copyWith(fontSize: FontSizes.body, fontWeight: FontWeight.w300);
  static TextStyle get bodyGreen => bodyFont.copyWith(
      fontSize: FontSizes.body,
      fontWeight: FontWeight.w500,
      color: Colors.green);
  static TextStyle get titleGreen => titleFont.copyWith(
      fontSize: FontSizes.title,
      fontWeight: FontWeight.w500,
      color: Colors.green);
  static TextStyle get bodyWhite => bodyFont.copyWith(
      fontSize: FontSizes.body,
      fontWeight: FontWeight.w300,
      color: Colors.white);
  static TextStyle get bodyWhiteLarge => bodyFont.copyWith(
      fontSize: FontSizes.large,
      fontWeight: FontWeight.w300,
      color: Colors.white);
  static TextStyle get addTocartText => bodyFont.copyWith(
      fontSize: FontSizes.title,
      fontWeight: FontWeight.w500,
      color: Colors.white);
  static TextStyle get bodyPrimaryLarge => bodyFont.copyWith(
      fontSize: FontSizes.large,
      fontWeight: FontWeight.w300,
      color: AppColors.primeColor);
  static TextStyle get bodySm => body.copyWith(fontSize: FontSizes.bodySm);
  static TextStyle get mrpStyle => TextStyle(
      fontFamily: Fonts.title,
      fontSize: FontSizes.body,
      color: Color.fromARGB(255, 104, 35, 35));

  static TextStyle get prieLinThroughStyle => TextStyle(
      fontFamily: Fonts.title,
      fontSize: FontSizes.body,
      decoration: TextDecoration.lineThrough,
      color: Color.fromARGB(255, 196, 186, 186));
}
