import 'dart:convert';

import 'address.shipping.dart';

class Destination {
  Address? address;

  Destination({this.address});

  @override
  String toString() => 'Destination(address: $address)';

  factory Destination.fromMap(Map<String, dynamic> data) => Destination(
        address: data['address'] == null
            ? null
            : Address.fromMap(data['address'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'address': address?.toMap(),
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
    Address? address,
  }) {
    return Destination(
      address: address ?? this.address,
    );
  }
}
