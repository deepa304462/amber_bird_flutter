import 'dart:convert';

 import 'refund.dart';

class Embedded {
  List<Refund>? refunds;
  List<Refund>? chargebacks;

  Embedded({this.refunds, this.chargebacks});

  @override
  String toString() {
    return 'Embedded(refunds: $refunds, chargebacks: $chargebacks)';
  }

  factory Embedded.fromMap(Map<String, dynamic> data) => Embedded(
        refunds: (data['refunds'] as List<dynamic>?)
            ?.map((e) => Refund.fromMap(e as Map<String, dynamic>))
            .toList(),
        chargebacks: (data['chargebacks'] as List<dynamic>?)
            ?.map((e) => Refund.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'refunds': refunds?.map((e) => e.toMap()).toList(),
        'chargebacks': chargebacks?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Embedded].
  factory Embedded.fromJson(String data) {
    return Embedded.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Embedded] to a JSON string.
  String toJson() => json.encode(toMap());

  Embedded copyWith({
    List<Refund>? refunds,
    List<Refund>? chargebacks,
  }) {
    return Embedded(
      refunds: refunds ?? this.refunds,
      chargebacks: chargebacks ?? this.chargebacks,
    );
  }
}
