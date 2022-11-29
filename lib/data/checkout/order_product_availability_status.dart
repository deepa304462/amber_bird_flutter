import 'dart:convert';

import 'product_availability_status.dart';
import 'products_availability_status.dart';

class OrderProductAvailabilityStatus {
  ProductAvailabilityStatus? productAvailabilityStatus;
  List<ProductsAvailabilityStatus>? productsAvailabilityStatus;

  OrderProductAvailabilityStatus({
    this.productAvailabilityStatus,
    this.productsAvailabilityStatus,
  });

  @override
  String toString() {
    return 'OrderProductAvailabilityStatus(productAvailabilityStatus: $productAvailabilityStatus, productsAvailabilityStatus: $productsAvailabilityStatus)';
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
                  ProductsAvailabilityStatus.fromMap(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'productAvailabilityStatus': productAvailabilityStatus?.toMap(),
        'productsAvailabilityStatus':
            productsAvailabilityStatus?.map((e) => e.toMap()).toList(),
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
    List<ProductsAvailabilityStatus>? productsAvailabilityStatus,
  }) {
    return OrderProductAvailabilityStatus(
      productAvailabilityStatus:
          productAvailabilityStatus ?? this.productAvailabilityStatus,
      productsAvailabilityStatus:
          productsAvailabilityStatus ?? this.productsAvailabilityStatus,
    );
  }
}
