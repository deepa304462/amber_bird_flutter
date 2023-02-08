import 'dart:convert';

class Price {
  dynamic? actualPrice;
  dynamic? offerPrice;
  dynamic? noMemberCoin;
  dynamic? platinumMemberCoin;
  dynamic? goldMemberCoin;
  dynamic? silverMemberCoin;
  dynamic? paidMemberCoin;

  Price({
    this.actualPrice,
    this.offerPrice,
    this.noMemberCoin,
    this.platinumMemberCoin,
    this.goldMemberCoin,
    this.silverMemberCoin,
    this.paidMemberCoin,
  });

  @override
  String toString() {
    return 'Price(actualPrice: $actualPrice, offerPrice: $offerPrice, noMemberCoin: $noMemberCoin, platinumMemberCoin: $platinumMemberCoin, goldMemberCoin: $goldMemberCoin, silverMemberCoin: $silverMemberCoin,paidMemberCoin:$paidMemberCoin)';
  }

  factory Price.fromMap(Map<String, dynamic> data) => Price(
        actualPrice: data['actualPrice'] as dynamic?,
        offerPrice: data['offerPrice'] as dynamic?,
        noMemberCoin: data['noMemberCoin'] as dynamic?,
        platinumMemberCoin: data['platinumMemberCoin'] as dynamic?,
        goldMemberCoin: data['goldMemberCoin'] as dynamic?,
        silverMemberCoin: data['silverMemberCoin'] as dynamic?,
        paidMemberCoin: data['paidMemberCoin'] as dynamic?,
      );

  Map<String, dynamic> toMap() => {
        'actualPrice': actualPrice,
        'offerPrice': offerPrice,
        'noMemberCoin': noMemberCoin,
        'platinumMemberCoin': platinumMemberCoin,
        'goldMemberCoin': goldMemberCoin,
        'silverMemberCoin': silverMemberCoin,
        'paidMemberCoin': paidMemberCoin,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Price].
  factory Price.fromJson(String data) {
    return Price.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Price] to a JSON string.
  String toJson() => json.encode(toMap());

  Price copyWith({
    dynamic? actualPrice,
    dynamic? offerPrice,
    dynamic? noMemberCoin,
    dynamic? platinumMemberCoin, 
    dynamic? goldMemberCoin,
    dynamic? silverMemberCoin,
    dynamic? paidMemberCoin,
  }) {
    return Price(
      actualPrice: actualPrice ?? this.actualPrice,
      offerPrice: offerPrice ?? this.offerPrice,
      noMemberCoin: noMemberCoin ?? this.noMemberCoin,
      platinumMemberCoin: platinumMemberCoin ?? this.platinumMemberCoin,
      goldMemberCoin: goldMemberCoin ?? this.goldMemberCoin,
      silverMemberCoin: silverMemberCoin ?? this.silverMemberCoin,
      paidMemberCoin: paidMemberCoin ?? this.paidMemberCoin,
    );
  }
}
