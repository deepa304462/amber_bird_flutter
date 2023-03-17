import 'dart:convert';

import 'address.shipping.dart';

class Origin {
  Address? address;

  Origin({this.address});

  @override
  String toString() => 'Origin(address: $address)';

  factory Origin.fromMap(Map<String, dynamic> data) => Origin(
        address: data['address'] == null
            ? null
            : Address.fromMap(data['address'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'address': address?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Origin].
  factory Origin.fromJson(String data) {
    return Origin.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Origin] to a JSON string.
  String toJson() => json.encode(toMap());

  Origin copyWith({
    Address? address,
  }) {
    return Origin(
      address: address ?? this.address,
    );
  }
}
