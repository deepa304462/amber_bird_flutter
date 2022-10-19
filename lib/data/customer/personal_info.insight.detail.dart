import 'dart:convert';

class PersonalInfo {
  String? name;
  String? membershipType;
  int? currentPointLevel;

  PersonalInfo({this.name, this.membershipType, this.currentPointLevel});

  @override
  String toString() {
    return 'PersonalInfo(name: $name, membershipType: $membershipType, currentPointLevel: $currentPointLevel)';
  }

  factory PersonalInfo.fromMap(Map<String, dynamic> data) => PersonalInfo(
        name: data['name'] as String?,
        membershipType: data['membershipType'] as String?,
        currentPointLevel: data['currentPointLevel'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'membershipType': membershipType,
        'currentPointLevel': currentPointLevel,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PersonalInfo].
  factory PersonalInfo.fromJson(String data) {
    return PersonalInfo.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PersonalInfo] to a JSON string.
  String toJson() => json.encode(toMap());

  PersonalInfo copyWith({
    String? name,
    String? membershipType,
    int? currentPointLevel,
  }) {
    return PersonalInfo(
      name: name ?? this.name,
      membershipType: membershipType ?? this.membershipType,
      currentPointLevel: currentPointLevel ?? this.currentPointLevel,
    );
  }
}
