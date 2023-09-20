import 'package:flutter/material.dart';

class Fonts {
  static String get body => "Poppins";
  // static String get title => "Poppins";
}

class AppColors {
  static Color primeColor = HexColor("#C71838"); //Colors.red.shade800;
  static Color off_red = HexColor("#FCF6F5"); //Colors.red.shade800;
  static Color white = Colors.white;
  static Color blue = Colors.blue;
  static Color cyan = Colors.cyan;
  static Color secondaryColor = Color.fromARGB(255, 104, 168, 136);
  static Color lightGrey = const Color.fromARGB(255, 235, 239, 241);
  static Color DarkGrey = HexColor("#393536");
  static Color darkOrange = const Color.fromARGB(213, 255, 192, 46);
  static Color grey = HexColor("#989898");
  static Color commonBgColor = HexColor("#FAFAFA");
  static Color golden = HexColor("#e1b530");
  static Color green = Colors.green;
  static Color orange = HexColor("#FF5F1F");
  static Color backgroundGrey = HexColor("#efefef");
  static Color electricBlue = HexColor("#00FFFF");
  static Color coralPink = HexColor("#FF7F50");
  static Color violetPurple = HexColor("#8A2BE2");
  static Color mintGreen = HexColor("#98FF98");
  static Color goldenYellow = HexColor("#FFD700");
  static Color royalPurple = HexColor("#6A0DAD");
  static Color tealBlue = HexColor("#008080");
  static Color salmonPink = HexColor("#FF8C69");
  static Color deepRed = HexColor("#8B0000");
  static Color black = HexColor("#000000");
  static Color neonGreen = HexColor("#39FF14");
  static Color teal = Colors.teal;
}

class FontSizes {
  static double scale = 1;

  static double get body => 12 * scale;
  static double get bodySm => 10 * scale;

  static double get title => 14 * scale;
  static double get title2 => 20 * scale;
  static double get xLarge => 28 * scale;
  static double get large => 22 * scale;
}

class TextStyles {
  static TextStyle get detailProductName => TextStyle(
      fontFamily: Fonts.body,
      fontSize: FontSizes.xLarge,
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 56, 53, 53));
  static TextStyle get bodyFont => TextStyle(fontFamily: Fonts.body);
  static TextStyle get bodyFontBold =>
      TextStyle(fontFamily: Fonts.body, fontWeight: FontWeight.bold);
  static TextStyle get titleFont => TextStyle(
      fontFamily: Fonts.body,
      fontSize: FontSizes.title,
      color: AppColors.DarkGrey);
  static TextStyle get linkFont => TextStyle(
      fontFamily: Fonts.body,
      fontSize: FontSizes.title,
      color: AppColors.blue);
  static TextStyle get headingFont => TextStyle(
      fontFamily: Fonts.body,
      fontSize: FontSizes.title,
      fontWeight: FontWeight.bold,
      color: AppColors.DarkGrey);
  static TextStyle get headingFont3 => TextStyle(
      fontFamily: Fonts.body,
      fontSize: FontSizes.title,
      fontWeight: FontWeight.bold,
      color:  AppColors.primeColor, );
  static TextStyle get headingFont2 => TextStyle(
      fontFamily: Fonts.body,
      fontSize: FontSizes.title2,
      fontWeight: FontWeight.bold,
      color: AppColors.DarkGrey);

  static TextStyle get body =>
      bodyFont.copyWith(fontSize: FontSizes.body, fontWeight: FontWeight.w300);

  static TextStyle get bodySm => body.copyWith(fontSize: FontSizes.bodySm);
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
