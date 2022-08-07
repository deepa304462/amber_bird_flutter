import 'dart:convert';

import 'meta_data.dart';
import 'name.dart';

class ProductCategory {
  MetaData? metaData;
  Name? name;
  String? logoId;
  bool? subCategory;
  String? parentCategoryId;
  String? businessId;
  String? id;

  ProductCategory({
    this.metaData,
    this.name,
    this.logoId,
    this.subCategory,
    this.parentCategoryId,
    this.businessId,
    this.id,
  });

  @override
  String toString() {
    return 'ProductCategory(metaData: $metaData, name: $name, logoId: $logoId, subCategory: $subCategory, parentCategoryId: $parentCategoryId, businessId: $businessId, id: $id)';
  }

  factory ProductCategory.fromMap(Map<String, dynamic> data) {
    return ProductCategory(
      metaData: data['metaData'] == null
          ? null
          : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
      name: data['name'] == null
          ? null
          : Name.fromMap(data['name'] as Map<String, dynamic>),
      logoId: data['logoId'] as String?,
      subCategory: data['subCategory'] as bool?,
      parentCategoryId: data['parentCategoryId'] as String?,
      businessId: data['businessId'] as String?,
      id: data['_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'name': name?.toMap(),
        'logoId': logoId,
        'subCategory': subCategory,
        'parentCategoryId': parentCategoryId,
        'businessId': businessId,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProductCategory].
  factory ProductCategory.fromJson(String data) {
    return ProductCategory.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProductCategory] to a JSON string.
  String toJson() => json.encode(toMap());

  ProductCategory copyWith({
    MetaData? metaData,
    Name? name,
    String? logoId,
    bool? subCategory,
    String? parentCategoryId,
    String? businessId,
    String? id,
  }) {
    return ProductCategory(
      metaData: metaData ?? this.metaData,
      name: name ?? this.name,
      logoId: logoId ?? this.logoId,
      subCategory: subCategory ?? this.subCategory,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      businessId: businessId ?? this.businessId,
      id: id ?? this.id,
    );
  }
}
