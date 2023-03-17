import 'dart:convert';

class Address {
  String? countryCode;
  String? addressLocality;

  Address({this.countryCode, this.addressLocality});

  @override
  String toString() {
    return 'Address(countryCode: $countryCode, addressLocality: $addressLocality)';
  }

  factory Address.fromMap(Map<String, dynamic> data) => Address(
        countryCode: data['countryCode'] as String?,
        addressLocality: data['addressLocality'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'countryCode': countryCode,
        'addressLocality': addressLocality,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Address].
  factory Address.fromJson(String data) {
    return Address.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Address] to a JSON string.
  String toJson() => json.encode(toMap());

  Address copyWith({
    String? countryCode,
    String? addressLocality,
  }) {
    return Address(
      countryCode: countryCode ?? this.countryCode,
      addressLocality: addressLocality ?? this.addressLocality,
    );
  }
}
