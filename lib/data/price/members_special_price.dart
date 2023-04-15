import 'dart:convert';

class MembersSpecialPrice {
  bool? onlyForPlatinumMember;
  bool? onlyForSilverMember;
  bool? onlyForGoldMember;
  double? forSilverMember;
  double? forGoldMember;
  double? forPlatinumMember;

  MembersSpecialPrice({
    this.onlyForPlatinumMember,
    this.onlyForSilverMember,
    this.onlyForGoldMember,
    this.forSilverMember,
    this.forGoldMember,
    this.forPlatinumMember,
  });

  @override
  String toString() {
    return 'MembersSpecialPrice(onlyForPlatinumMember: $onlyForPlatinumMember, onlyForSilverMember: $onlyForSilverMember, onlyForGoldMember: $onlyForGoldMember, forSilverMember: $forSilverMember, forGoldMember: $forGoldMember, forPlatinumMember: $forPlatinumMember)';
  }

  factory MembersSpecialPrice.fromMap(Map<String, dynamic> data) {
    return MembersSpecialPrice(
      onlyForPlatinumMember: data['onlyForPlatinumMember'] as bool?,
      onlyForSilverMember: data['onlyForSilverMember'] as bool?,
      onlyForGoldMember: data['onlyForGoldMember'] as bool?,
      forSilverMember: data['forSilverMember'] as double?,
      forGoldMember: data['forGoldMember'] as double?,
      forPlatinumMember: data['forPlatinumMember'] as double?,
    );
  }

  Map<String, dynamic> toMap() => {
        'onlyForPlatinumMember': onlyForPlatinumMember,
        'onlyForSilverMember': onlyForSilverMember,
        'onlyForGoldMember': onlyForGoldMember,
        'forSilverMember': forSilverMember,
        'forGoldMember': forGoldMember,
        'forPlatinumMember': forPlatinumMember,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MembersSpecialPrice].
  factory MembersSpecialPrice.fromJson(String data) {
    return MembersSpecialPrice.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MembersSpecialPrice] to a JSON string.
  String toJson() => json.encode(toMap());

  MembersSpecialPrice copyWith({
    bool? onlyForPlatinumMember,
    bool? onlyForSilverMember,
    bool? onlyForGoldMember,
    double? forSilverMember,
    double? forGoldMember,
    double? forPlatinumMember,
  }) {
    return MembersSpecialPrice(
      onlyForPlatinumMember:
          onlyForPlatinumMember ?? this.onlyForPlatinumMember,
      onlyForSilverMember: onlyForSilverMember ?? this.onlyForSilverMember,
      onlyForGoldMember: onlyForGoldMember ?? this.onlyForGoldMember,
      forSilverMember: forSilverMember ?? this.forSilverMember,
      forGoldMember: forGoldMember ?? this.forGoldMember,
      forPlatinumMember: forPlatinumMember ?? this.forPlatinumMember,
    );
  }
}
