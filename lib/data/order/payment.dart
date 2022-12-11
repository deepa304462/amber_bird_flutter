import 'dart:convert';

import 'package:amber_bird/data/payment/tax_detil.dart';
import 'package:amber_bird/data/profile/ref.dart';

// import 'currency.dart';
import 'order.dart';

class Payment {
  Ref? paidBy;
  Order? order;
  Ref? appliedCouponCode;
  dynamic? discountAmount;
  dynamic? totalAmount;
  dynamic? paidAmount;
  String? currency;
  Ref? paidTo;
  String? status;
  dynamic? appliedTaxAmount;
  String? description;
  String? bankTxnId;
   List<TaxDetail>? appliedTaxDetail;
  String? id;

  Payment({
    this.paidBy,
    this.order,
    this.appliedCouponCode,
    this.discountAmount,
    this.totalAmount,
    this.paidAmount,
    this.currency,
    this.paidTo,
    this.status,
    this.appliedTaxAmount,
    this.appliedTaxDetail,
    this.description,
    this.bankTxnId,
    this.id,
  });

  @override
  String toString() {
    return 'Payment(paidBy: $paidBy, order: $order, appliedCouponCode: $appliedCouponCode, discountAmount: $discountAmount, totalAmount: $totalAmount, paidAmount: $paidAmount, currency: $currency, paidTo: $paidTo, status: $status, appliedTaxAmount: $appliedTaxAmount,appliedTaxDetail:$appliedTaxDetail, description: $description, bankTxnId: $bankTxnId, id: $id)';
  }

  factory Payment.fromMap(Map<String, dynamic> data) => Payment(
        paidBy: data['paidBy'] == null
            ? null
            : Ref.fromMap(data['paidBy'] as Map<String, dynamic>),
        order: data['order'] == null
            ? null
            : Order.fromMap(data['order'] as Map<String, dynamic>),
        appliedCouponCode: data['appliedCouponCode'] == null
            ? null
            : Ref.fromMap(data['appliedCouponCode'] as Map<String, dynamic>),
        discountAmount: data['discountAmount'] as dynamic?,
        totalAmount: data['totalAmount'] as dynamic?,
        paidAmount: data['paidAmount'] as dynamic?,
        
        currency: data['currency'] as String?,
            // ? null
            // : Currency.fromMap(data['currency'] as Map<String, dynamic>),
        paidTo: data['paidTo'] == null
            ? null
            : Ref.fromMap(data['paidTo'] as Map<String, dynamic>),
        status: data['status'] as String?,
        appliedTaxAmount: data['appliedTaxAmount'] as dynamic?,
        appliedTaxDetail: (data['appliedTaxDetail'] as List<dynamic>?)
            ?.map((e) => TaxDetail.fromMap(e as Map<String, dynamic>))
            .toList(),
        description: data['description'] as String?,
        bankTxnId: data['bankTxnId'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'paidBy': paidBy?.toMap(),
        'order': order?.toMap(),
        'appliedCouponCode': appliedCouponCode?.toMap(),
        'discountAmount': discountAmount,
        'totalAmount': totalAmount,
        'paidAmount': paidAmount,
        'currency': currency,
        'paidTo': paidTo?.toMap(),
        'status': status,
        'appliedTaxAmount': appliedTaxAmount,
        'appliedTaxDetail': appliedTaxDetail,
        'description': description,
        'bankTxnId': bankTxnId,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Payment].
  factory Payment.fromJson(String data) {
    return Payment.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Payment] to a JSON string.
  String toJson() => json.encode(toMap());

  Payment copyWith({
    Ref? paidBy,
    Order? order,
    Ref? appliedCouponCode,
    dynamic? discountAmount,
    dynamic? totalAmount,
    dynamic? paidAmount,
    String? currency,
    Ref? paidTo,
    String? status,
    dynamic? appliedTaxAmount,
    List<TaxDetail>? appliedTaxDetail,
    String? description,
    String? bankTxnId,
    String? id,
  }) {
    return Payment(
      paidBy: paidBy ?? this.paidBy,
      order: order ?? this.order,
      appliedCouponCode: appliedCouponCode ?? this.appliedCouponCode,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      currency: currency ?? this.currency,
      paidTo: paidTo ?? this.paidTo,
      status: status ?? this.status,
      appliedTaxAmount: appliedTaxAmount ?? this.appliedTaxAmount,
      appliedTaxDetail: appliedTaxDetail ?? this.appliedTaxDetail,
      description: description ?? this.description,
      bankTxnId: bankTxnId ?? this.bankTxnId,
      id: id ?? this.id,
    );
  }
}
