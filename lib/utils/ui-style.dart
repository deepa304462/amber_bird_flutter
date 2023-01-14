import 'package:flutter/material.dart';

class Fonts {
  static String get body => "Poppins";
  static String get title => "Poppins";
}

class AppColors {
  static Color primeColor = HexColor("#8e192d"); //Colors.red.shade800;
  static Color white = Colors.white;
  static Color secondaryColor = Color.fromARGB(255, 244, 182, 218);
  static Color lightGrey = const Color.fromARGB(255, 235, 239, 241);
  static Color darkOrange = Color.fromARGB(213, 255, 192, 46);
  static Color grey = HexColor("#989898");
  static Color golden = HexColor("#e1b530");
  static Color backgroundGrey = HexColor("#efefef");
  static Color black = HexColor("#000000");
}

class FontSizes {
  static double scale = 1;

  static double get body => 12 * scale;
  static double get bodySm => 10 * scale;

  static double get title => 16 * scale;
  static double get title2 => 20 * scale;
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
  static TextStyle get headingFontBlue => TextStyle(
      fontFamily: Fonts.title,
      fontSize: FontSizes.title,
      fontWeight: FontWeight.bold,
      color: Colors.blueAccent);
  static TextStyle get subHeadingFont => TextStyle(
      fontFamily: Fonts.body, fontSize: FontSizes.body, color: Colors.grey);
  static TextStyle get titleXLargeWhite => TextStyle(
      fontFamily: Fonts.title, fontSize: FontSizes.xLarge, color: Colors.white);
  static TextStyle get titleXLargePrimary => TextStyle(
      fontFamily: Fonts.title,
      fontSize: FontSizes.xLarge,
      color: AppColors.primeColor);
  static TextStyle get titleXLargeGreen => TextStyle(
      fontFamily: Fonts.title, fontSize: FontSizes.xLarge, color: Colors.green);
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
  static TextStyle get titleLargeSemiBold => TextStyle(
      fontFamily: Fonts.title,
      fontSize: FontSizes.title2,
      fontWeight: FontWeight.w600);
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
  static TextStyle get bodyRedBold => bodyFont.copyWith(
      fontSize: FontSizes.body, fontWeight: FontWeight.w800, color: Colors.red);
  static TextStyle get titleGreen => titleFont.copyWith(
      fontSize: FontSizes.title,
      fontWeight: FontWeight.w500,
      color: Colors.green);
      static TextStyle get title2Green => titleFont.copyWith(
      fontSize: FontSizes.title2,
      fontWeight: FontWeight.w500,
      color: Colors.green);
  static TextStyle get bodyWhite => bodyFont.copyWith(
      fontSize: FontSizes.body,
      fontWeight: FontWeight.w300,
      color: Colors.white);
  static TextStyle get bodyWhiteBold => bodyFont.copyWith(
      fontSize: FontSizes.body,
      fontWeight: FontWeight.w600,
      color: Colors.white);
  static TextStyle get bodyWhiteLarge => bodyFont.copyWith(
      fontSize: FontSizes.large,
      fontWeight: FontWeight.w300,
      color: Colors.white);
  static TextStyle get bodyWhiteTitle2 => bodyFont.copyWith(
      fontSize: FontSizes.title2,
      fontWeight: FontWeight.w300,
      color: Colors.white);
  static TextStyle get bodyWhiteLargeBold => bodyFont.copyWith(
      fontSize: FontSizes.large,
      fontWeight: FontWeight.w700,
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

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
