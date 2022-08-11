import 'dart:convert';

import 'default_text.dart';
import 'language_text.dart';

class Name {
  DefaultText? defaultText;
  List<LanguageText>? languageTexts;

  Name({this.defaultText, this.languageTexts});

  @override
  String toString() {
    return 'Name(defaultText: $defaultText, languageTexts: $languageTexts)';
  }

  factory Name.fromMap(Map<String, dynamic> data) => Name(
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
  /// Parses the string and returns the resulting Json object as [Name].
  factory Name.fromJson(String data) {
    return Name.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Name] to a JSON string.
  String toJson() => json.encode(toMap());

  Name copyWith({
    DefaultText? defaultText,
    List<LanguageText>? languageTexts,
  }) {
    return Name(
      defaultText: defaultText ?? this.defaultText,
      languageTexts: languageTexts ?? this.languageTexts,
    );
  }
}
