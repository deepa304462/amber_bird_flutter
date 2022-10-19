import 'dart:convert';

import 'product_availability.availability.dart';

class Checkout {
  List<ProductAvailability>? productAvailability;
  bool? allAvailable;

  Checkout({this.productAvailability, this.allAvailable});

  @override
  String toString() {
    return 'Checkout(productAvailability: $productAvailability, allAvailable: $allAvailable)';
  }

  factory Checkout.fromMap(Map<String, dynamic> data) => Checkout(
        productAvailability: (data['productAvailability'] as List<dynamic>?)
            ?.map((e) => ProductAvailability.fromMap(e as Map<String, dynamic>))
            .toList(),
        allAvailable: data['allAvailable'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'productAvailability':
            productAvailability?.map((e) => e.toMap()).toList(),
        'allAvailable': allAvailable,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Checkout].
  factory Checkout.fromJson(String data) {
    return Checkout.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Checkout] to a JSON string.
  String toJson() => json.encode(toMap());

  Checkout copyWith({
    List<ProductAvailability>? productAvailability,
    bool? allAvailable,
  }) {
    return Checkout(
      productAvailability: productAvailability ?? this.productAvailability,
      allAvailable: allAvailable ?? this.allAvailable,
    );
  }
}
