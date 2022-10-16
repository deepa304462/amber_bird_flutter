import 'dart:convert';

class Constraint {
  int? minimumOrder;
  int? maximumOrder;

  Constraint({this.minimumOrder, this.maximumOrder});

  @override
  String toString() {
    return 'Constraint(minimumOrder: $minimumOrder, maximumOrder: $maximumOrder)';
  }

  factory Constraint.fromMap(Map<String, dynamic> data) => Constraint(
        minimumOrder: data['minimumOrder'] as int?,
        maximumOrder: data['maximumOrder'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'minimumOrder': minimumOrder,
        'maximumOrder': maximumOrder,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Constraint].
  factory Constraint.fromJson(String data) {
    return Constraint.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Constraint] to a JSON string.
  String toJson() => json.encode(toMap());

  Constraint copyWith({
    int? minimumOrder,
    int? maximumOrder,
  }) {
    return Constraint(
      minimumOrder: minimumOrder ?? this.minimumOrder,
      maximumOrder: maximumOrder ?? this.maximumOrder,
    );
  }
}
