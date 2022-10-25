import 'dart:convert';

class UiConfig {
  String? themeColor;
  String? secondaryColor;

  UiConfig({this.themeColor, this.secondaryColor});

  @override
  String toString() {
    return 'UiConfig(themeColor: $themeColor, secondaryColor: $secondaryColor)';
  }

  factory UiConfig.fromMap(Map<String, dynamic> data) => UiConfig(
        themeColor: data['themeColor'] as String?,
        secondaryColor: data['secondaryColor'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'themeColor': themeColor,
        'secondaryColor': secondaryColor,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UiConfig].
  factory UiConfig.fromJson(String data) {
    return UiConfig.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UiConfig] to a JSON string.
  String toJson() => json.encode(toMap());
}
