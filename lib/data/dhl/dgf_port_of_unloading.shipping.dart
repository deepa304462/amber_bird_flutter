import 'dart:convert';

class DgfPortOfUnloading {
  String? dgfLocationName;

  DgfPortOfUnloading({this.dgfLocationName});

  @override
  String toString() {
    return 'DgfPortOfUnloading(dgfLocationName: $dgfLocationName)';
  }

  factory DgfPortOfUnloading.fromMap(Map<String, dynamic> data) {
    return DgfPortOfUnloading(
      dgfLocationName: data['dgf:locationName'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'dgf:locationName': dgfLocationName,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DgfPortOfUnloading].
  factory DgfPortOfUnloading.fromJson(String data) {
    return DgfPortOfUnloading.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DgfPortOfUnloading] to a JSON string.
  String toJson() => json.encode(toMap());

  DgfPortOfUnloading copyWith({
    String? dgfLocationName,
  }) {
    return DgfPortOfUnloading(
      dgfLocationName: dgfLocationName ?? this.dgfLocationName,
    );
  }
}
