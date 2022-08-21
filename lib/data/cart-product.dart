import 'dart:convert';

import 'package:amber_bird/data/deal_product/product.dart';

class CartProduct {
  List<ProductSummary>? product;
  int? quantity;
  String? addedFrom;
  String? refId;
  String? totalPrice;

  CartProduct(
      {this.product,
      this.quantity,
      this.refId,
      this.addedFrom,
      this.totalPrice});

  @override
  String toString() {
    return 'CartProduct( product: $product, quantity: $quantity, refId: $refId, addedFrom: $addedFrom,totalPrice: $totalPrice)';
  }

  factory CartProduct.fromMap(Map<String, dynamic> data) => CartProduct(
        product: (data['product'] as List<dynamic>?)
            ?.map((e) => ProductSummary.fromMap(e.toMap()))
            .toList(),
        quantity: data['quantity'] as int?,
        refId: data['refId'] as String?,
        addedFrom: data['addedFrom'] as String?,
        totalPrice: data['totalPrice'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'product': product?.map((e) => e.toMap()).toList(),
        'quantity': quantity,
        'refId': refId,
        'addedFrom': addedFrom,
        'totalPrice': totalPrice,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CartProduct].
  factory CartProduct.fromJson(String data) {
    return CartProduct.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CartProduct] to a JSON string.
  String toJson() => json.encode(toMap());

  CartProduct copyWith(
      {List<ProductSummary>? product,
      int? quantity,
      String? refId,
      String? addedFrom,
      String? totalPrice}) {
    return CartProduct(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      refId: refId ?? this.refId,
      addedFrom: addedFrom ?? this.addedFrom,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
