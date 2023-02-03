import 'dart:convert';

import 'package:amber_bird/data/deal_product/meta_data.dart';
import 'package:amber_bird/data/payment/payment.dart';
import 'package:amber_bird/data/profile/ref.dart';

// import 'payment.dart';
import 'product_order.dart';
import 'shipping.dart';

class Order {
  MetaData? metaData;
  Payment? payment;
  Ref? customerRef;
  List<ProductOrder>? products;
  String? status;
  Shipping? shipping;

  Ref? shareLink;
  String? businessId;
  String? referredById;
  String? userFriendlyOrderId;
  String? id;

  Order({
    this.metaData,
    this.payment,
    this.products,
    this.status,
    this.shipping,
    this.customerRef,
    this.shareLink,
    this.businessId,
    this.referredById,
    this.userFriendlyOrderId,
    this.id,
  });

  @override
  String toString() {
    return 'Order(metaData: $metaData, payment: $payment, products: $products, status: $status, shipping: $shipping, customerRef: $customerRef, shareLink: $shareLink, businessId: $businessId, referredById: $referredById, userFriendlyOrderId: $userFriendlyOrderId, id: $id)';
  }

  factory Order.fromMap(Map<String, dynamic> data) => Order(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        payment: data['payment'] == null
            ? null
            : Payment.fromMap(data['payment'] as Map<String, dynamic>),
        products: (data['products'] as List<dynamic>?)
            ?.map((e) => ProductOrder.fromMap(e as Map<String, dynamic>))
            .toList(),
        status: data['status'] as String?,
        shipping: data['shipping'] == null
            ? null
            : Shipping.fromMap(data['shipping'] as Map<String, dynamic>),
        customerRef: data['customerRef'] == null
            ? null
            : Ref.fromMap(data['customerRef'] as Map<String, dynamic>),
        shareLink: data['shareLink'] == null
            ? null
            : Ref.fromMap(data['shareLink'] as Map<String, dynamic>),
        businessId: data['businessId'] as String?,
        referredById: data['referredById'] as String?,
        userFriendlyOrderId: data['userFriendlyOrderId'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'payment': payment?.toMap(),
        'products': products?.map((e) => e.toMap()).toList(),
        'status': status,
        'shipping': shipping?.toMap(),
        'customerRef': customerRef?.toMap(),
        'shareLink': shareLink?.toMap(),
        'businessId': businessId,
        'referredById': referredById,
        'userFriendlyOrderId': userFriendlyOrderId,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Order].
  factory Order.fromJson(String data) {
    return Order.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Order] to a JSON string.
  String toJson() => json.encode(toMap());

  Order copyWith({
    MetaData? metaData,
    Payment? payment,
    List<ProductOrder>? products,
    String? status,
    Shipping? shipping,
    Ref? customerRef,
    Ref? shareLink,
    String? businessId,
    String? referredById,
    String? userFriendlyOrderId,
    String? id,
  }) {
    return Order(
      metaData: metaData ?? this.metaData,
      payment: payment ?? this.payment,
      products: products ?? this.products,
      status: status ?? this.status,
      shipping: shipping ?? this.shipping,
      customerRef: customerRef ?? this.customerRef,
      shareLink: shareLink ?? this.shareLink,
      businessId: businessId ?? this.businessId,
      referredById: referredById ?? this.referredById,
      userFriendlyOrderId: userFriendlyOrderId ?? this.userFriendlyOrderId,
      id: id ?? this.id,
    );
  }
}
