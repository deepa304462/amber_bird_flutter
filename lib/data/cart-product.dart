import 'dart:convert';

import 'package:amber_bird/data/deal_product/product.dart';

class CartProduct {
  ProductSummary? product;
  List<ProductSummary>? products;
  int? quantity;
  String? addedFrom;
  String? refId;
  String? totalPrice;

  CartProduct(
      {this.product,
      this.products,
      this.quantity,
      this.refId,
      this.addedFrom,
      this.totalPrice});

  @override
  String toString() {
    return 'CartProduct( product: $product,products: $products, quantity: $quantity, refId: $refId, addedFrom: $addedFrom,totalPrice: $totalPrice)';
  }

  factory CartProduct.fromMap(Map<String, dynamic> data) => CartProduct(
        product: data['product'] == null
            ? null
            : ProductSummary.fromMap(data['product'] as Map<String, dynamic>),
        products: (data['products'] as List<dynamic>?)
            ?.map((e) => ProductSummary.fromMap(e.toMap()))
            .toList(),
        quantity: data['quantity'] as int?,
        refId: data['refId'] as String?,
        addedFrom: data['addedFrom'] as String?,
        totalPrice: data['totalPrice'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'product': product,
        'products': products?.map((e) => e.toMap()).toList(),
        'quantity': quantity,
        'refId': refId,
        'addedFrom': addedFrom,
        'totalPrice': totalPrice,
      };

  /// Parses the string and returns the resulting Json object as [CartProduct].
  factory CartProduct.fromJson(String data) {
    return CartProduct.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CartProduct] to a JSON string.
  String toJson() => json.encode(toMap());

  CartProduct copyWith(
      {ProductSummary? product,
      List<ProductSummary>? products,
      int? quantity,
      String? refId,
      String? addedFrom,
      String? totalPrice}) {
    return CartProduct(
      product: product ?? this.product,
      products: products ?? this.products,
      quantity: quantity ?? this.quantity,
      refId: refId ?? this.refId,
      addedFrom: addedFrom ?? this.addedFrom,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
