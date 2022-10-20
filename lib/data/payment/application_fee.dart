import 'dart:convert';

import 'amount.dart';

class ApplicationFee {
  Amount? amount;
  String? description;

  ApplicationFee({this.amount, this.description});

  @override
  String toString() {
    return 'ApplicationFee(amount: $amount, description: $description)';
  }

  factory ApplicationFee.fromMap(Map<String, dynamic> data) {
    return ApplicationFee(
      amount: data['amount'] == null
          ? null
          : Amount.fromMap(data['amount'] as Map<String, dynamic>),
      description: data['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'amount': amount?.toMap(),
        'description': description,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ApplicationFee].
  factory ApplicationFee.fromJson(String data) {
    return ApplicationFee.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ApplicationFee] to a JSON string.
  String toJson() => json.encode(toMap());

  ApplicationFee copyWith({
    Amount? amount,
    String? description,
  }) {
    return ApplicationFee(
      amount: amount ?? this.amount,
      description: description ?? this.description,
    );
  }
}
