import 'dart:convert';

import 'default_text.dart';
import 'language_text.dart';

class Description {
  DefaultText? defaultText;
  List<LanguageText>? languageTexts;

  Description({this.defaultText, this.languageTexts});

  @override
  String toString() {
    return 'Description(defaultText: $defaultText, languageTexts: $languageTexts)';
  }

  factory Description.fromMap(Map<String, dynamic> data) => Description(
        defaultText: data['defaultText'] == null
            ? null
            : DefaultText.fromMap(data['defaultText'] as Map<String, dynamic>),
        languageTexts: (data['languageTexts'] as List<dynamic>?)
            ?.map((e) => LanguageText.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'defaultText': defaultText?.toMap(),
        'languageTexts': languageTexts?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Description].
  factory Description.fromJson(String data) {
    return Description.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Description] to a JSON string.
  String toJson() => json.encode(toMap());

  Description copyWith({
    DefaultText? defaultText,
    List<LanguageText>? languageTexts,
  }) {
    return Description(
      defaultText: defaultText ?? this.defaultText,
      languageTexts: languageTexts ?? this.languageTexts,
    );
  }
}
