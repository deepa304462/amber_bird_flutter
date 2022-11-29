import 'dart:convert';

import 'package:amber_bird/data/deal_product/description.dart';
import 'package:amber_bird/data/deal_product/meta_data.dart';

import 'condition.dart';
import 'reward.dart';

class CouponCode {
  MetaData? metaData;
  String? couponCode;
  Condition? condition;
  Reward? reward;
  Description? description;
  String? createByEnum;
  bool? active;
  String? businessId;
  String? id;

  CouponCode({
    this.metaData,
    this.couponCode,
    this.condition,
    this.reward,
    this.description,
    this.createByEnum,
    this.active,
    this.businessId,
    this.id,
  });

  @override
  String toString() {
    return 'CouponCode(metaData: $metaData, couponCode: $couponCode, condition: $condition, reward: $reward, description: $description, createByEnum: $createByEnum, active: $active, businessId: $businessId, id: $id)';
  }

  factory CouponCode.fromMap(Map<String, dynamic> data) => CouponCode(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        couponCode: data['couponCode'] as String?,
        condition: data['condition'] == null
            ? null
            : Condition.fromMap(data['condition'] as Map<String, dynamic>),
        reward: data['reward'] == null
            ? null
            : Reward.fromMap(data['reward'] as Map<String, dynamic>),
        description: data['description'] == null
            ? null
            : Description.fromMap(data['description'] as Map<String, dynamic>),
        createByEnum: data['createByEnum'] as String?,
        active: data['active'] as bool?,
        businessId: data['businessId'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'couponCode': couponCode,
        'condition': condition?.toMap(),
        'reward': reward?.toMap(),
        'description': description?.toMap(),
        'createByEnum': createByEnum,
        'active': active,
        'businessId': businessId,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CouponCode].
  factory CouponCode.fromJson(String data) {
    return CouponCode.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CouponCode] to a JSON string.
  String toJson() => json.encode(toMap());

  CouponCode copyWith({
    MetaData? metaData,
    String? couponCode,
    Condition? condition,
    Reward? reward,
    Description? description,
    String? createByEnum,
    bool? active,
    String? businessId,
    String? id,
  }) {
    return CouponCode(
      metaData: metaData ?? this.metaData,
      couponCode: couponCode ?? this.couponCode,
      condition: condition ?? this.condition,
      reward: reward ?? this.reward,
      description: description ?? this.description,
      createByEnum: createByEnum ?? this.createByEnum,
      active: active ?? this.active,
      businessId: businessId ?? this.businessId,
      id: id ?? this.id,
    );
  }
}
