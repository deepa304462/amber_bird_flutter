import 'dart:convert';

import 'geo_address.dart';

class ApplyOnlyForLocation {
  String? line1;
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

  ApplyOnlyForLocation({
    this.line1,
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
    return 'ApplyOnlyForLocation(line1: $line1, line2: $line2, landMark: $landMark, zipCode: $zipCode, city: $city, country: $country, localArea: $localArea, addressType: $addressType, geoAddress: $geoAddress, phoneNumber: $phoneNumber, directionComment: $directionComment)';
  }

  factory ApplyOnlyForLocation.fromMap(Map<String, dynamic> data) {
    return ApplyOnlyForLocation(
      line1: data['line1'] as String?,
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
  /// Parses the string and returns the resulting Json object as [ApplyOnlyForLocation].
  factory ApplyOnlyForLocation.fromJson(String data) {
    return ApplyOnlyForLocation.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ApplyOnlyForLocation] to a JSON string.
  String toJson() => json.encode(toMap());

  ApplyOnlyForLocation copyWith({
    String? line1,
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
    return ApplyOnlyForLocation(
      line1: line1 ?? this.line1,
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
