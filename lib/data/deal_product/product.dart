import 'dart:convert';

import 'package:amber_bird/data/brand/brand.dart';
import 'package:amber_bird/data/category/category.dart';
 
 import 'description.dart';
import 'name.dart';
import 'varient.dart';

class ProductSummary {
  Name? name;
  Description? description;
  List<dynamic>? images;
  Varient? varient;
  Category? category;
  Brand? brand;
  bool? multiVarientExists;
  String? type;
  String? countryCode;
  String? id;

  ProductSummary({
    this.name,
    this.description,
    this.images,
    this.varient,
    this.category,
    this.multiVarientExists,
    this.type,
    this.countryCode,
    this.id,
  });

  @override
  String toString() {
    return 'Product(name: $name, description: $description, images: $images, varient: $varient,  multiVarientExists:$multiVarientExists, type:$type, category: $category, countryCode: $countryCode, id: $id)';
  }

  factory ProductSummary.fromMap(Map<String, dynamic> data) => ProductSummary(
        name: data['name'] == null
            ? null
            : Name.fromMap(data['name'] as Map<String, dynamic>),
        description: data['description'] == null
            ? null
            : Description.fromMap(data['description'] as Map<String, dynamic>),
        images: data['images'] as List<dynamic>?,
        varient: data['varient'] == null
            ? null
            : Varient.fromMap(data['varient'] as Map<String, dynamic>),
        category: data['category'] == null
            ? null
            : Category.fromMap(data['category'] as Map<String, dynamic>),
        multiVarientExists: data['multiVarientExists'] as bool?,
        type: data['type'] as String?,
        countryCode: data['countryCode'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name?.toMap(),
        'description': description?.toMap(),
        'images': images,
        'varient': varient?.toMap(),
        'category': category?.toMap(),
        'multiVarientExists': multiVarientExists,
        'type': type,
        'countryCode': countryCode,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProductSummary].
  factory ProductSummary.fromJson(String data) {
    return ProductSummary.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProductSummary] to a JSON string.
  String toJson() => json.encode(toMap());

  ProductSummary copyWith({
    Name? name,
    Description? description,
    List<String>? images,
    Varient? varient,
    Category? category,
    bool? multiVarientExists,
    String? type,
    String? countryCode,
    String? id,
  }) {
    return ProductSummary(
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      varient: varient ?? this.varient,
      category: category ?? this.category,
      multiVarientExists: multiVarientExists ?? this.multiVarientExists,
      type: type ?? this.type,
      countryCode: countryCode ?? this.countryCode,
      id: id ?? this.id,
    );
  }
}
