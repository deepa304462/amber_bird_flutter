import 'dart:convert';

 import 'package:amber_bird/data/deal_product/meta_data.dart';
import 'package:amber_bird/data/profile/ref.dart';


import 'payment_gate_way_detail.dart';

class Payment {
  MetaData? metaData;
  Ref? paidBy;
  Ref? order;
  dynamic appliedCouponCode;
  dynamic? discountAmount;
  dynamic? totalAmount;
  dynamic? paidAmount;
  String? currency;
  dynamic paidTo;
  String? status;
  PaymentGateWayDetail? paymentGateWayDetail;
  dynamic? appliedTaxAmount;
  String? description;
  dynamic businessId;
  String? checkoutUrl;
  String? id;

  Payment({
    this.metaData,
    this.paidBy,
    this.order,
    this.appliedCouponCode,
    this.discountAmount,
    this.totalAmount,
    this.paidAmount,
    this.currency,
    this.paidTo,
    this.status,
    this.paymentGateWayDetail,
    this.appliedTaxAmount,
    this.description,
    this.businessId,
    this.checkoutUrl,
    this.id,
  });

  @override
  String toString() {
    return 'Payment(metaData: $metaData, paidBy: $paidBy, order: $order, appliedCouponCode: $appliedCouponCode, discountAmount: $discountAmount, totalAmount: $totalAmount, paidAmount: $paidAmount, currency: $currency, paidTo: $paidTo, status: $status, paymentGateWayDetail: $paymentGateWayDetail, appliedTaxAmount: $appliedTaxAmount, description: $description, businessId: $businessId, checkoutUrl: $checkoutUrl, id: $id)';
  }

  factory Payment.fromMap(Map<String, dynamic> data) => Payment(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        paidBy: data['paidBy'] == null
            ? null
            : Ref.fromMap(data['paidBy'] as Map<String, dynamic>),
        order: data['order'] == null
            ? null
            : Ref.fromMap(data['order'] as Map<String, dynamic>),
        appliedCouponCode: data['appliedCouponCode'] as dynamic,
        discountAmount: data['discountAmount'] as dynamic?,
        totalAmount: data['totalAmount'] as dynamic?,
        paidAmount: data['paidAmount'] as dynamic?,
        currency: data['currency'] as String?,
        paidTo: data['paidTo'] as dynamic,
        status: data['status'] as String?,
        paymentGateWayDetail: data['paymentGateWayDetail'] == null
            ? null
            : PaymentGateWayDetail.fromMap(
                data['paymentGateWayDetail'] as Map<String, dynamic>),
        appliedTaxAmount: data['appliedTaxAmount'] as dynamic?,
        description: data['description'] as String?,
        businessId: data['businessId'] as dynamic,
        checkoutUrl: data['checkoutUrl'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'paidBy': paidBy?.toMap(),
        'order': order?.toMap(),
        'appliedCouponCode': appliedCouponCode,
        'discountAmount': discountAmount,
        'totalAmount': totalAmount,
        'paidAmount': paidAmount,
        'currency': currency,
        'paidTo': paidTo,
        'status': status,
        'paymentGateWayDetail': paymentGateWayDetail?.toMap(),
        'appliedTaxAmount': appliedTaxAmount,
        'description': description,
        'businessId': businessId,
        'checkoutUrl': checkoutUrl,
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
    MetaData? metaData,
    Ref? paidBy,
    Ref? order,
    dynamic appliedCouponCode,
    dynamic? discountAmount,
    dynamic? totalAmount,
    dynamic? paidAmount,
    String? currency,
    dynamic paidTo,
    String? status,
    PaymentGateWayDetail? paymentGateWayDetail,
    dynamic? appliedTaxAmount,
    String? description,
    dynamic businessId,
    String? checkoutUrl,
    String? id,
  }) {
    return Payment(
      metaData: metaData ?? this.metaData,
      paidBy: paidBy ?? this.paidBy,
      order: order ?? this.order,
      appliedCouponCode: appliedCouponCode ?? this.appliedCouponCode,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      currency: currency ?? this.currency,
      paidTo: paidTo ?? this.paidTo,
      status: status ?? this.status,
      paymentGateWayDetail: paymentGateWayDetail ?? this.paymentGateWayDetail,
      appliedTaxAmount: appliedTaxAmount ?? this.appliedTaxAmount,
      description: description ?? this.description,
      businessId: businessId ?? this.businessId,
      checkoutUrl: checkoutUrl ?? this.checkoutUrl,
      id: id ?? this.id,
    );
  }
}
