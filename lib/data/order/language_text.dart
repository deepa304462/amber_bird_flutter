import 'dart:convert';

class LanguageText {
  String? language;
  String? text;

  LanguageText({this.language, this.text});

  @override
  String toString() => 'LanguageText(language: $language, text: $text)';

  factory LanguageText.fromMap(Map<String, dynamic> data) => LanguageText(
        language: data['language'] as String?,
        text: data['text'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'language': language,
        'text': text,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LanguageText].
  factory LanguageText.fromJson(String data) {
    return LanguageText.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LanguageText] to a JSON string.
  String toJson() => json.encode(toMap());

  LanguageText copyWith({
    String? language,
    String? text,
  }) {
    return LanguageText(
      language: language ?? this.language,
      text: text ?? this.text,
    );
  }
}
