import 'dart:convert';

import 'package:amber_bird/data/profile/ref.dart';

import 'last_movement.insight.detail.dart';

class OrderSummary {
  Ref? appliedCouponCode;
  dynamic discountAmount;
  dynamic totalAmount;
  dynamic paidAmount;
  String? status;
  String? shippingStatus;
  LastMovement? lastMovement;
  String? id;

  OrderSummary({
    this.appliedCouponCode,
    this.discountAmount,
    this.totalAmount,
    this.paidAmount,
    this.status,
    this.shippingStatus,
    this.lastMovement,
    this.id,
  });

  @override
  String toString() {
    return 'OrderSummary(appliedCouponCode: $appliedCouponCode, discountAmount: $discountAmount, totalAmount: $totalAmount, paidAmount: $paidAmount, status: $status, shippingStatus: $shippingStatus, lastMovement: $lastMovement, id: $id)';
  }

  factory OrderSummary.fromMap(Map<String, dynamic> data) => OrderSummary(
        appliedCouponCode: data['appliedCouponCode'] == null
            ? null
            : Ref.fromMap(data['appliedCouponCode'] as Map<String, dynamic>),
        discountAmount: data['discountAmount'] as dynamic,
        totalAmount: data['totalAmount'] as dynamic,
        paidAmount: data['paidAmount'] as dynamic,
        status: data['status'] as String?,
        shippingStatus: data['shippingStatus'] as String?,
        lastMovement: data['lastMovement'] == null
            ? null
            : LastMovement.fromMap(
                data['lastMovement'] as Map<String, dynamic>),
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'appliedCouponCode': appliedCouponCode?.toMap(),
        'discountAmount': discountAmount,
        'totalAmount': totalAmount,
        'paidAmount': paidAmount,
        'status': status,
        'shippingStatus': shippingStatus,
        'lastMovement': lastMovement?.toMap(),
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Order].
  factory OrderSummary.fromJson(String data) {
    return OrderSummary.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Order] to a JSON string.
  String toJson() => json.encode(toMap());

  OrderSummary copyWith({
    Ref? appliedCouponCode,
    dynamic discountAmount,
    dynamic totalAmount,
    dynamic paidAmount,
    String? status,
    String? shippingStatus,
    LastMovement? lastMovement,
    String? id,
  }) {
    return OrderSummary(
      appliedCouponCode: appliedCouponCode ?? this.appliedCouponCode,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      status: status ?? this.status,
      shippingStatus: shippingStatus ?? this.shippingStatus,
      lastMovement: lastMovement ?? this.lastMovement,
      id: id ?? this.id,
    );
  }
}
