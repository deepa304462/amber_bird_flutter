import 'dart:convert';

class MappedTo {
  String? name;
  String? id;

  MappedTo({this.name, this.id});

  @override
  String toString() => 'MappedTo(name: $name, id: $id)';

  factory MappedTo.fromMap(Map<String, dynamic> data) => MappedTo(
        name: data['name'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MappedTo].
  factory MappedTo.fromJson(String data) {
    return MappedTo.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MappedTo] to a JSON string.
  String toJson() => json.encode(toMap());

  MappedTo copyWith({
    String? name,
    String? id,
  }) {
    return MappedTo(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }
}
