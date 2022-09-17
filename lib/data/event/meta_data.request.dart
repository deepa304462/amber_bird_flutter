import 'dart:convert';

class MetaData {
	String? createdAt;
	String? updatedAt;
	int? version;
	String? state;

	MetaData({this.createdAt, this.updatedAt, this.version, this.state});

	@override
	String toString() {
		return 'MetaData(createdAt: $createdAt, updatedAt: $updatedAt, version: $version, state: $state)';
	}

	factory MetaData.fromMap(Map<String, dynamic> data) => MetaData(
				createdAt: data['createdAt'] as String?,
				updatedAt: data['updatedAt'] as String?,
				version: data['version'] as int?,
				state: data['state'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'createdAt': createdAt,
				'updatedAt': updatedAt,
				'version': version,
				'state': state,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MetaData].
	factory MetaData.fromJson(String data) {
		return MetaData.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [MetaData] to a JSON string.
	String toJson() => json.encode(toMap());

	MetaData copyWith({
		String? createdAt,
		String? updatedAt,
		int? version,
		String? state,
	}) {
		return MetaData(
			createdAt: createdAt ?? this.createdAt,
			updatedAt: updatedAt ?? this.updatedAt,
			version: version ?? this.version,
			state: state ?? this.state,
		);
	}
}
