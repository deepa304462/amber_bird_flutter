import 'dart:convert';

class ApplicableForProfileRef {
  String? name;
  String? id;

  ApplicableForProfileRef({this.name, this.id});

  @override
  String toString() => 'ApplicableForProfileRef(name: $name, id: $id)';

  factory ApplicableForProfileRef.fromMap(Map<String, dynamic> data) {
    return ApplicableForProfileRef(
      name: data['name'] as String?,
      id: data['_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ApplicableForProfileRef].
  factory ApplicableForProfileRef.fromJson(String data) {
    return ApplicableForProfileRef.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ApplicableForProfileRef] to a JSON string.
  String toJson() => json.encode(toMap());

  ApplicableForProfileRef copyWith({
    String? name,
    String? id,
  }) {
    return ApplicableForProfileRef(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }
}
