import 'dart:convert';

import 'package:amber_bird/data/coin_wallet/coin_wallet.dart';
import 'package:amber_bird/data/order/address.dart';
import 'package:amber_bird/data/order/order.dart';

import 'order.summary.insight.detail.dart';
import 'personal_info.insight.detail.dart';
import 'wish_list.insight.detail.dart';

class Customer {
  List<Address>? addresses;
  List<Order>? orders;
  Order? saveLater;
  Order? cart;
  WishList? wishList;
  PersonalInfo? personalInfo;
  CoinWallet? coinWalletDetail;
  List<Order>? openOrders;
  List<Order>? paidOrders;
  List<Order>? shippedOrders;
  List<Order>? deliveredOrders;
  List<Order>? cancelledOrders;

  Customer({
    this.addresses,
    this.orders,
    this.saveLater,
    this.cart,
    this.wishList,
    this.personalInfo,
    this.coinWalletDetail,
    this.cancelledOrders,
    this.deliveredOrders,
    this.openOrders,
    this.paidOrders,
    this.shippedOrders,
  });

  @override
  String toString() {
    return 'Customer(addresses: $addresses, orders: $orders, saveLater: $saveLater, cart: $cart, wishList: $wishList, personalInfo: $personalInfo,coinWalletDetail:$coinWalletDetail)';
  }

  factory Customer.fromMap(Map<String, dynamic> data) => Customer(
        addresses: (data['addresses'] as List<dynamic>?)
            ?.map((e) => Address.fromMap(e as Map<String, dynamic>))
            .toList(),
        orders: (data['orders'] as List<dynamic>?)
            ?.map((e) => Order.fromMap(e as Map<String, dynamic>))
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
        coinWalletDetail: data['coinWalletDetail'] == null
            ? null
            : CoinWallet.fromMap(
                data['coinWalletDetail'] as Map<String, dynamic>),
        openOrders: (data['openOrders'] as List<dynamic>?)
            ?.map((e) => Order.fromMap(e as Map<String, dynamic>))
            .toList(),
        paidOrders: (data['paidOrders'] as List<dynamic>?)
            ?.map((e) => Order.fromMap(e as Map<String, dynamic>))
            .toList(),
        shippedOrders: (data['shippedOrders'] as List<dynamic>?)
            ?.map((e) => Order.fromMap(e as Map<String, dynamic>))
            .toList(),
        deliveredOrders: (data['deliveredOrders'] as List<dynamic>?)
            ?.map((e) => Order.fromMap(e as Map<String, dynamic>))
            .toList(),
        cancelledOrders: (data['cancelledOrders'] as List<dynamic>?)
            ?.map((e) => Order.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'addresses': addresses?.map((e) => e.toMap()).toList(),
        'orders': orders?.map((e) => e.toMap()).toList(),
        'saveLater': saveLater?.toMap(),
        'cart': cart?.toMap(),
        'wishList': wishList?.toMap(),
        'personalInfo': personalInfo?.toMap(),
        'coinWalletDetail': coinWalletDetail?.toMap(),
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
    List<Order>? orders,
    Order? saveLater,
    Order? cart,
    WishList? wishList,
    PersonalInfo? personalInfo,
    CoinWallet? coinWalletDetail,
  }) {
    return Customer(
      addresses: addresses ?? this.addresses,
      orders: orders ?? this.orders,
      saveLater: saveLater ?? this.saveLater,
      cart: cart ?? this.cart,
      wishList: wishList ?? this.wishList,
      personalInfo: personalInfo ?? this.personalInfo,
      coinWalletDetail: coinWalletDetail ?? this.coinWalletDetail,
    );
  }
}
