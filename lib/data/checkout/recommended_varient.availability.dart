import 'dart:convert';

import 'package:amber_bird/data/deal_product/dimension.dart';
import 'package:amber_bird/data/deal_product/price.dart';

import 'constraint.availability.dart';

class RecommendedVarient {
  String? varientCode;
  int? weight;
  String? unit;
  int? currentStock;
  Price? price;
  Dimension? dimension;
  bool? applyExtraShipping;
  String? skuId;
  Constraint? constraint;

  RecommendedVarient({
    this.varientCode,
    this.weight,
    this.unit,
    this.currentStock,
    this.price,
    this.dimension,
    this.applyExtraShipping,
    this.skuId,
    this.constraint,
  });

  @override
  String toString() {
    return 'RecommendedVarient(varientCode: $varientCode, weight: $weight, unit: $unit, currentStock: $currentStock, price: $price, dimension: $dimension, applyExtraShipping: $applyExtraShipping, skuId: $skuId, constraint: $constraint)';
  }

  factory RecommendedVarient.fromMap(Map<String, dynamic> data) {
    return RecommendedVarient(
      varientCode: data['varientCode'] as String?,
      weight: data['weight'] as int?,
      unit: data['unit'] as String?,
      currentStock: data['currentStock'] as int?,
      price: data['price'] == null
          ? null
          : Price.fromMap(data['price'] as Map<String, dynamic>),
      dimension: data['dimension'] == null
          ? null
          : Dimension.fromMap(data['dimension'] as Map<String, dynamic>),
      applyExtraShipping: data['applyExtraShipping'] as bool?,
      skuId: data['skuId'] as String?,
      constraint: data['constraint'] == null
          ? null
          : Constraint.fromMap(data['constraint'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'varientCode': varientCode,
        'weight': weight,
        'unit': unit,
        'currentStock': currentStock,
        'price': price?.toMap(),
        'dimension': dimension?.toMap(),
        'applyExtraShipping': applyExtraShipping,
        'skuId': skuId,
        'constraint': constraint?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RecommendedVarient].
  factory RecommendedVarient.fromJson(String data) {
    return RecommendedVarient.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RecommendedVarient] to a JSON string.
  String toJson() => json.encode(toMap());

  RecommendedVarient copyWith({
    String? varientCode,
    int? weight,
    String? unit,
    int? currentStock,
    Price? price,
    Dimension? dimension,
    bool? applyExtraShipping,
    String? skuId,
    Constraint? constraint,
  }) {
    return RecommendedVarient(
      varientCode: varientCode ?? this.varientCode,
      weight: weight ?? this.weight,
      unit: unit ?? this.unit,
      currentStock: currentStock ?? this.currentStock,
      price: price ?? this.price,
      dimension: dimension ?? this.dimension,
      applyExtraShipping: applyExtraShipping ?? this.applyExtraShipping,
      skuId: skuId ?? this.skuId,
      constraint: constraint ?? this.constraint,
    );
  }
}
