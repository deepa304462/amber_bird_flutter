import 'dart:convert';

import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/profile/ref.dart';
 
class Favorite {
  ProductSummary? product;
  List<ProductSummary>? products;
  String? productType;
  Ref? ref;
  String? addedOnTime;

  Favorite({
    this.product,
    this.products,
    this.productType,
    this.ref,
    this.addedOnTime,
  });

  @override
  String toString() {
    return 'Favorite(product: $product, products: $products, productType: $productType, ref: $ref, addedOnTime: $addedOnTime)';
  }

  factory Favorite.fromMap(Map<String, dynamic> data) => Favorite(
        product: data['product'] == null
            ? null
            : ProductSummary.fromMap(data['product'] as Map<String, dynamic>),
        products: (data['products'] as List<dynamic>?)
            ?.map((e) => ProductSummary.fromMap(e as Map<String, dynamic>))
            .toList(),
        productType: data['productType'] as String?,
        ref: data['ref'] == null
            ? null
            : Ref.fromMap(data['ref'] as Map<String, dynamic>),
        addedOnTime: data['addedOnTime'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'product': product?.toMap(),
        'products': products?.map((e) => e.toMap()).toList(),
        'productType': productType,
        'ref': ref?.toMap(),
        'addedOnTime': addedOnTime,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Favorite].
  factory Favorite.fromJson(String data) {
    return Favorite.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Favorite] to a JSON string.
  String toJson() => json.encode(toMap());

  Favorite copyWith({
    ProductSummary? product,
    List<ProductSummary>? products,
    String? productType,
    Ref? ref,
    String? addedOnTime,
  }) {
    return Favorite(
      product: product ?? this.product,
      products: products ?? this.products,
      productType: productType ?? this.productType,
      ref: ref ?? this.ref,
      addedOnTime: addedOnTime ?? this.addedOnTime,
    );
  }
}
