import 'dart:convert';


import 'package:amber_bird/data/deal_product/description.dart';
import 'package:amber_bird/data/deal_product/meta_data.dart';
import 'package:amber_bird/data/deal_product/name.dart';

import 'parent.dart';

class Category {
  MetaData? metaData;
  Name? name;
  Description? description;
  String? logoId;
  bool? subCategory;
  String? parentCategoryId;
  String? businessId;
  Parent? parent;
  dynamic? orderBy;
  String? id;

  Category({
    this.metaData,
    this.name,
    this.description,
    this.logoId,
    this.subCategory,
    this.parentCategoryId,
    this.businessId,
    this.parent,
    this.orderBy,
    this.id,
  });

  @override
  String toString() {
    return 'Category(metaData: $metaData, name: $name, description: $description, logoId: $logoId, subCategory: $subCategory, parentCategoryId: $parentCategoryId, businessId: $businessId, parent: $parent, orderBy: $orderBy, id: $id)';
  }

  factory Category.fromMap(Map<String, dynamic> data) => Category(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        name: data['name'] == null
            ? null
            : Name.fromMap(data['name'] as Map<String, dynamic>),
        description: data['description'] == null
            ? null
            : Description.fromMap(data['description'] as Map<String, dynamic>),
        logoId: data['logoId'] as String?,
        subCategory: data['subCategory'] as bool?,
        parentCategoryId: data['parentCategoryId'] as String?,
        businessId: data['businessId'] as String?,
        parent: data['parent'] == null
            ? null
            : Parent.fromMap(data['parent'] as Map<String, dynamic>),
        orderBy: data['orderBy'] as dynamic?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'name': name?.toMap(),
        'description': description?.toMap(),
        'logoId': logoId,
        'subCategory': subCategory,
        'parentCategoryId': parentCategoryId,
        'businessId': businessId,
        'parent': parent?.toMap(),
        'orderBy': orderBy,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Category].
  factory Category.fromJson(String data) {
    return Category.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Category] to a JSON string.
  String toJson() => json.encode(toMap());

  Category copyWith({
    MetaData? metaData,
    Name? name,
    Description? description,
    String? logoId,
    bool? subCategory,
    String? parentCategoryId,
    String? businessId,
    Parent? parent,
    dynamic? orderBy,
    String? id,
  }) {
    return Category(
      metaData: metaData ?? this.metaData,
      name: name ?? this.name,
      description: description ?? this.description,
      logoId: logoId ?? this.logoId,
      subCategory: subCategory ?? this.subCategory,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      businessId: businessId ?? this.businessId,
      parent: parent ?? this.parent,
      orderBy: orderBy ?? this.orderBy,
      id: id ?? this.id,
    );
  }
}
