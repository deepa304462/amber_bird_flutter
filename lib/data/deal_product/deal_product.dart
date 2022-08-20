import 'dart:convert';

import 'package:amber_bird/data/deal_product/price.dart';

import 'constraint.dart';
 import 'meta_data.dart';
import 'product.dart';
import 'rule_config.dart';

class DealProduct {
  MetaData? metaData;
  String? type;
  ProductSummary? product;
  Price? dealPrice;
  String? imageId;
  RuleConfig? ruleConfig;
  String? businessId;
  bool? active;
  Constraint? constraint;
  String? id;

  DealProduct({
    this.metaData,
    this.type,
    this.product,
    this.dealPrice,
    this.imageId,
    this.ruleConfig,
    this.businessId,
    this.active,
    this.constraint,
    this.id,
  });

  @override
  String toString() {
    return 'DealProduct(metaData: $metaData, type: $type, product: $product, dealPrice: $dealPrice, imageId: $imageId, ruleConfig: $ruleConfig, businessId: $businessId, active: $active, constraint: $constraint, id: $id)';
  }

  factory DealProduct.fromMap(Map<String, dynamic> data) => DealProduct(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        type: data['type'] as String?,
        product: data['product'] == null
            ? null
            : ProductSummary.fromMap(data['product'] as Map<String, dynamic>),
        dealPrice: data['dealPrice'] == null
            ? null
            : Price.fromMap(data['dealPrice'] as Map<String, dynamic>),
        imageId: data['imageId'] as String?,
        ruleConfig: data['ruleConfig'] == null
            ? null
            : RuleConfig.fromMap(data['ruleConfig'] as Map<String, dynamic>),
        businessId: data['businessId'] as String?,
        active: data['active'] as bool?,
        constraint: data['constraint'] == null
            ? null
            : Constraint.fromMap(data['constraint'] as Map<String, dynamic>),
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'type': type,
        'product': product?.toMap(),
        'dealPrice': dealPrice?.toMap(),
        'imageId': imageId,
        'ruleConfig': ruleConfig?.toMap(),
        'businessId': businessId,
        'active': active,
        'constraint': constraint?.toMap(),
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DealProduct].
  factory DealProduct.fromJson(String data) {
    return DealProduct.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DealProduct] to a JSON string.
  String toJson() => json.encode(toMap());

  DealProduct copyWith({
    MetaData? metaData,
    String? type,
    ProductSummary? product,
    Price? dealPrice,
    String? imageId,
    RuleConfig? ruleConfig,
    String? businessId,
    bool? active,
    Constraint? constraint,
    String? id,
  }) {
    return DealProduct(
      metaData: metaData ?? this.metaData,
      type: type ?? this.type,
      product: product ?? this.product,
      dealPrice: dealPrice ?? this.dealPrice,
      imageId: imageId ?? this.imageId,
      ruleConfig: ruleConfig ?? this.ruleConfig,
      businessId: businessId ?? this.businessId,
      active: active ?? this.active,
      constraint: constraint ?? this.constraint,
      id: id ?? this.id,
    );
  }
}
