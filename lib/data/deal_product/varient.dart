import 'dart:convert';

import 'constraint.dart';
import 'dimension.dart';
import 'price.dart';

class Varient {
  String? varientCode;
  double? weight;
  String? unit;
  dynamic? currentStock;
  Price? price;
  Dimension? dimension;
  bool? applyExtraShipping;
  String? skuId;
  Constraint? constraint;

  Varient({
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
    return 'Varient(varientCode: $varientCode, weight: $weight, unit: $unit, currentStock: $currentStock, price: $price, dimension: $dimension, applyExtraShipping: $applyExtraShipping, skuId: $skuId, constraint: $constraint)';
  }

  factory Varient.fromMap(Map<String, dynamic> data) => Varient(
        varientCode: data['varientCode'] as String?,
        weight: data['weight'] as double?,
        unit: data['unit'] as String?,
        currentStock: data['currentStock'] as dynamic?,
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
  /// Parses the string and returns the resulting Json object as [Varient].
  factory Varient.fromJson(String data) {
    return Varient.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Varient] to a JSON string.
  String toJson() => json.encode(toMap());

  Varient copyWith({
    String? varientCode,
    double? weight,
    String? unit,
    dynamic? currentStock,
    Price? price,
    Dimension? dimension,
    bool? applyExtraShipping,
    String? skuId,
    Constraint? constraint,
  }) {
    return Varient(
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
