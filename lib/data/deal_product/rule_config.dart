import 'dart:convert';

import 'apply_only_for_location.dart';

class RuleConfig {
  String? willExpireAt;
  String? willStartAt;
  dynamic? minCartAmount;
  bool? onlyForPrimeMember;
  bool? onlyForSilverMember;
  bool? onlyForGoldenMember;
  List<dynamic>? forWeekDays;
  ApplyOnlyForLocation? applyOnlyForLocation;

  RuleConfig({
    this.willExpireAt,
    this.willStartAt,
    this.minCartAmount,
    this.onlyForPrimeMember,
    this.onlyForSilverMember,
    this.onlyForGoldenMember,
    this.forWeekDays,
    this.applyOnlyForLocation,
  });

  @override
  String toString() {
    return 'RuleConfig(willExpireAt: $willExpireAt, willStartAt: $willStartAt, minCartAmount: $minCartAmount, onlyForPrimeMember: $onlyForPrimeMember, onlyForSilverMember: $onlyForSilverMember, onlyForGoldenMember: $onlyForGoldenMember, forWeekDays: $forWeekDays, applyOnlyForLocation: $applyOnlyForLocation)';
  }

  factory RuleConfig.fromMap(Map<String, dynamic> data) => RuleConfig(
        willExpireAt: data['willExpireAt'] as String?,
        willStartAt: data['willStartAt'] as String?,
        minCartAmount: data['minCartAmount'] as dynamic?,
        onlyForPrimeMember: data['onlyForPrimeMember'] as bool?,
        onlyForSilverMember: data['onlyForSilverMember'] as bool?,
        onlyForGoldenMember: data['onlyForGoldenMember'] as bool?,
        forWeekDays: data['forWeekDays'] as List<dynamic>?,
        applyOnlyForLocation: data['applyOnlyForLocation'] == null
            ? null
            : ApplyOnlyForLocation.fromMap(
                data['applyOnlyForLocation'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'willExpireAt': willExpireAt,
        'willStartAt': willStartAt,
        'minCartAmount': minCartAmount,
        'onlyForPrimeMember': onlyForPrimeMember,
        'onlyForSilverMember': onlyForSilverMember,
        'onlyForGoldenMember': onlyForGoldenMember,
        'forWeekDays': forWeekDays,
        'applyOnlyForLocation': applyOnlyForLocation?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RuleConfig].
  factory RuleConfig.fromJson(String data) {
    return RuleConfig.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RuleConfig] to a JSON string.
  String toJson() => json.encode(toMap());

  RuleConfig copyWith({
    String? willExpireAt,
    String? willStartAt,
    dynamic? minCartAmount,
    bool? onlyForPrimeMember,
    bool? onlyForSilverMember,
    bool? onlyForGoldenMember,
    List<dynamic>? forWeekDays,
    ApplyOnlyForLocation? applyOnlyForLocation,
  }) {
    return RuleConfig(
      willExpireAt: willExpireAt ?? this.willExpireAt,
      willStartAt: willStartAt ?? this.willStartAt,
      minCartAmount: minCartAmount ?? this.minCartAmount,
      onlyForPrimeMember: onlyForPrimeMember ?? this.onlyForPrimeMember,
      onlyForSilverMember: onlyForSilverMember ?? this.onlyForSilverMember,
      onlyForGoldenMember: onlyForGoldenMember ?? this.onlyForGoldenMember,
      forWeekDays: forWeekDays ?? this.forWeekDays,
      applyOnlyForLocation: applyOnlyForLocation ?? this.applyOnlyForLocation,
    );
  }
}
