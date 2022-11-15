import 'dart:convert';

class Params {
  String? q;
  String? indent;

  Params({this.q, this.indent});

  factory Params.fromMap(Map<String, dynamic> data) => Params(
        q: data['q'] as String?,
        indent: data['indent'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'q': q,
        'indent': indent,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Params].
  factory Params.fromJson(String data) {
    return Params.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Params] to a JSON string.
  String toJson() => json.encode(toMap());
}
