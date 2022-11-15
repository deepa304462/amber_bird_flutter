import 'dart:convert';

class BrandSummary {
  String? name;
  String? logoId;
  String? id;

  BrandSummary({this.name, this.logoId, this.id});

  @override
  String toString() => 'Brand(name: $name, logoId: $logoId, id: $id)';

  factory BrandSummary.fromMap(Map<String, dynamic> data) => BrandSummary(
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
  /// Parses the string and returns the resulting Json object as [BrandSummary].
  factory BrandSummary.fromJson(String data) {
    return BrandSummary.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [BrandSummary] to a JSON string.
  String toJson() => json.encode(toMap());

  BrandSummary copyWith({
    String? name,
    String? logoId,
    String? id,
  }) {
    return BrandSummary(
      name: name ?? this.name,
      logoId: logoId ?? this.logoId,
      id: id ?? this.id,
    );
  }
}
