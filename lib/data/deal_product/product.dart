import 'dart:convert';

import 'package:amber_bird/data/brand/brand.dart';
import 'package:amber_bird/data/category/category.dart';
import 'package:amber_bird/data/deal_product/description.dart';
import 'package:amber_bird/data/deal_product/name.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/data/profile/ref.dart';

class ProductSummary {
  Name? name;
  Description? description;
  Name? nutritionDetail;
  Name? allergicDetail;
  List<dynamic>? images;
  Varient? varient;
  Category? category;
  String? countryCode;
  Brand? brand;
  bool? multiVarientExists;
  dynamic defaultPurchaseCount;
  String? type;
  List<Varient>? varients;
  List<Ref>? tags;
  String? id;

  ProductSummary({
    this.name,
    this.description,
    this.nutritionDetail,
    this.allergicDetail,
    this.images,
    this.varient,
    this.category,
    this.countryCode,
    this.brand,
    this.multiVarientExists,
    this.defaultPurchaseCount,
    this.type,
    this.varients,
    this.tags,
    this.id,
  });

  @override
  String toString() {
    return 'Product(name: $name, description: $description,nutritionDetail:$nutritionDetail,allergicDetail:$allergicDetail, images: $images, varient: $varient, category: $category, countryCode: $countryCode, brand: $brand, multiVarientExists: $multiVarientExists,defaultPurchaseCount: $defaultPurchaseCount, type: $type, varients: $varients, tags: $tags,id: $id)';
  }

  factory ProductSummary.fromMap(Map<String, dynamic> data) => ProductSummary(
        name: data['name'] == null
            ? null
            : Name.fromMap(data['name'] as Map<String, dynamic>),
        description: data['description'] == null
            ? null
            : Description.fromMap(data['description'] as Map<String, dynamic>),
        nutritionDetail: data['nutritionDetail'] == null
            ? null
            : Name.fromMap(data['nutritionDetail'] as Map<String, dynamic>),
        allergicDetail: data['allergicDetail'] == null
            ? null
            : Name.fromMap(data['allergicDetail'] as Map<String, dynamic>),
        images: data['images'] as List<dynamic>?,
        varient: data['varient'] == null
            ? null
            : Varient.fromMap(data['varient'] as Map<String, dynamic>),
        category: data['category'] == null
            ? null
            : Category.fromMap(data['category'] as Map<String, dynamic>),
        countryCode: data['countryCode'] as String?,
        brand: data['brand'] == null
            ? null
            : Brand.fromMap(data['brand'] as Map<String, dynamic>),
        multiVarientExists: data['multiVarientExists'] as bool?,
        defaultPurchaseCount: data['defaultPurchaseCount'] as dynamic,
        type: data['type'] as String?,
        varients: (data['varients'] as List<dynamic>?)
            ?.map((e) => Varient.fromMap(e as Map<String, dynamic>))
            .toList(),
        tags: (data['tags'] as List<dynamic>?)
            ?.map((e) => Ref.fromMap(e as Map<String, dynamic>))
            .toList(),
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name?.toMap(),
        'description': description?.toMap(),
        'nutritionDetail': nutritionDetail?.toMap(),
        'allergicDetail': allergicDetail?.toMap(),
        'images': images,
        'varient': varient?.toMap(),
        'category': category?.toMap(),
        'countryCode': countryCode,
        'brand': brand?.toMap(),
        'multiVarientExists': multiVarientExists,
        'defaultPurchaseCount': defaultPurchaseCount,
        'type': type,
        'varients': varients?.map((e) => e.toMap()).toList(),
        'tags': tags?.map((e) => e.toMap()).toList(),
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Product].
  factory ProductSummary.fromJson(String data) {
    return ProductSummary.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Product] to a JSON string.
  String toJson() => json.encode(toMap());

  ProductSummary copyWith({
    Name? name,
    Description? description,
    Name? nutritionDetail,
    Name? allergicDetail,
    List<dynamic>? images,
    Varient? varient,
    Category? category,
    String? countryCode,
    Brand? brand,
    bool? multiVarientExists,
    dynamic defaultPurchaseCount,
    String? type,
    List<Varient>? varients,
    List<Ref>? tags,
    String? id,
  }) {
    return ProductSummary(
      name: name ?? this.name,
      description: description ?? this.description,
      nutritionDetail: nutritionDetail ?? this.nutritionDetail,
      allergicDetail: allergicDetail ?? allergicDetail,
      images: images ?? this.images,
      varient: varient ?? this.varient,
      category: category ?? this.category,
      countryCode: countryCode ?? this.countryCode,
      brand: brand ?? this.brand,
      multiVarientExists: multiVarientExists ?? this.multiVarientExists,
      defaultPurchaseCount: defaultPurchaseCount ?? this.defaultPurchaseCount,
      type: type ?? this.type,
      varients: varients ?? this.varients,
      tags: tags ?? this.tags,
      id: id ?? this.id,
    );
  }
}
