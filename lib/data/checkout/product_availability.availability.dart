import 'dart:convert';

import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/product/product.dart';

import 'recommended_varient.availability.dart';

class ProductAvailability {
  ProductSummary? productSummary;
  bool? available;
  int? availableProduct;
  String? availabilityText;
  List<Product>? recommendedProducts;
  List<RecommendedVarient>? recommendedVarients;
  String? productInventoryId;

  ProductAvailability({
    this.productSummary,
    this.available,
    this.availableProduct,
    this.availabilityText,
    this.recommendedProducts,
    this.recommendedVarients,
    this.productInventoryId,
  });

  @override
  String toString() {
    return 'ProductAvailability(productSummary: $productSummary, available: $available, availableProduct: $availableProduct, availabilityText: $availabilityText, recommendedProducts: $recommendedProducts, recommendedVarients: $recommendedVarients, productInventoryId: $productInventoryId)';
  }

  factory ProductAvailability.fromMap(Map<String, dynamic> data) {
    return ProductAvailability(
      productSummary: data['productSummary'] == null
          ? null
          : ProductSummary.fromMap(
              data['productSummary'] as Map<String, dynamic>),
      available: data['available'] as bool?,
      availableProduct: data['availableProduct'] as int?,
      availabilityText: data['availabilityText'] as String?,
      recommendedProducts: (data['recommendedProducts'] as List<dynamic>?)
          ?.map((e) => Product.fromMap(e as Map<String, dynamic>))
          .toList(),
      recommendedVarients: (data['recommendedVarients'] as List<dynamic>?)
          ?.map((e) => RecommendedVarient.fromMap(e as Map<String, dynamic>))
          .toList(),
      productInventoryId: data['productInventoryId'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'productSummary': productSummary?.toMap(),
        'available': available,
        'availableProduct': availableProduct,
        'availabilityText': availabilityText,
        'recommendedProducts':
            recommendedProducts?.map((e) => e.toMap()).toList(),
        'recommendedVarients':
            recommendedVarients?.map((e) => e.toMap()).toList(),
        'productInventoryId': productInventoryId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProductAvailability].
  factory ProductAvailability.fromJson(String data) {
    return ProductAvailability.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProductAvailability] to a JSON string.
  String toJson() => json.encode(toMap());

  ProductAvailability copyWith({
    ProductSummary? productSummary,
    bool? available,
    int? availableProduct,
    String? availabilityText,
    List<Product>? recommendedProducts,
    List<RecommendedVarient>? recommendedVarients,
    String? productInventoryId,
  }) {
    return ProductAvailability(
      productSummary: productSummary ?? this.productSummary,
      available: available ?? this.available,
      availableProduct: availableProduct ?? this.availableProduct,
      availabilityText: availabilityText ?? this.availabilityText,
      recommendedProducts: recommendedProducts ?? this.recommendedProducts,
      recommendedVarients: recommendedVarients ?? this.recommendedVarients,
      productInventoryId: productInventoryId ?? this.productInventoryId,
    );
  }
}
