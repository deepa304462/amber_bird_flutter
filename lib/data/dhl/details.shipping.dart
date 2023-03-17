import 'dart:convert';

import 'carrier.shipping.dart';
import 'dgf_route.shipping.dart';
import 'product.shipping.dart';
import 'volume.shipping.dart';
import 'weight.shipping.dart';

class Details {
  Carrier? carrier;
  Product? product;
  bool? proofOfDeliverySignedAvailable;
  int? totalNumberOfPieces;
  Weight? weight;
  Volume? volume;
  List<DgfRoute>? dgfRoutes;

  Details({
    this.carrier,
    this.product,
    this.proofOfDeliverySignedAvailable,
    this.totalNumberOfPieces,
    this.weight,
    this.volume,
    this.dgfRoutes,
  });

  @override
  String toString() {
    return 'Details(carrier: $carrier, product: $product, proofOfDeliverySignedAvailable: $proofOfDeliverySignedAvailable, totalNumberOfPieces: $totalNumberOfPieces, weight: $weight, volume: $volume, dgfRoutes: $dgfRoutes)';
  }

  factory Details.fromMap(Map<String, dynamic> data) => Details(
        carrier: data['carrier'] == null
            ? null
            : Carrier.fromMap(data['carrier'] as Map<String, dynamic>),
        product: data['product'] == null
            ? null
            : Product.fromMap(data['product'] as Map<String, dynamic>),
        proofOfDeliverySignedAvailable:
            data['proofOfDeliverySignedAvailable'] as bool?,
        totalNumberOfPieces: data['totalNumberOfPieces'] as int?,
        weight: data['weight'] == null
            ? null
            : Weight.fromMap(data['weight'] as Map<String, dynamic>),
        volume: data['volume'] == null
            ? null
            : Volume.fromMap(data['volume'] as Map<String, dynamic>),
        dgfRoutes: (data['dgf:routes'] as List<dynamic>?)
            ?.map((e) => DgfRoute.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'carrier': carrier?.toMap(),
        'product': product?.toMap(),
        'proofOfDeliverySignedAvailable': proofOfDeliverySignedAvailable,
        'totalNumberOfPieces': totalNumberOfPieces,
        'weight': weight?.toMap(),
        'volume': volume?.toMap(),
        'dgf:routes': dgfRoutes?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Details].
  factory Details.fromJson(String data) {
    return Details.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Details] to a JSON string.
  String toJson() => json.encode(toMap());

  Details copyWith({
    Carrier? carrier,
    Product? product,
    bool? proofOfDeliverySignedAvailable,
    int? totalNumberOfPieces,
    Weight? weight,
    Volume? volume,
    List<DgfRoute>? dgfRoutes,
  }) {
    return Details(
      carrier: carrier ?? this.carrier,
      product: product ?? this.product,
      proofOfDeliverySignedAvailable:
          proofOfDeliverySignedAvailable ?? this.proofOfDeliverySignedAvailable,
      totalNumberOfPieces: totalNumberOfPieces ?? this.totalNumberOfPieces,
      weight: weight ?? this.weight,
      volume: volume ?? this.volume,
      dgfRoutes: dgfRoutes ?? this.dgfRoutes,
    );
  }
}
