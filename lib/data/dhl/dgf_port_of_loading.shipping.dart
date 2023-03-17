import 'dart:convert';

class DgfPortOfLoading {
  String? dgfLocationName;

  DgfPortOfLoading({this.dgfLocationName});

  @override
  String toString() => 'DgfPortOfLoading(dgfLocationName: $dgfLocationName)';

  factory DgfPortOfLoading.fromMap(Map<String, dynamic> data) {
    return DgfPortOfLoading(
      dgfLocationName: data['dgf:locationName'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'dgf:locationName': dgfLocationName,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DgfPortOfLoading].
  factory DgfPortOfLoading.fromJson(String data) {
    return DgfPortOfLoading.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DgfPortOfLoading] to a JSON string.
  String toJson() => json.encode(toMap());

  DgfPortOfLoading copyWith({
    String? dgfLocationName,
  }) {
    return DgfPortOfLoading(
      dgfLocationName: dgfLocationName ?? this.dgfLocationName,
    );
  }
}
