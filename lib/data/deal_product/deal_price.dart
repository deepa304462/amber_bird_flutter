import 'dart:convert';

class DealPrice {
  dynamic? actualPrice;
  dynamic? offerPrice;
  dynamic? memberCoin;
  dynamic? primeMemberCoin;
  dynamic? goldMemberCoin;
  dynamic? silverMemberCoin;

  DealPrice({
    this.actualPrice,
    this.offerPrice,
    this.memberCoin,
    this.primeMemberCoin,
    this.goldMemberCoin,
    this.silverMemberCoin,
  });

  @override
  String toString() {
    return 'DealPrice(actualPrice: $actualPrice, offerPrice: $offerPrice, memberCoin: $memberCoin, primeMemberCoin: $primeMemberCoin, goldMemberCoin: $goldMemberCoin, silverMemberCoin: $silverMemberCoin)';
  }

  factory DealPrice.fromMap(Map<String, dynamic> data) => DealPrice(
        actualPrice: data['actualPrice'] as dynamic,
        offerPrice: data['offerPrice'] as dynamic,
        memberCoin: data['memberCoin'] as dynamic,
        primeMemberCoin: data['primeMemberCoin'] as dynamic,
        goldMemberCoin: data['goldMemberCoin'] as dynamic,
        silverMemberCoin: data['silverMemberCoin'] as dynamic,
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
  /// Parses the string and returns the resulting Json object as [DealPrice].
  factory DealPrice.fromJson(String data) {
    return DealPrice.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DealPrice] to a JSON string.
  String toJson() => json.encode(toMap());

  DealPrice copyWith({
    dynamic? actualPrice,
    dynamic? offerPrice,
    dynamic? memberCoin,
    dynamic? primeMemberCoin,
    dynamic? goldMemberCoin,
    dynamic? silverMemberCoin,
  }) {
    return DealPrice(
      actualPrice: actualPrice ?? this.actualPrice,
      offerPrice: offerPrice ?? this.offerPrice,
      memberCoin: memberCoin ?? this.memberCoin,
      primeMemberCoin: primeMemberCoin ?? this.primeMemberCoin,
      goldMemberCoin: goldMemberCoin ?? this.goldMemberCoin,
      silverMemberCoin: silverMemberCoin ?? this.silverMemberCoin,
    );
  }
}
