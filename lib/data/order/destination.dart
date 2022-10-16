import 'dart:convert';

import 'package:amber_bird/data/profile/ref.dart';

import 'address.dart';

class Destination {
  Ref? wareHouseRef;
  Address? customerAddress;
  Address? storeAddress;

  Destination({this.wareHouseRef, this.customerAddress, this.storeAddress});

  @override
  String toString() {
    return 'Destination(wareHouseRef: $wareHouseRef, customerAddress: $customerAddress, storeAddress: $storeAddress)';
  }

  factory Destination.fromMap(Map<String, dynamic> data) => Destination(
        wareHouseRef: data['wareHouseRef'] == null
            ? null
            : Ref.fromMap(data['wareHouseRef'] as Map<String, dynamic>),
        customerAddress: data['customerAddress'] == null
            ? null
            : Address.fromMap(data['customerAddress'] as Map<String, dynamic>),
        storeAddress: data['storeAddress'] == null
            ? null
            : Address.fromMap(data['storeAddress'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'wareHouseRef': wareHouseRef?.toMap(),
        'customerAddress': customerAddress?.toMap(),
        'storeAddress': storeAddress?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Destination].
  factory Destination.fromJson(String data) {
    return Destination.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Destination] to a JSON string.
  String toJson() => json.encode(toMap());

  Destination copyWith({
    Ref? wareHouseRef,
    Address? customerAddress,
    Address? storeAddress,
  }) {
    return Destination(
      wareHouseRef: wareHouseRef ?? this.wareHouseRef,
      customerAddress: customerAddress ?? this.customerAddress,
      storeAddress: storeAddress ?? this.storeAddress,
    );
  }
}
