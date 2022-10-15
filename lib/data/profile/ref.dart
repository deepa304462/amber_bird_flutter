import 'dart:convert';

class Ref {
  String? name;
  String? id;

  Ref({this.name, this.id});

  @override
  String toString() => 'Ref(name: $name, id: $id)';

  factory Ref.fromMap(Map<String, dynamic> data) => Ref(
        name: data['name'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Ref].
  factory Ref.fromJson(String data) {
    return Ref.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Ref] to a JSON string.
  String toJson() => json.encode(toMap());

  Ref copyWith({
    String? name,
    String? id,
  }) {
    return Ref(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }
}
