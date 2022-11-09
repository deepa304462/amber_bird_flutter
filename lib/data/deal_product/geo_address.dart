import 'dart:convert';

class GeoAddress {
  String? type;
  List<dynamic>? coordinates;

  GeoAddress({this.type, this.coordinates});

  @override
  String toString() => 'GeoAddress(type: $type, coordinates: $coordinates)';

  factory GeoAddress.fromMap(Map<String, dynamic> data) => GeoAddress(
        type: data['type'] as String?,
        coordinates: data['coordinates'] as List<dynamic>?,
      );

  Map<String, dynamic> toMap() => {
        'type': type,
        'coordinates': coordinates,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GeoAddress].
  factory GeoAddress.fromJson(String data) {
    return GeoAddress.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GeoAddress] to a JSON string.
  String toJson() => json.encode(toMap());

  GeoAddress copyWith({
    String? type,
    List<dynamic>? coordinates,
  }) {
    return GeoAddress(
      type: type ?? this.type,
      coordinates: coordinates ?? this.coordinates,
    );
  }
}
