import 'dart:convert';

import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/profile/ref.dart';

class ProductOrder {
  ProductSummary? product;
  List<ProductSummary>? products;
  String? productType;
  Ref? ref;
  int? count;
  Price? price;

  ProductOrder({
    this.product,
    this.products,
    this.productType,
    this.ref,
    this.count,
    this.price,
  });

  @override
  String toString() {
    return 'Product(product: $product, products: $products, productType: $productType, ref: $ref, count: $count, price: $price)';
  }

  factory ProductOrder.fromMap(Map<String, dynamic> data) => ProductOrder(
        product: data['product'] == null
            ? null
            : ProductSummary.fromMap(data['product']
                as Map<String, dynamic>), //data['product'] ?? null,
        products: (data['products'] as List<dynamic>?)
            ?.map((e) => ProductSummary.fromMap(e as Map<String, dynamic>))
            .toList(),
        productType: data['productType'] as String?,
        ref: data['ref'] == null
            ? null
            : Ref.fromMap(data['ref'] as Map<String,
                dynamic>), //data['ref'] == null ? null : data['ref'],
        count: data['count'] as int?,
        price: data['price'] == null
            ? null
            : Price.fromMap(data['price'] as Map<String,
                dynamic>), //data['price'] == null ? null : data['price'],
      );

  Map<String, dynamic> toMap() => {
        'product': product?.toMap(),
        'products': products?.map((e) => e.toMap()).toList(),
        'productType': productType,
        'ref': ref?.toMap(),
        'count': count,
        'price': price?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Product].
  factory ProductOrder.fromJson(String data) {
    return ProductOrder.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Product] to a JSON string.
  String toJson() => json.encode(toMap());

  ProductOrder copyWith({
    ProductSummary? product,
    List<ProductSummary>? products,
    String? productType,
    Ref? ref,
    int? count,
    Price? price,
  }) {
    return ProductOrder(
      product: product ?? this.product,
      products: products ?? this.products,
      productType: productType ?? this.productType,
      ref: ref ?? this.ref,
      count: count ?? this.count,
      price: price ?? this.price,
    );
  }
}