import 'dart:convert';

import 'apply_only_for_location.dart';

class RuleConfig {
  String? willExpireAt;
  String? willStartAt;
  dynamic? minCartAmount;
  bool? onlyForPlatinumMember;
  bool? onlyForSilverMember;
  bool? onlyForGoldMember;
  bool? onlyForPaidMember;
  bool? onlyForNoMember;
  List<dynamic>? forWeekDays;
  ApplyOnlyForLocation? applyOnlyForLocation;

  RuleConfig({
    this.willExpireAt,
    this.willStartAt,
    this.minCartAmount,
    this.onlyForPlatinumMember,
    this.onlyForSilverMember,
    this.onlyForGoldMember,
    this.onlyForNoMember,
    this.onlyForPaidMember,
    this.forWeekDays,
    this.applyOnlyForLocation,
  });

  @override
  String toString() {
    return 'RuleConfig(willExpireAt: $willExpireAt, willStartAt: $willStartAt, minCartAmount: $minCartAmount, onlyForPlatinumMember: $onlyForPlatinumMember, onlyForSilverMember: $onlyForSilverMember, onlyForGoldMember: $onlyForGoldMember, onlyForNoMember: $onlyForNoMember, onlyForPaidMember: $onlyForPaidMember, forWeekDays: $forWeekDays, applyOnlyForLocation: $applyOnlyForLocation)';
  }

  factory RuleConfig.fromMap(Map<String, dynamic> data) => RuleConfig(
        willExpireAt: data['willExpireAt'] as String?,
        willStartAt: data['willStartAt'] as String?,
        minCartAmount: data['minCartAmount'] as dynamic?,
        onlyForPlatinumMember: data['onlyForPlatinumMember'] as bool?,
        onlyForSilverMember: data['onlyForSilverMember'] as bool?,
        onlyForGoldMember: data['onlyForGoldMember'] as bool?,
        onlyForNoMember: data['onlyForNoMember'] as bool?,
        onlyForPaidMember: data['onlyForPaidMember'] as bool?,
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
        'onlyForPlatinumMember': onlyForPlatinumMember,
        'onlyForSilverMember': onlyForSilverMember,
        'onlyForGoldMember': onlyForGoldMember,
        'onlyForNoMember': onlyForNoMember,
        'onlyForPaidMember': onlyForPaidMember,
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
    bool? onlyForPlatinumMember,
    bool? onlyForSilverMember,
    bool? onlyForGoldMember,
    bool? onlyForNoMember,
    bool? onlyForPaidMember,
    List<dynamic>? forWeekDays,
    ApplyOnlyForLocation? applyOnlyForLocation,
  }) {
    return RuleConfig(
      willExpireAt: willExpireAt ?? this.willExpireAt,
      willStartAt: willStartAt ?? this.willStartAt,
      minCartAmount: minCartAmount ?? this.minCartAmount,
      onlyForPlatinumMember:
          onlyForPlatinumMember ?? this.onlyForPlatinumMember,
      onlyForSilverMember: onlyForSilverMember ?? this.onlyForSilverMember,
      onlyForGoldMember: onlyForGoldMember ?? this.onlyForGoldMember,
      onlyForNoMember: onlyForNoMember ?? this.onlyForNoMember,
      onlyForPaidMember: onlyForPaidMember ?? this.onlyForPaidMember,
      forWeekDays: forWeekDays ?? this.forWeekDays,
      applyOnlyForLocation: applyOnlyForLocation ?? this.applyOnlyForLocation,
    );
  }
}
