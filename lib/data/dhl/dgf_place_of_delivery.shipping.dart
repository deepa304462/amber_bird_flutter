import 'dart:convert';

class DgfPlaceOfDelivery {
  String? dgfLocationName;

  DgfPlaceOfDelivery({this.dgfLocationName});

  @override
  String toString() {
    return 'DgfPlaceOfDelivery(dgfLocationName: $dgfLocationName)';
  }

  factory DgfPlaceOfDelivery.fromMap(Map<String, dynamic> data) {
    return DgfPlaceOfDelivery(
      dgfLocationName: data['dgf:locationName'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'dgf:locationName': dgfLocationName,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DgfPlaceOfDelivery].
  factory DgfPlaceOfDelivery.fromJson(String data) {
    return DgfPlaceOfDelivery.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DgfPlaceOfDelivery] to a JSON string.
  String toJson() => json.encode(toMap());

  DgfPlaceOfDelivery copyWith({
    String? dgfLocationName,
  }) {
    return DgfPlaceOfDelivery(
      dgfLocationName: dgfLocationName ?? this.dgfLocationName,
    );
  }
}
