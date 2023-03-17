import 'dart:convert';

class DgfPlaceOfAcceptance {
  String? dgfLocationName;

  DgfPlaceOfAcceptance({this.dgfLocationName});

  @override
  String toString() {
    return 'DgfPlaceOfAcceptance(dgfLocationName: $dgfLocationName)';
  }

  factory DgfPlaceOfAcceptance.fromMap(Map<String, dynamic> data) {
    return DgfPlaceOfAcceptance(
      dgfLocationName: data['dgf:locationName'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'dgf:locationName': dgfLocationName,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DgfPlaceOfAcceptance].
  factory DgfPlaceOfAcceptance.fromJson(String data) {
    return DgfPlaceOfAcceptance.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DgfPlaceOfAcceptance] to a JSON string.
  String toJson() => json.encode(toMap());

  DgfPlaceOfAcceptance copyWith({
    String? dgfLocationName,
  }) {
    return DgfPlaceOfAcceptance(
      dgfLocationName: dgfLocationName ?? this.dgfLocationName,
    );
  }
}
