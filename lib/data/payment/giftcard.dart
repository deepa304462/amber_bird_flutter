import 'dart:convert';

import 'amount.dart';

class Giftcard {
  String? issuer;
  Amount? amount;
  String? voucherNumber;

  Giftcard({this.issuer, this.amount, this.voucherNumber});

  @override
  String toString() {
    return 'Giftcard(issuer: $issuer, amount: $amount, voucherNumber: $voucherNumber)';
  }

  factory Giftcard.fromMap(Map<String, dynamic> data) => Giftcard(
        issuer: data['issuer'] as String?,
        amount: data['amount'] == null
            ? null
            : Amount.fromMap(data['amount'] as Map<String, dynamic>),
        voucherNumber: data['voucherNumber'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'issuer': issuer,
        'amount': amount?.toMap(),
        'voucherNumber': voucherNumber,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Giftcard].
  factory Giftcard.fromJson(String data) {
    return Giftcard.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Giftcard] to a JSON string.
  String toJson() => json.encode(toMap());

  Giftcard copyWith({
    String? issuer,
    Amount? amount,
    String? voucherNumber,
  }) {
    return Giftcard(
      issuer: issuer ?? this.issuer,
      amount: amount ?? this.amount,
      voucherNumber: voucherNumber ?? this.voucherNumber,
    );
  }
}
