import 'dart:convert';

class OrgRef {
  String? name;
  String? id;

  OrgRef({this.name, this.id});

  @override
  String toString() => 'OrgRef(name: $name, id: $id)';

  factory OrgRef.fromMap(Map<String, dynamic> data) => OrgRef(
        name: data['name'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrgRef].
  factory OrgRef.fromJson(String data) {
    return OrgRef.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OrgRef] to a JSON string.
  String toJson() => json.encode(toMap());

  OrgRef copyWith({
    String? name,
    String? id,
  }) {
    return OrgRef(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }
}
