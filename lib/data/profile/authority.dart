import 'dart:convert';

class Authority {
  String? authority;

  Authority({this.authority});

  @override
  String toString() => 'Authority(authority: $authority)';

  factory Authority.fromMap(Map<String, dynamic> data) => Authority(
        authority: data['authority'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'authority': authority,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Authority].
  factory Authority.fromJson(String data) {
    return Authority.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Authority] to a JSON string.
  String toJson() => json.encode(toMap());

  Authority copyWith({
    String? authority,
  }) {
    return Authority(
      authority: authority ?? this.authority,
    );
  }
}
