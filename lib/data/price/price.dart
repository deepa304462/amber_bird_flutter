import 'dart:convert';

import 'members_special_price.dart';

class Price {
  double? actualPrice;
  double? offerPrice;
  dynamic? noMemberCoin;
  dynamic? platinumMemberCoin;
  dynamic? goldMemberCoin;
  dynamic? silverMemberCoin;
  dynamic? paidMemberCoin;
  MembersSpecialPrice? membersSpecialPrice;

  Price({
    this.actualPrice,
    this.offerPrice,
    this.noMemberCoin,
    this.platinumMemberCoin,
    this.goldMemberCoin,
    this.silverMemberCoin,
    this.paidMemberCoin,
    this.membersSpecialPrice,
  });

  @override
  String toString() {
    return 'Price(actualPrice: $actualPrice, offerPrice: $offerPrice, noMemberCoin: $noMemberCoin, platinumMemberCoin: $platinumMemberCoin, goldMemberCoin: $goldMemberCoin, silverMemberCoin: $silverMemberCoin, paidMemberCoin: $paidMemberCoin, membersSpecialPrice: $membersSpecialPrice)';
  }

  factory Price.fromMap(Map<String, dynamic> data) => Price(
        actualPrice: data['actualPrice'] as double?,
        offerPrice: data['offerPrice'] as double?,
        noMemberCoin: data['noMemberCoin'] as dynamic?,
        platinumMemberCoin: data['platinumMemberCoin'] as dynamic?,
        goldMemberCoin: data['goldMemberCoin'] as dynamic?,
        silverMemberCoin: data['silverMemberCoin'] as dynamic?,
        paidMemberCoin: data['paidMemberCoin'] as dynamic?,
        membersSpecialPrice: data['membersSpecialPrice'] == null
            ? null
            : MembersSpecialPrice.fromMap(
                data['membersSpecialPrice'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'actualPrice': actualPrice,
        'offerPrice': offerPrice,
        'noMemberCoin': noMemberCoin,
        'platinumMemberCoin': platinumMemberCoin,
        'goldMemberCoin': goldMemberCoin,
        'silverMemberCoin': silverMemberCoin,
        'paidMemberCoin': paidMemberCoin,
        'membersSpecialPrice': membersSpecialPrice?.toMap(),
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
    double? actualPrice,
    double? offerPrice,
    dynamic? noMemberCoin,
    dynamic? platinumMemberCoin,
    dynamic? goldMemberCoin,
    dynamic? silverMemberCoin,
    dynamic? paidMemberCoin,
    MembersSpecialPrice? membersSpecialPrice,
  }) {
    return Price(
      actualPrice: actualPrice ?? this.actualPrice,
      offerPrice: offerPrice ?? this.offerPrice,
      noMemberCoin: noMemberCoin ?? this.noMemberCoin,
      platinumMemberCoin: platinumMemberCoin ?? this.platinumMemberCoin,
      goldMemberCoin: goldMemberCoin ?? this.goldMemberCoin,
      silverMemberCoin: silverMemberCoin ?? this.silverMemberCoin,
      paidMemberCoin: paidMemberCoin ?? this.paidMemberCoin,
      membersSpecialPrice: membersSpecialPrice ?? this.membersSpecialPrice,
    );
  }
}
