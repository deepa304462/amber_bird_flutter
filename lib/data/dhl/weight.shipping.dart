import 'dart:convert';

class Weight {
  dynamic value;
  String? unitText;

  Weight({this.value, this.unitText});

  @override
  String toString() => 'Weight(value: $value, unitText: $unitText)';

  factory Weight.fromMap(Map<String, dynamic> data) => Weight(
        value: data['value'],
        unitText: data['unitText'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'value': value,
        'unitText': unitText,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Weight].
  factory Weight.fromJson(String data) {
    return Weight.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Weight] to a JSON string.
  String toJson() => json.encode(toMap());

  Weight copyWith({
    dynamic value,
    String? unitText,
  }) {
    return Weight(
      value: value ?? this.value,
      unitText: unitText ?? this.unitText,
    );
  }
}
