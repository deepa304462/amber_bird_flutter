import 'dart:convert';

import 'package:amber_bird/data/profile/ref.dart';

import 'product_availability_status.dart';

class OrderProductAvailabilityStatus {
  ProductAvailabilityStatus? productAvailabilityStatus;
  List<ProductAvailabilityStatus>? productsAvailabilityStatus;
  Ref? ref;

  OrderProductAvailabilityStatus({
    this.productAvailabilityStatus,
    this.productsAvailabilityStatus,
    this.ref,
  });

  @override
  String toString() {
    return 'OrderProductAvailabilityStatus(productAvailabilityStatus: $productAvailabilityStatus, productsAvailabilityStatus: $productsAvailabilityStatus, ref: $ref)';
  }

  factory OrderProductAvailabilityStatus.fromMap(Map<String, dynamic> data) {
    return OrderProductAvailabilityStatus(
      productAvailabilityStatus: data['productAvailabilityStatus'] == null
          ? null
          : ProductAvailabilityStatus.fromMap(
              data['productAvailabilityStatus'] as Map<String, dynamic>),
      productsAvailabilityStatus:
          (data['productsAvailabilityStatus'] as List<dynamic>?)
              ?.map((e) =>
                  ProductAvailabilityStatus.fromMap(e as Map<String, dynamic>))
              .toList(),
      ref: data['ref'] == null
          ? null
          : Ref.fromMap(data['ref'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'productAvailabilityStatus': productAvailabilityStatus?.toMap(),
        'productsAvailabilityStatus':
            productsAvailabilityStatus?.map((e) => e.toMap()).toList(),
        'ref': ref?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrderProductAvailabilityStatus].
  factory OrderProductAvailabilityStatus.fromJson(String data) {
    return OrderProductAvailabilityStatus.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OrderProductAvailabilityStatus] to a JSON string.
  String toJson() => json.encode(toMap());

  OrderProductAvailabilityStatus copyWith({
    ProductAvailabilityStatus? productAvailabilityStatus,
    List<ProductAvailabilityStatus>? productsAvailabilityStatus,
    Ref? ref,
  }) {
    return OrderProductAvailabilityStatus(
      productAvailabilityStatus:
          productAvailabilityStatus ?? this.productAvailabilityStatus,
      productsAvailabilityStatus:
          productsAvailabilityStatus ?? this.productsAvailabilityStatus,
      ref: ref ?? this.ref,
    );
  }
}
