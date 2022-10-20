import 'dart:convert';

class Reason {
  String? code;
  String? description;

  Reason({this.code, this.description});

  @override
  String toString() => 'Reason(code: $code, description: $description)';

  factory Reason.fromMap(Map<String, dynamic> data) => Reason(
        code: data['code'] as String?,
        description: data['description'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'code': code,
        'description': description,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Reason].
  factory Reason.fromJson(String data) {
    return Reason.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Reason] to a JSON string.
  String toJson() => json.encode(toMap());

  Reason copyWith({
    String? code,
    String? description,
  }) {
    return Reason(
      code: code ?? this.code,
      description: description ?? this.description,
    );
  }
}
