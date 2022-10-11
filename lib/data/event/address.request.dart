import 'dart:convert';

class Address {
  String? state;
  String? district;
  String? block;
  String? gramPanchayat;
  String? village;

  Address({
    this.state,
    this.district,
    this.block,
    this.gramPanchayat,
    this.village,
  });

  @override
  String toString() {
    return 'Address(state: $state, district: $district, block: $block, gramPanchayat: $gramPanchayat, village: $village)';
  }

  factory Address.fromMap(Map<String, dynamic> data) => Address(
        state: data['state'] as String?,
        district: data['district'] as String?,
        block: data['block'] as String?,
        gramPanchayat: data['gramPanchayat'] as String?,
        village: data['village'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'state': state,
        'district': district,
        'block': block,
        'gramPanchayat': gramPanchayat,
        'village': village,
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
    String? state,
    String? district,
    String? block,
    String? gramPanchayat,
    String? village,
  }) {
    return Address(
      state: state ?? this.state,
      district: district ?? this.district,
      block: block ?? this.block,
      gramPanchayat: gramPanchayat ?? this.gramPanchayat,
      village: village ?? this.village,
    );
  }
}
