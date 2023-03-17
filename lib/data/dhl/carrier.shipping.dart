import 'dart:convert';

class Carrier {
  String? type;
  String? organizationName;

  Carrier({this.type, this.organizationName});

  @override
  String toString() {
    return 'Carrier(type: $type, organizationName: $organizationName)';
  }

  factory Carrier.fromMap(Map<String, dynamic> data) => Carrier(
        type: data['@type'] as String?,
        organizationName: data['organizationName'] as String?,
      );

  Map<String, dynamic> toMap() => {
        '@type': type,
        'organizationName': organizationName,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Carrier].
  factory Carrier.fromJson(String data) {
    return Carrier.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Carrier] to a JSON string.
  String toJson() => json.encode(toMap());

  Carrier copyWith({
    String? type,
    String? organizationName,
  }) {
    return Carrier(
      type: type ?? this.type,
      organizationName: organizationName ?? this.organizationName,
    );
  }
}
