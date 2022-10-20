import 'dart:convert';

import 'package:amber_bird/data/payment/order-href.dart';
 
 
class Links {
  OrderHref? self;
  OrderHref? checkout;
  OrderHref? refunds;
  OrderHref? chargebacks;
  OrderHref? captures;
  OrderHref? settlement;
  OrderHref? documentation;
  OrderHref? mandate;
  OrderHref? subscription;
  OrderHref? customer;
  OrderHref? order;
  OrderHref? status;
  OrderHref? payOnline;
  OrderHref? changePaymentState;

  Links({
    this.self,
    this.checkout,
    this.refunds,
    this.chargebacks,
    this.captures,
    this.settlement,
    this.documentation,
    this.mandate,
    this.subscription,
    this.customer,
    this.order,
    this.status,
    this.payOnline,
    this.changePaymentState,
  });

  @override
  String toString() {
    return 'Links(self: $self, checkout: $checkout, refunds: $refunds, chargebacks: $chargebacks, captures: $captures, settlement: $settlement, documentation: $documentation, mandate: $mandate, subscription: $subscription, customer: $customer, order: $order, status: $status, payOnline: $payOnline, changePaymentState: $changePaymentState)';
  }

  factory Links.fromMap(Map<String, dynamic> data) => Links(
        self: data['self'] == null
            ? null
            : OrderHref.fromMap(data['self'] as Map<String, dynamic>),
        checkout: data['checkout'] == null
            ? null
            : OrderHref.fromMap(data['checkout'] as Map<String, dynamic>),
        refunds: data['refunds'] == null
            ? null
            : OrderHref.fromMap(data['refunds'] as Map<String, dynamic>),
        chargebacks: data['chargebacks'] == null
            ? null
            : OrderHref.fromMap(data['chargebacks'] as Map<String, dynamic>),
        captures: data['captures'] == null
            ? null
            : OrderHref.fromMap(data['captures'] as Map<String, dynamic>),
        settlement: data['settlement'] == null
            ? null
            : OrderHref.fromMap(data['settlement'] as Map<String, dynamic>),
        documentation: data['documentation'] == null
            ? null
            : OrderHref.fromMap(
                data['documentation'] as Map<String, dynamic>),
        mandate: data['mandate'] == null
            ? null
            : OrderHref.fromMap(data['mandate'] as Map<String, dynamic>),
        subscription: data['subscription'] == null
            ? null
            : OrderHref.fromMap(
                data['subscription'] as Map<String, dynamic>),
        customer: data['customer'] == null
            ? null
            : OrderHref.fromMap(data['customer'] as Map<String, dynamic>),
        order: data['order'] == null
            ? null
            : OrderHref.fromMap(data['order'] as Map<String, dynamic>),
        status: data['status'] == null
            ? null
            : OrderHref.fromMap(data['status'] as Map<String, dynamic>),
        payOnline: data['payOnline'] == null
            ? null
            : OrderHref.fromMap(data['payOnline'] as Map<String, dynamic>),
        changePaymentState: data['changePaymentState'] == null
            ? null
            : OrderHref.fromMap(
                data['changePaymentState'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'self': self?.toMap(),
        'checkout': checkout?.toMap(),
        'refunds': refunds?.toMap(),
        'chargebacks': chargebacks?.toMap(),
        'captures': captures?.toMap(),
        'settlement': settlement?.toMap(),
        'documentation': documentation?.toMap(),
        'mandate': mandate?.toMap(),
        'subscription': subscription?.toMap(),
        'customer': customer?.toMap(),
        'order': order?.toMap(),
        'status': status?.toMap(),
        'payOnline': payOnline?.toMap(),
        'changePaymentState': changePaymentState?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Links].
  factory Links.fromJson(String data) {
    return Links.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Links] to a JSON string.
  String toJson() => json.encode(toMap());

  Links copyWith({
    OrderHref? self,
    OrderHref? checkout,
    OrderHref? refunds,
    OrderHref? chargebacks,
    OrderHref? captures,
    OrderHref? settlement,
    OrderHref? documentation,
    OrderHref? mandate,
    OrderHref? subscription,
    OrderHref? customer,
    OrderHref? order,
    OrderHref? status,
    OrderHref? payOnline,
    OrderHref? changePaymentState,
  }) {
    return Links(
      self: self ?? this.self,
      checkout: checkout ?? this.checkout,
      refunds: refunds ?? this.refunds,
      chargebacks: chargebacks ?? this.chargebacks,
      captures: captures ?? this.captures,
      settlement: settlement ?? this.settlement,
      documentation: documentation ?? this.documentation,
      mandate: mandate ?? this.mandate,
      subscription: subscription ?? this.subscription,
      customer: customer ?? this.customer,
      order: order ?? this.order,
      status: status ?? this.status,
      payOnline: payOnline ?? this.payOnline,
      changePaymentState: changePaymentState ?? this.changePaymentState,
    );
  }
}
