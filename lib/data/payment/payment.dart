import 'dart:convert';
import 'package:amber_bird/data/deal_product/meta_data.dart';
import 'package:amber_bird/data/payment/tax_detil.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'payment_gate_way_detail.dart';

class Payment {
  MetaData? metaData;
  Ref? paidBy;
  Ref? order;
  Ref? appliedCouponCode;
  dynamic? discountAmount;
  dynamic? totalAmount;
  dynamic? paidAmount;
  dynamic? totalSavedAmount;
  String? currency;
  dynamic paidTo;
  String? status;
  double? shippingAmount;
  double? totalAdditionalDiscountAmount;
  PaymentGateWayDetail? paymentGateWayDetail;
  dynamic? appliedTaxAmount;
  List<TaxDetail>? appliedTaxDetail;
  String? description;
  dynamic businessId;
  dynamic totalSCoinsEarned;
  dynamic totalSPointsEarned;
  dynamic totalSCoinsPaid;
  String? checkoutUrl;
  String? bankTxnId;
  String? id;

  Payment({
    this.metaData,
    this.paidBy,
    this.order,
    this.appliedCouponCode,
    this.discountAmount,
    this.totalSavedAmount,
    this.totalAmount,
    this.paidAmount,
    this.currency,
    this.paidTo,
    this.status,
    this.shippingAmount,
    this.totalAdditionalDiscountAmount,
    this.paymentGateWayDetail,
    this.appliedTaxAmount,
    this.appliedTaxDetail,
    this.description,
    this.businessId,
    this.totalSCoinsEarned,
    this.totalSPointsEarned,
    this.totalSCoinsPaid,
    this.checkoutUrl,
    this.bankTxnId,
    this.id,
  });

  @override
  String toString() {
    return 'Payment(metaData: $metaData, paidBy: $paidBy, order: $order, appliedCouponCode: $appliedCouponCode,appliedTaxDetail: $appliedTaxDetail, discountAmount: $discountAmount, totalAmount: $totalAmount, paidAmount: $paidAmount, currency: $currency, paidTo: $paidTo, status: $status, shippingAmount:$shippingAmount,totalAdditionalDiscountAmount:$totalAdditionalDiscountAmount,paymentGateWayDetail: $paymentGateWayDetail, appliedTaxAmount: $appliedTaxAmount, description: $description, businessId: $businessId,totalSCoinsEarned: $totalSCoinsEarned,totalSPointsEarned: $totalSPointsEarned,totalSCoinsPaid: $totalSCoinsPaid, checkoutUrl: $checkoutUrl,bankTxnId:$bankTxnId, id: $id)';
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
        appliedCouponCode: data['appliedCouponCode'] == null
            ? null
            : Ref.fromMap(data['appliedCouponCode'] as Map<String, dynamic>),
        appliedTaxDetail: data['appliedTaxDetail'] == null
            ? null
            : (data['appliedTaxDetail'] as List<dynamic>?)
                ?.map((e) => TaxDetail.fromMap(e as Map<String, dynamic>))
                .toList(),
        discountAmount: data['discountAmount'] as dynamic?,
        totalSavedAmount: data['totalSavedAmount'] as dynamic?,
        totalAmount: data['totalAmount'] as dynamic?,
        paidAmount: data['paidAmount'] as dynamic?,
        currency: data['currency'] as String?,
        paidTo: data['paidTo'] as dynamic,
        status: data['status'] as String?,
        shippingAmount: data['shippingAmount'] as double?,
        totalAdditionalDiscountAmount:
            data['totalAdditionalDiscountAmount'] as double?,
        bankTxnId: data['bankTxnId'] as String?,
        paymentGateWayDetail: data['paymentGateWayDetail'] == null
            ? null
            : PaymentGateWayDetail.fromMap(
                data['paymentGateWayDetail'] as Map<String, dynamic>),
        appliedTaxAmount: data['appliedTaxAmount'] as dynamic?,
        description: data['description'] as String?,
        businessId: data['businessId'] as dynamic,
        totalSCoinsEarned: data['totalSCoinsEarned'] as dynamic,
        totalSPointsEarned: data['totalSPointsEarned'] as dynamic,
        totalSCoinsPaid: data['totalSCoinsPaid'] as dynamic,
        checkoutUrl: data['checkoutUrl'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'paidBy': paidBy?.toMap(),
        'order': order?.toMap(),
        'appliedCouponCode': appliedCouponCode?.toMap(),
        'discountAmount': discountAmount,
        'totalSavedAmount': totalSavedAmount,
        'totalAmount': totalAmount,
        'paidAmount': paidAmount,
        'currency': currency,
        'paidTo': paidTo,
        'status': status,
        'shippingAmount': shippingAmount,
        'totalAdditionalDiscountAmount': totalAdditionalDiscountAmount,
        'paymentGateWayDetail': paymentGateWayDetail?.toMap(),
        'appliedTaxAmount': appliedTaxAmount,
        'appliedTaxDetail': appliedTaxDetail?.map((e) => e.toMap()).toList(),
        'description': description,
        'businessId': businessId,
        'totalSCoinsEarned': totalSCoinsEarned,
        'totalSPointsEarned': totalSPointsEarned,
        'totalSCoinsPaid': totalSCoinsPaid,
        'checkoutUrl': checkoutUrl,
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
    MetaData? metaData,
    Ref? paidBy,
    Ref? order,
    Ref? appliedCouponCode,
    dynamic? discountAmount,
    dynamic? totalAmount,
    dynamic? paidAmount,
    String? currency,
    dynamic paidTo,
    String? status,
    double? shippingAmount,
    double? totalAdditionalDiscountAmount,
    PaymentGateWayDetail? paymentGateWayDetail,
    dynamic? appliedTaxAmount,
    List<TaxDetail>? appliedTaxDetail,
    String? description,
    dynamic businessId,
    dynamic totalSCoinsEarned,
    dynamic totalSPointsEarned,
    dynamic totalSCoinsPaid,
    String? checkoutUrl,
    String? bankTxnId,
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
      shippingAmount: shippingAmount ?? this.shippingAmount,
      totalAdditionalDiscountAmount:
          totalAdditionalDiscountAmount ?? totalAdditionalDiscountAmount,
      paymentGateWayDetail: paymentGateWayDetail ?? this.paymentGateWayDetail,
      appliedTaxAmount: appliedTaxAmount ?? this.appliedTaxAmount,
      appliedTaxDetail: appliedTaxDetail ?? this.appliedTaxDetail,
      description: description ?? this.description,
      businessId: businessId ?? this.businessId,
      checkoutUrl: checkoutUrl ?? this.checkoutUrl,
      totalSCoinsEarned: totalSCoinsEarned ?? this.totalSCoinsEarned,
      totalSPointsEarned: totalSPointsEarned ?? this.totalSPointsEarned,
      totalSCoinsPaid: totalSCoinsPaid ?? this.totalSCoinsPaid,
      bankTxnId: bankTxnId ?? this.bankTxnId,
      id: id ?? this.id,
    );
  }
}
