import 'dart:convert';

import 'all_transaction.dart';

class CoinWallet {
  int? totalActiveCoins;
  int? totalPendingCoins;
  List<AllTransaction>? allTransactions;

  CoinWallet({
    this.totalActiveCoins,
    this.totalPendingCoins,
    this.allTransactions,
  });

  @override
  String toString() {
    return 'CoinWallet(totalActiveCoins: $totalActiveCoins, totalPendingCoins: $totalPendingCoins, allTransactions: $allTransactions)';
  }

  factory CoinWallet.fromMap(Map<String, dynamic> data) => CoinWallet(
        totalActiveCoins: data['totalActiveCoins'] as int?,
        totalPendingCoins: data['totalPendingCoins'] as int?,
        allTransactions: (data['allTransactions'] as List<dynamic>?)
            ?.map((e) => AllTransaction.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'totalActiveCoins': totalActiveCoins,
        'totalPendingCoins': totalPendingCoins,
        'allTransactions': allTransactions?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CoinWallet].
  factory CoinWallet.fromJson(String data) {
    return CoinWallet.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CoinWallet] to a JSON string.
  String toJson() => json.encode(toMap());

  CoinWallet copyWith({
    int? totalActiveCoins,
    int? totalPendingCoins,
    List<AllTransaction>? allTransactions,
  }) {
    return CoinWallet(
      totalActiveCoins: totalActiveCoins ?? this.totalActiveCoins,
      totalPendingCoins: totalPendingCoins ?? this.totalPendingCoins,
      allTransactions: allTransactions ?? this.allTransactions,
    );
  }
}
