import 'dart:convert';

class Brand {
  String? name;
  String? logoId;
  String? id;

  Brand({this.name, this.logoId, this.id});

  @override
  String toString() => 'Brand(name: $name, logoId: $logoId, id: $id)';

  factory Brand.fromMap(Map<String, dynamic> data) => Brand(
        name: data['name'] as String?,
        logoId: data['logoId'] as String?,
        id: data['id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'logoId': logoId,
        'id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Brand].
  factory Brand.fromJson(String data) {
    return Brand.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Brand] to a JSON string.
  String toJson() => json.encode(toMap());

  Brand copyWith({
    String? name,
    String? logoId,
    String? id,
  }) {
    return Brand(
      name: name ?? this.name,
      logoId: logoId ?? this.logoId,
      id: id ?? this.id,
    );
  }
}
