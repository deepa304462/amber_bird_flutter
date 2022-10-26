import 'dart:convert';

class PaymentGateWayDetail {
  dynamic usedPaymentGateWay;
  String? referenced;
  dynamic bankTxnId;
  dynamic bankTxnTime;
  List<dynamic>? gateWayResponseLogs;

  PaymentGateWayDetail({
    this.usedPaymentGateWay,
    this.referenced,
    this.bankTxnId,
    this.bankTxnTime,
    this.gateWayResponseLogs,
  });

  @override
  String toString() {
    return 'PaymentGateWayDetail(usedPaymentGateWay: $usedPaymentGateWay, referenced: $referenced, bankTxnId: $bankTxnId, bankTxnTime: $bankTxnTime, gateWayResponseLogs: $gateWayResponseLogs)';
  }

  factory PaymentGateWayDetail.fromMap(Map<String, dynamic> data) {
    return PaymentGateWayDetail(
      usedPaymentGateWay: data['usedPaymentGateWay'] as dynamic,
      referenced: data['referenced'] as String?,
      bankTxnId: data['bankTxnId'] as dynamic,
      bankTxnTime: data['bankTxnTime'] as dynamic,
      gateWayResponseLogs: data['gateWayResponseLogs'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toMap() => {
        'usedPaymentGateWay': usedPaymentGateWay,
        'referenced': referenced,
        'bankTxnId': bankTxnId,
        'bankTxnTime': bankTxnTime,
        'gateWayResponseLogs': gateWayResponseLogs,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PaymentGateWayDetail].
  factory PaymentGateWayDetail.fromJson(String data) {
    return PaymentGateWayDetail.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PaymentGateWayDetail] to a JSON string.
  String toJson() => json.encode(toMap());

  PaymentGateWayDetail copyWith({
    dynamic usedPaymentGateWay,
    String? referenced,
    dynamic bankTxnId,
    dynamic bankTxnTime,
    List<dynamic>? gateWayResponseLogs,
  }) {
    return PaymentGateWayDetail(
      usedPaymentGateWay: usedPaymentGateWay ?? this.usedPaymentGateWay,
      referenced: referenced ?? this.referenced,
      bankTxnId: bankTxnId ?? this.bankTxnId,
      bankTxnTime: bankTxnTime ?? this.bankTxnTime,
      gateWayResponseLogs: gateWayResponseLogs ?? this.gateWayResponseLogs,
    );
  }
}
