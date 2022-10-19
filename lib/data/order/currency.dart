import 'dart:convert';

class Currency {
  String? currencyCode;
  int? defaultFractionDigits;
  int? numericCode;
  String? displayName;
  String? symbol;
  String? numericCodeAsString;

  Currency({
    this.currencyCode,
    this.defaultFractionDigits,
    this.numericCode,
    this.displayName,
    this.symbol,
    this.numericCodeAsString,
  });

  @override
  String toString() {
    return 'Currency(currencyCode: $currencyCode, defaultFractionDigits: $defaultFractionDigits, numericCode: $numericCode, displayName: $displayName, symbol: $symbol, numericCodeAsString: $numericCodeAsString)';
  }

  factory Currency.fromMap(Map<String, dynamic> data) => Currency(
        currencyCode: data['currencyCode'] as String?,
        defaultFractionDigits: data['defaultFractionDigits'] as int?,
        numericCode: data['numericCode'] as int?,
        displayName: data['displayName'] as String?,
        symbol: data['symbol'] as String?,
        numericCodeAsString: data['numericCodeAsString'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'currencyCode': currencyCode,
        'defaultFractionDigits': defaultFractionDigits,
        'numericCode': numericCode,
        'displayName': displayName,
        'symbol': symbol,
        'numericCodeAsString': numericCodeAsString,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Currency].
  factory Currency.fromJson(String data) {
    return Currency.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Currency] to a JSON string.
  String toJson() => json.encode(toMap());

  Currency copyWith({
    String? currencyCode,
    int? defaultFractionDigits,
    int? numericCode,
    String? displayName,
    String? symbol,
    String? numericCodeAsString,
  }) {
    return Currency(
      currencyCode: currencyCode ?? this.currencyCode,
      defaultFractionDigits:
          defaultFractionDigits ?? this.defaultFractionDigits,
      numericCode: numericCode ?? this.numericCode,
      displayName: displayName ?? this.displayName,
      symbol: symbol ?? this.symbol,
      numericCodeAsString: numericCodeAsString ?? this.numericCodeAsString,
    );
  }
}
