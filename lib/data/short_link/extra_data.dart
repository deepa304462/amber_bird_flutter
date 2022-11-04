import 'dart:convert';

class ExtraData {
  String? additionalProp1;
  String? additionalProp2;
  String? additionalProp3;

  ExtraData({
    this.additionalProp1,
    this.additionalProp2,
    this.additionalProp3,
  });

  factory ExtraData.fromMap(Map<String, dynamic> data) => ExtraData(
        additionalProp1: data['additionalProp1'] as String?,
        additionalProp2: data['additionalProp2'] as String?,
        additionalProp3: data['additionalProp3'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'additionalProp1': additionalProp1,
        'additionalProp2': additionalProp2,
        'additionalProp3': additionalProp3,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ExtraData].
  factory ExtraData.fromJson(String data) {
    return ExtraData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ExtraData] to a JSON string.
  String toJson() => json.encode(toMap());
}
