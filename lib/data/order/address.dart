import 'dart:convert';

import 'package:amber_bird/data/deal_product/geo_address.dart';

class Address {
  String? line1;
  String? name;
  String? line2;
  String? landMark;
  String? zipCode;
  String? city;
  String? country;
  String? localArea;
  String? addressType;
  GeoAddress? geoAddress;
  String? phoneNumber;
  String? directionComment;

  Address({
    this.line1,
    this.name,
    this.line2,
    this.landMark,
    this.zipCode,
    this.city,
    this.country,
    this.localArea,
    this.addressType,
    this.geoAddress,
    this.phoneNumber,
    this.directionComment,
  });

  @override
  String toString() {
    return 'CustomerAddress(line1: $line1,name: $name, line2: $line2, landMark: $landMark, zipCode: $zipCode, city: $city, country: $country, localArea: $localArea, addressType: $addressType, geoAddress: $geoAddress, phoneNumber: $phoneNumber, directionComment: $directionComment)';
  }

  factory Address.fromMap(Map<String, dynamic> data) {
    return Address(
      line1: data['line1'] as String?,
      name: data['name'] as String?,
      line2: data['line2'] as String?,
      landMark: data['landMark'] as String?,
      zipCode: data['zipCode'] as String?,
      city: data['city'] as String?,
      country: data['country'] as String?,
      localArea: data['localArea'] as String?,
      addressType: data['addressType'] as String?,
      geoAddress: data['geoAddress'] == null
          ? null
          : GeoAddress.fromMap(data['geoAddress'] as Map<String, dynamic>),
      phoneNumber: data['phoneNumber'] as String?,
      directionComment: data['directionComment'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'line1': line1,
        'name': name,
        'line2': line2,
        'landMark': landMark,
        'zipCode': zipCode,
        'city': city,
        'country': country,
        'localArea': localArea,
        'addressType': addressType,
        'geoAddress': geoAddress?.toMap(),
        'phoneNumber': phoneNumber,
        'directionComment': directionComment,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CustomerAddress].
  factory Address.fromJson(String data) {
    return Address.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Address] to a JSON string.
  String toJson() => json.encode(toMap());

  Address copyWith({
    String? line1,
    String? name,
    String? line2,
    String? landMark,
    String? zipCode,
    String? city,
    String? country,
    String? localArea,
    String? addressType,
    GeoAddress? geoAddress,
    String? phoneNumber,
    String? directionComment,
  }) {
    return Address(
      line1: line1 ?? this.line1,
      name: name ?? this.name,
      line2: line2 ?? this.line2,
      landMark: landMark ?? this.landMark,
      zipCode: zipCode ?? this.zipCode,
      city: city ?? this.city,
      country: country ?? this.country,
      localArea: localArea ?? this.localArea,
      addressType: addressType ?? this.addressType,
      geoAddress: geoAddress ?? this.geoAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      directionComment: directionComment ?? this.directionComment,
    );
  }
}
