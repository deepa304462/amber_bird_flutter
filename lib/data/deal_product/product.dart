import 'dart:convert';

import 'category.dart';
import 'description.dart';
import 'name.dart';
import 'varient.dart';

class Product {
  Name? name;
  Description? description;
  List<dynamic>? images;
  Varient? varient;
  Category? category;
  String? countryCode;
  String? id;

  Product({
    this.name,
    this.description,
    this.images,
    this.varient,
    this.category,
    this.countryCode,
    this.id,
  });

  @override
  String toString() {
    return 'Product(name: $name, description: $description, images: $images, varient: $varient, category: $category, countryCode: $countryCode, id: $id)';
  }

  factory Product.fromMap(Map<String, dynamic> data) => Product(
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
        countryCode: data['countryCode'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name?.toMap(),
        'description': description?.toMap(),
        'images': images,
        'varient': varient?.toMap(),
        'category': category?.toMap(),
        'countryCode': countryCode,
        '_id': id,
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
    Name? name,
    Description? description,
    List<String>? images,
    Varient? varient,
    Category? category,
    String? countryCode,
    String? id,
  }) {
    return Product(
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      varient: varient ?? this.varient,
      category: category ?? this.category,
      countryCode: countryCode ?? this.countryCode,
      id: id ?? this.id,
    );
  }
}
