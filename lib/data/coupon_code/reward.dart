import 'dart:convert';

class Reward {
  dynamic discountUptos;
  dynamic discountPercent;
  dynamic flatDiscount;

  Reward({this.discountUptos, this.discountPercent, this.flatDiscount});

  @override
  String toString() {
    return 'Reward(discountUptos: $discountUptos, discountPercent: $discountPercent, flatDiscount: $flatDiscount)';
  }

  factory Reward.fromMap(Map<String, dynamic> data) => Reward(
        discountUptos: data['discountUptos'] as dynamic,
        discountPercent: data['discountPercent'] as dynamic,
        flatDiscount: data['flatDiscount'] as dynamic,
      );

  Map<String, dynamic> toMap() => {
        'discountUptos': discountUptos,
        'discountPercent': discountPercent,
        'flatDiscount': flatDiscount,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Reward].
  factory Reward.fromJson(String data) {
    return Reward.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Reward] to a JSON string.
  String toJson() => json.encode(toMap());

  Reward copyWith({
    dynamic discountUptos,
    dynamic discountPercent,
    dynamic flatDiscount,
  }) {
    return Reward(
      discountUptos: discountUptos ?? this.discountUptos,
      discountPercent: discountPercent ?? this.discountPercent,
      flatDiscount: flatDiscount ?? this.flatDiscount,
    );
  }
}
