import 'dart:convert';

import 'address.shipping.dart';

class Location {
  Address? address;

  Location({this.address});

  @override
  String toString() => 'Location(address: $address)';

  factory Location.fromMap(Map<String, dynamic> data) => Location(
        address: data['address'] == null
            ? null
            : Address.fromMap(data['address'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'address': address?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Location].
  factory Location.fromJson(String data) {
    return Location.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Location] to a JSON string.
  String toJson() => json.encode(toMap());

  Location copyWith({
    Address? address,
  }) {
    return Location(
      address: address ?? this.address,
    );
  }
}
