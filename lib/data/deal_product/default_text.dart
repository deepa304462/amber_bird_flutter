import 'dart:convert';

class DefaultText {
  String? language;
  String? text;

  DefaultText({this.language, this.text});

  @override
  String toString() => 'DefaultText(language: $language, text: $text)';

  factory DefaultText.fromMap(Map<String, dynamic> data) => DefaultText(
        language: data['language'] as String?,
        text: data['text'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'language': language,
        'text': text,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DefaultText].
  factory DefaultText.fromJson(String data) {
    return DefaultText.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DefaultText] to a JSON string.
  String toJson() => json.encode(toMap());

  DefaultText copyWith({
    String? language,
    String? text,
  }) {
    return DefaultText(
      language: language ?? this.language,
      text: text ?? this.text,
    );
  }
}
