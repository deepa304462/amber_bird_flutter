import 'dart:convert';

class TaxDetail {
  dynamic amount;
  String? taxType;
  String? description; 

  TaxDetail({
    this.amount,
    this.taxType,
    this.description
  });

  @override
  String toString() {
    return 'TaxDetail(amount: $amount, taxType: $taxType, description: $description)';
  }

  factory TaxDetail.fromMap(Map<String, dynamic> data) {
    return TaxDetail(
      amount: data['amount'] as dynamic,
      description: data['description'] as String?,
      taxType: data['taxType'] as String?, 
    );
  }

  Map<String, dynamic> toMap() => {
        'amount': amount,
        'taxType': taxType,
        'description': description, 
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TaxDetail].
  factory TaxDetail.fromJson(String data) {
    return TaxDetail.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TaxDetail] to a JSON string.
  String toJson() => json.encode(toMap());

  TaxDetail copyWith({
    dynamic amount,
    String? description,
    String? taxType, 
  }) {
    return TaxDetail(
      amount: amount ?? this.amount,
      description: description ?? this.description,
      taxType: taxType ?? this.taxType, 
    );
  }
}
