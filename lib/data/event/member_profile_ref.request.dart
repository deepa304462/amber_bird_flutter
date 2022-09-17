import 'dart:convert';

class MemberProfileRef {
	String? id;
	String? name;

	MemberProfileRef({this.id, this.name});

	@override
	String toString() => 'MemberProfileRef(id: $id, name: $name)';

	factory MemberProfileRef.fromMap(Map<String, dynamic> data) {
		return MemberProfileRef(
			id: data['id'] as String?,
			name: data['name'] as String?,
		);
	}



	Map<String, dynamic> toMap() => {
				'id': id,
				'name': name,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MemberProfileRef].
	factory MemberProfileRef.fromJson(String data) {
		return MemberProfileRef.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [MemberProfileRef] to a JSON string.
	String toJson() => json.encode(toMap());

	MemberProfileRef copyWith({
		String? id,
		String? name,
	}) {
		return MemberProfileRef(
			id: id ?? this.id,
			name: name ?? this.name,
		);
	}
}
