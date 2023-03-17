import 'dart:convert';

class Volume {
  double? value;
  String? unitText;

  Volume({this.value, this.unitText});

  @override
  String toString() => 'Volume(value: $value, unitText: $unitText)';

  factory Volume.fromMap(Map<String, dynamic> data) => Volume(
        value: (data['value'] as num?)?.toDouble(),
        unitText: data['unitText'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'value': value,
        'unitText': unitText,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Volume].
  factory Volume.fromJson(String data) {
    return Volume.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Volume] to a JSON string.
  String toJson() => json.encode(toMap());

  Volume copyWith({
    double? value,
    String? unitText,
  }) {
    return Volume(
      value: value ?? this.value,
      unitText: unitText ?? this.unitText,
    );
  }
}
