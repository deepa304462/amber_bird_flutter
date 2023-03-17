import 'dart:convert';

class Product {
  String? productName;

  Product({this.productName});

  @override
  String toString() => 'Product(productName: $productName)';

  factory Product.fromMap(Map<String, dynamic> data) => Product(
        productName: data['productName'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'productName': productName,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Product].
  factory Product.fromJson(String data) {
    return Product.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Product] to a JSON string.
  String toJson() => json.encode(toMap());

  Product copyWith({
    String? productName,
  }) {
    return Product(
      productName: productName ?? this.productName,
    );
  }
}
