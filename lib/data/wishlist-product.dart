import 'dart:convert';

import 'package:amber_bird/data/deal_product/product.dart';

class WishlistProduct {
  ProductSummary? product;
  bool? isChecked;

  WishlistProduct({this.product, this.isChecked});

  @override
  String toString() {
    return 'WishlistProduct( product: $product, isChecked: $isChecked)';
  }

  factory WishlistProduct.fromMap(Map<String, dynamic> data) => WishlistProduct(
        product: data['product'] == null
            ? null
            : ProductSummary.fromMap(data['product'] as Map<String, dynamic>),
        isChecked: data['isChecked'] as bool?,
      );

  Map<String, dynamic> toMap() =>
      {'product': product?.toMap(), 'isChecked': isChecked};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [WishlistProduct].
  factory WishlistProduct.fromJson(String data) {
    return WishlistProduct.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [WishlistProduct] to a JSON string.
  String toJson() => json.encode(toMap());

  WishlistProduct copyWith({
    ProductSummary? product,
    bool? isChecked,
  }) {
    return WishlistProduct(
      product: product ?? this.product,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
