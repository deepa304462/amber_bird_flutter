import 'dart:convert';

import 'order_product_availability_status.dart';

class Checkout {
  List<OrderProductAvailabilityStatus>? orderProductAvailabilityStatus;
  bool? allAvailable;

  Checkout({this.orderProductAvailabilityStatus, this.allAvailable});

  @override
  String toString() {
    return 'Checkout(orderProductAvailabilityStatus: $orderProductAvailabilityStatus, allAvailable: $allAvailable)';
  }

  factory Checkout.fromMap(Map<String, dynamic> data) => Checkout(
        orderProductAvailabilityStatus:
            (data['orderProductAvailabilityStatus'] as List<dynamic>?)
                ?.map((e) => OrderProductAvailabilityStatus.fromMap(
                    e as Map<String, dynamic>))
                .toList(),
        allAvailable: data['allAvailable'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'orderProductAvailabilityStatus':
            orderProductAvailabilityStatus?.map((e) => e.toMap()).toList(),
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
    List<OrderProductAvailabilityStatus>? orderProductAvailabilityStatus,
    bool? allAvailable,
  }) {
    return Checkout(
      orderProductAvailabilityStatus:
          orderProductAvailabilityStatus ?? this.orderProductAvailabilityStatus,
      allAvailable: allAvailable ?? this.allAvailable,
    );
  }
}
