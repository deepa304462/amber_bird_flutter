import 'dart:convert';

import 'applicable_for_profile_ref.dart';

class Condition {
  bool? firstTimePurchase;
  dynamic maxCartAmount;
  List<String>? applicableForZipcodes;
  List<String>? includeProductCategoryIds;
  List<String>? excludeProductCategoryIds;
  List<String>? includeBrandIds;
  List<String>? excludeBrandIds;
  ApplicableForProfileRef? applicableForProfileRef;
  bool? multipleTimeUse;
  bool? onlyForPrimeMember;
  bool? onlyForGoldMember;
  bool? onlyForSilverMember;
  String? expireAtTime;
  dynamic maxUses;

  Condition({
    this.firstTimePurchase,
    this.maxCartAmount,
    this.applicableForZipcodes,
    this.includeProductCategoryIds,
    this.excludeProductCategoryIds,
    this.includeBrandIds,
    this.excludeBrandIds,
    this.applicableForProfileRef,
    this.multipleTimeUse,
    this.onlyForPrimeMember,
    this.onlyForGoldMember,
    this.onlyForSilverMember,
    this.expireAtTime,
    this.maxUses,
  });

  @override
  String toString() {
    return 'Condition(firstTimePurchase: $firstTimePurchase, maxCartAmount: $maxCartAmount, applicableForZipcodes: $applicableForZipcodes, includeProductCategoryIds: $includeProductCategoryIds, excludeProductCategoryIds: $excludeProductCategoryIds, includeBrandIds: $includeBrandIds, excludeBrandIds: $excludeBrandIds, applicableForProfileRef: $applicableForProfileRef, multipleTimeUse: $multipleTimeUse, onlyForPrimeMember: $onlyForPrimeMember, onlyForGoldMember: $onlyForGoldMember, onlyForSilverMember: $onlyForSilverMember, expireAtTime: $expireAtTime, maxUses: $maxUses)';
  }

  factory Condition.fromMap(Map<String, dynamic> data) => Condition(
        firstTimePurchase: data['firstTimePurchase'] as bool?,
        maxCartAmount: data['maxCartAmount'] as dynamic,
        applicableForZipcodes: data['applicableForZipcodes'] == null
            ? null
            : (data['applicableForZipcodes'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList(),
        includeProductCategoryIds: data['includeProductCategoryIds'] == null
            ? null
            : (data['includeProductCategoryIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList(),
        excludeProductCategoryIds: data['excludeProductCategoryIds'] == null
            ? null
            : (data['excludeProductCategoryIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList(),
        includeBrandIds: data['includeBrandIds'] == null
            ? null
            : (data['includeBrandIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList(),
        excludeBrandIds: data['excludeBrandIds'] == null
            ? null
            : (data['excludeBrandIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList(),
        applicableForProfileRef: data['applicableForProfileRef'] == null
            ? null
            : ApplicableForProfileRef.fromMap(
                data['applicableForProfileRef'] as Map<String, dynamic>),
        multipleTimeUse: data['multipleTimeUse'] as bool?,
        onlyForPrimeMember: data['onlyForPrimeMember'] as bool?,
        onlyForGoldMember: data['onlyForGoldMember'] as bool?,
        onlyForSilverMember: data['onlyForSilverMember'] as bool?,
        expireAtTime: data['expireAtTime'] as String?,
        maxUses: data['maxUses'] as dynamic,
      );

  Map<String, dynamic> toMap() => {
        'firstTimePurchase': firstTimePurchase,
        'maxCartAmount': maxCartAmount,
        'applicableForZipcodes': applicableForZipcodes,
        'includeProductCategoryIds': includeProductCategoryIds,
        'excludeProductCategoryIds': excludeProductCategoryIds,
        'includeBrandIds': includeBrandIds,
        'excludeBrandIds': excludeBrandIds,
        'applicableForProfileRef': applicableForProfileRef?.toMap(),
        'multipleTimeUse': multipleTimeUse,
        'onlyForPrimeMember': onlyForPrimeMember,
        'onlyForGoldMember': onlyForGoldMember,
        'onlyForSilverMember': onlyForSilverMember,
        'expireAtTime': expireAtTime,
        'maxUses': maxUses,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Condition].
  factory Condition.fromJson(String data) {
    return Condition.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Condition] to a JSON string.
  String toJson() => json.encode(toMap());

  Condition copyWith({
    bool? firstTimePurchase,
    dynamic maxCartAmount,
    List<String>? applicableForZipcodes,
    List<String>? includeProductCategoryIds,
    List<String>? excludeProductCategoryIds,
    List<String>? includeBrandIds,
    List<String>? excludeBrandIds,
    ApplicableForProfileRef? applicableForProfileRef,
    bool? multipleTimeUse,
    bool? onlyForPrimeMember,
    bool? onlyForGoldMember,
    bool? onlyForSilverMember,
    String? expireAtTime,
    dynamic maxUses,
  }) {
    return Condition(
      firstTimePurchase: firstTimePurchase ?? this.firstTimePurchase,
      maxCartAmount: maxCartAmount ?? this.maxCartAmount,
      applicableForZipcodes:
          applicableForZipcodes ?? this.applicableForZipcodes,
      includeProductCategoryIds:
          includeProductCategoryIds ?? this.includeProductCategoryIds,
      excludeProductCategoryIds:
          excludeProductCategoryIds ?? this.excludeProductCategoryIds,
      includeBrandIds: includeBrandIds ?? this.includeBrandIds,
      excludeBrandIds: excludeBrandIds ?? this.excludeBrandIds,
      applicableForProfileRef:
          applicableForProfileRef ?? this.applicableForProfileRef,
      multipleTimeUse: multipleTimeUse ?? this.multipleTimeUse,
      onlyForPrimeMember: onlyForPrimeMember ?? this.onlyForPrimeMember,
      onlyForGoldMember: onlyForGoldMember ?? this.onlyForGoldMember,
      onlyForSilverMember: onlyForSilverMember ?? this.onlyForSilverMember,
      expireAtTime: expireAtTime ?? this.expireAtTime,
      maxUses: maxUses ?? this.maxUses,
    );
  }
}
