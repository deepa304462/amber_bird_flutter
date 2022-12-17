import 'dart:convert';

import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/varient.dart';

class ProductAvailabilityStatus {
  String? productId;
  ProductSummary? productSummary;
  bool? available;
  int? availableProduct;
  String? availabilityText;
  List<ProductSummary>? recommendedProducts;
  List<Varient>? recommendedVarients;
  String? productInventoryId;

  ProductAvailabilityStatus({
    this.productId,
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
    return 'ProductAvailabilityStatus(productId: $productId, productSummary: $productSummary, available: $available, availableProduct: $availableProduct, availabilityText: $availabilityText, recommendedProducts: $recommendedProducts, recommendedVarients: $recommendedVarients, productInventoryId: $productInventoryId)';
  }

  factory ProductAvailabilityStatus.fromMap(Map<String, dynamic> data) {
    return ProductAvailabilityStatus(
      productId: data['productId'] as String?,
      productSummary: data['productSummary'] == null
          ? null
          : ProductSummary.fromMap(
              data['productSummary'] as Map<String, dynamic>),
      available: data['available'] as bool?,
      availableProduct: data['availableProduct'] as int?,
      availabilityText: data['availabilityText'] as String?,
      recommendedProducts: (data['recommendedProducts'] as List<dynamic>?)
          ?.map((e) => ProductSummary.fromMap(e as Map<String, dynamic>))
          .toList(),
      recommendedVarients: (data['recommendedVarients'] as List<dynamic>?)
          ?.map((e) => Varient.fromMap(e as Map<String, dynamic>))
          .toList(),
      productInventoryId: data['productInventoryId'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'productId': productId,
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
  /// Parses the string and returns the resulting Json object as [ProductAvailabilityStatus].
  factory ProductAvailabilityStatus.fromJson(String data) {
    return ProductAvailabilityStatus.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProductAvailabilityStatus] to a JSON string.
  String toJson() => json.encode(toMap());

  ProductAvailabilityStatus copyWith({
    String? productId,
    ProductSummary? productSummary,
    bool? available,
    int? availableProduct,
    String? availabilityText,
    List<ProductSummary>? recommendedProducts,
    List<Varient>? recommendedVarients,
    String? productInventoryId,
  }) {
    return ProductAvailabilityStatus(
      productId: productId ?? this.productId,
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
