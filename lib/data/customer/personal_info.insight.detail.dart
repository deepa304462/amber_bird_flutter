import 'dart:convert';

class PersonalInfo {
  String? name;
  String? membershipType;
  int? currentPointLevel;
  int? scoins;
  int? spoints;

  PersonalInfo(
      {this.name,
      this.membershipType,
      this.currentPointLevel,
      this.scoins,
      this.spoints});

  @override
  String toString() {
    return 'PersonalInfo(name: $name, membershipType: $membershipType, currentPointLevel: $currentPointLevel, scoins: $scoins, spoints: $spoints)';
  }

  factory PersonalInfo.fromMap(Map<String, dynamic> data) => PersonalInfo(
        name: data['name'] as String?,
        membershipType: data['membershipType'] as String?,
        currentPointLevel: data['currentPointLevel'] as int?,
        scoins: data['scoins'] as int?,
        spoints: data['spoints'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'membershipType': membershipType,
        'currentPointLevel': currentPointLevel,
        'scoins': scoins,
        'spoints': spoints,
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
    int? scoins,
    int? spoints,
  }) {
    return PersonalInfo(
        name: name ?? this.name,
        membershipType: membershipType ?? this.membershipType,
        currentPointLevel: currentPointLevel ?? this.currentPointLevel,
        scoins: scoins ?? this.scoins,
        spoints: spoints ?? this.spoints);
  }
}
