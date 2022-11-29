import 'dart:convert';
 
import 'package:amber_bird/data/brand/brand.dart';
import 'package:amber_bird/data/deal_product/category.dart';
import 'package:amber_bird/data/deal_product/description.dart';
import 'package:amber_bird/data/deal_product/meta_data.dart';
import 'package:amber_bird/data/deal_product/name.dart';
import 'package:amber_bird/data/deal_product/varient.dart';

import 'marketing_info.dart';
 
class RecommendedProduct {
  MetaData? metaData;
  Name? name;
  Description? description;
  List<String>? images;
  List<Varient>? varients;
  List<String>? keywords;
  Brand? brand;
  Category? category;
  String? defaultVarientCode;
  MarketingInfo? marketingInfo;
  String? type;
  String? countryCode;
  String? businessId;
  String? id;

  RecommendedProduct({
    this.metaData,
    this.name,
    this.description,
    this.images,
    this.varients,
    this.keywords,
    this.brand,
    this.category,
    this.defaultVarientCode,
    this.marketingInfo,
    this.type,
    this.countryCode,
    this.businessId,
    this.id,
  });

  @override
  String toString() {
    return 'RecommendedProduct(metaData: $metaData, name: $name, description: $description, images: $images, varients: $varients, keywords: $keywords, brand: $brand, category: $category, defaultVarientCode: $defaultVarientCode, marketingInfo: $marketingInfo, type: $type, countryCode: $countryCode, businessId: $businessId, id: $id)';
  }

  factory RecommendedProduct.fromMap(Map<String, dynamic> data) {
    return RecommendedProduct(
      metaData: data['metaData'] == null
          ? null
          : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
      name: data['name'] == null
          ? null
          : Name.fromMap(data['name'] as Map<String, dynamic>),
      description: data['description'] == null
          ? null
          : Description.fromMap(data['description'] as Map<String, dynamic>),
      images:(data['images'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList(),
      varients: (data['varients'] as List<dynamic>?)
          ?.map((e) => Varient.fromMap(e as Map<String, dynamic>))
          .toList(),
      keywords: (data['keywords'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList(),
      brand: data['brand'] == null
          ? null
          : Brand.fromMap(data['brand'] as Map<String, dynamic>),
      category: data['category'] == null
          ? null
          : Category.fromMap(data['category'] as Map<String, dynamic>),
      defaultVarientCode: data['defaultVarientCode'] as String?,
      marketingInfo: data['marketingInfo'] == null
          ? null
          : MarketingInfo.fromMap(
              data['marketingInfo'] as Map<String, dynamic>),
      type: data['type'] as String?,
      countryCode: data['countryCode'] as String?,
      businessId: data['businessId'] as String?,
      id: data['_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'name': name?.toMap(),
        'description': description?.toMap(),
        'images': images,
        'varients': varients?.map((e) => e.toMap()).toList(),
        'keywords': keywords,
        'brand': brand?.toMap(),
        'category': category?.toMap(),
        'defaultVarientCode': defaultVarientCode,
        'marketingInfo': marketingInfo?.toMap(),
        'type': type,
        'countryCode': countryCode,
        'businessId': businessId,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RecommendedProduct].
  factory RecommendedProduct.fromJson(String data) {
    return RecommendedProduct.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RecommendedProduct] to a JSON string.
  String toJson() => json.encode(toMap());

  RecommendedProduct copyWith({
    MetaData? metaData,
    Name? name,
    Description? description,
    List<String>? images,
    List<Varient>? varients,
    List<String>? keywords,
    Brand? brand,
    Category? category,
    String? defaultVarientCode,
    MarketingInfo? marketingInfo,
    String? type,
    String? countryCode,
    String? businessId,
    String? id,
  }) {
    return RecommendedProduct(
      metaData: metaData ?? this.metaData,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      varients: varients ?? this.varients,
      keywords: keywords ?? this.keywords,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      defaultVarientCode: defaultVarientCode ?? this.defaultVarientCode,
      marketingInfo: marketingInfo ?? this.marketingInfo,
      type: type ?? this.type,
      countryCode: countryCode ?? this.countryCode,
      businessId: businessId ?? this.businessId,
      id: id ?? this.id,
    );
  }
}
