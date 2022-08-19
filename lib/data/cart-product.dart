import 'dart:convert';

import 'package:amber_bird/data/deal_product/product.dart';

class CartProduct {
  List<ProductSummary>? product;
  int? quantity;
  String? id;

  CartProduct({this.product, this.quantity, this.id});

  @override
  String toString() {
    return 'CartProduct( product: $product, quantity: $quantity, id: $id)';
  }

  factory CartProduct.fromMap(Map<String, dynamic> data) => CartProduct(
        product: (data['product'] as List<dynamic>?)
            ?.map((e) => ProductSummary.fromMap(e.toMap()))
            .toList() ,
        quantity: data['quantity'] as int?,
        id: data['id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'product': product?.map((e) => e.toMap()).toList(),
        'quantity': quantity,
        'id': id,
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

  CartProduct copyWith({List<ProductSummary>? product, int? quantity, String? id}) {
    return CartProduct(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      id: id ?? this.id,
    );
  }
}
