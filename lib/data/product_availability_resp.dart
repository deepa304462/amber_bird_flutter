import 'dart:convert';

class ProductAvailabilityResp {
  List<String>? productsAvailableInDealTypes;
  List<String>? productsAvailableInMultiTypes;

  ProductAvailabilityResp({
    this.productsAvailableInDealTypes,
    this.productsAvailableInMultiTypes,
  });

  @override
  String toString() {
    return 'ProductAvailabilityResp(productsAvailableInDealTypes: $productsAvailableInDealTypes, productsAvailableInMultiTypes: $productsAvailableInMultiTypes)';
  }

  factory ProductAvailabilityResp.fromMap(Map<String, dynamic> data) {
    return ProductAvailabilityResp(
      productsAvailableInDealTypes:
          (data['productsAvailableInDealTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      // data['productsAvailableInDealTypes'] as List<String>?,
      productsAvailableInMultiTypes:
          (data['productsAvailableInMultiTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'productsAvailableInDealTypes': productsAvailableInDealTypes,
        'productsAvailableInMultiTypes': productsAvailableInMultiTypes,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProductAvailabilityResp].
  factory ProductAvailabilityResp.fromJson(String data) {
    return ProductAvailabilityResp.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProductAvailabilityResp] to a JSON string.
  String toJson() => json.encode(toMap());

  ProductAvailabilityResp copyWith({
    List<String>? productsAvailableInDealTypes,
    List<String>? productsAvailableInMultiTypes,
  }) {
    return ProductAvailabilityResp(
      productsAvailableInDealTypes:
          productsAvailableInDealTypes ?? this.productsAvailableInDealTypes,
      productsAvailableInMultiTypes:
          productsAvailableInMultiTypes ?? this.productsAvailableInMultiTypes,
    );
  }
}
