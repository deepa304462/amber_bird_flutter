import 'dart:convert';

class Amount {
  String? currency;
  dynamic? value;

  Amount({this.currency, this.value});

  @override
  String toString() => 'Amount(currency: $currency, value: $value)';

  factory Amount.fromMap(Map<String, dynamic> data) => Amount(
        currency: data['currency'] as String?,
        value: data['value'] as dynamic?,
      );

  Map<String, dynamic> toMap() => {
        'currency': currency,
        'value': value,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Amount].
  factory Amount.fromJson(String data) {
    return Amount.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Amount] to a JSON string.
  String toJson() => json.encode(toMap());

  Amount copyWith({
    String? currency,
    dynamic? value,
  }) {
    return Amount(
      currency: currency ?? this.currency,
      value: value ?? this.value,
    );
  }
}
