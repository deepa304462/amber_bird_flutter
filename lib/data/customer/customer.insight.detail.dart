import 'dart:convert';

import 'package:amber_bird/data/order/address.dart';
import 'package:amber_bird/data/order/order.dart';

import 'order.summary.insight.detail.dart';
import 'personal_info.insight.detail.dart';
import 'wish_list.insight.detail.dart';

class Customer {
  List<Address>? addresses;
  List<OrderSummary>? orders;
  Order? saveLater;
  Order? cart;
  WishList? wishList;
  PersonalInfo? personalInfo;

  Customer({
    this.addresses,
    this.orders,
    this.saveLater,
    this.cart,
    this.wishList,
    this.personalInfo,
  });

  @override
  String toString() {
    return 'Customer(addresses: $addresses, orders: $orders, saveLater: $saveLater, cart: $cart, wishList: $wishList, personalInfo: $personalInfo)';
  }

  factory Customer.fromMap(Map<String, dynamic> data) => Customer(
        addresses: (data['addresses'] as List<dynamic>?)
            ?.map((e) => Address.fromMap(e as Map<String, dynamic>))
            .toList(),
        orders: (data['orders'] as List<dynamic>?)
            ?.map((e) => OrderSummary.fromMap(e as Map<String, dynamic>))
            .toList(),
        saveLater: data['saveLater'] == null
            ? null
            : Order.fromMap(data['saveLater'] as Map<String, dynamic>),
        cart: data['cart'] == null
            ? null
            : Order.fromMap(data['cart'] as Map<String, dynamic>),
        wishList: data['wishList'] == null
            ? null
            : WishList.fromMap(data['wishList'] as Map<String, dynamic>),
        personalInfo: data['personalInfo'] == null
            ? null
            : PersonalInfo.fromMap(
                data['personalInfo'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'addresses': addresses?.map((e) => e.toMap()).toList(),
        'orders': orders?.map((e) => e.toMap()).toList(),
        'saveLater': saveLater?.toMap(),
        'cart': cart?.toMap(),
        'wishList': wishList?.toMap(),
        'personalInfo': personalInfo?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Customer].
  factory Customer.fromJson(String data) {
    return Customer.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Customer] to a JSON string.
  String toJson() => json.encode(toMap());

  Customer copyWith({
    List<Address>? addresses,
    List<OrderSummary>? orders,
    Order? saveLater,
    Order? cart,
    WishList? wishList,
    PersonalInfo? personalInfo,
  }) {
    return Customer(
      addresses: addresses ?? this.addresses,
      orders: orders ?? this.orders,
      saveLater: saveLater ?? this.saveLater,
      cart: cart ?? this.cart,
      wishList: wishList ?? this.wishList,
      personalInfo: personalInfo ?? this.personalInfo,
    );
  }
}
