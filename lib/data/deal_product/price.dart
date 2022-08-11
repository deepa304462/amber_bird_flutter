import 'dart:convert';

class Price {
  dynamic? actualPrice;
  dynamic? offerPrice;
  dynamic? memberCoin;
  dynamic? primeMemberCoin;
  dynamic? goldMemberCoin;
  dynamic? silverMemberCoin;

  Price({
    this.actualPrice,
    this.offerPrice,
    this.memberCoin,
    this.primeMemberCoin,
    this.goldMemberCoin,
    this.silverMemberCoin,
  });

  @override
  String toString() {
    return 'Price(actualPrice: $actualPrice, offerPrice: $offerPrice, memberCoin: $memberCoin, primeMemberCoin: $primeMemberCoin, goldMemberCoin: $goldMemberCoin, silverMemberCoin: $silverMemberCoin)';
  }

  factory Price.fromMap(Map<String, dynamic> data) => Price(
        actualPrice: data['actualPrice'] as dynamic?,
        offerPrice: data['offerPrice'] as dynamic?,
        memberCoin: data['memberCoin'] as dynamic?,
        primeMemberCoin: data['primeMemberCoin'] as dynamic?,
        goldMemberCoin: data['goldMemberCoin'] as dynamic?,
        silverMemberCoin: data['silverMemberCoin'] as dynamic?,
      );

  Map<String, dynamic> toMap() => {
        'actualPrice': actualPrice,
        'offerPrice': offerPrice,
        'memberCoin': memberCoin,
        'primeMemberCoin': primeMemberCoin,
        'goldMemberCoin': goldMemberCoin,
        'silverMemberCoin': silverMemberCoin,
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
    dynamic? memberCoin,
    dynamic? primeMemberCoin,
    dynamic? goldMemberCoin,
    dynamic? silverMemberCoin,
  }) {
    return Price(
      actualPrice: actualPrice ?? this.actualPrice,
      offerPrice: offerPrice ?? this.offerPrice,
      memberCoin: memberCoin ?? this.memberCoin,
      primeMemberCoin: primeMemberCoin ?? this.primeMemberCoin,
      goldMemberCoin: goldMemberCoin ?? this.goldMemberCoin,
      silverMemberCoin: silverMemberCoin ?? this.silverMemberCoin,
    );
  }
}
