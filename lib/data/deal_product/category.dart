import 'dart:convert';

import 'name.dart';

class Category {
  Name? name;
  String? logoId;
  bool? subCategory;
  String? parentCategoryId;
  String? id;

  Category({
    this.name,
    this.logoId,
    this.subCategory,
    this.parentCategoryId,
    this.id,
  });

  @override
  String toString() {
    return 'Category(name: $name, logoId: $logoId, subCategory: $subCategory, parentCategoryId: $parentCategoryId, id: $id)';
  }

  factory Category.fromMap(Map<String, dynamic> data) => Category(
        name: data['name'] == null
            ? null
            : Name.fromMap(data['name'] as Map<String, dynamic>),
        logoId: data['logoId'] as String?,
        subCategory: data['subCategory'] as bool?,
        parentCategoryId: data['parentCategoryId'] as String?,
        id: data['id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name?.toMap(),
        'logoId': logoId,
        'subCategory': subCategory,
        'parentCategoryId': parentCategoryId,
        'id': id,
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
    Name? name,
    String? logoId,
    bool? subCategory,
    String? parentCategoryId,
    String? id,
  }) {
    return Category(
      name: name ?? this.name,
      logoId: logoId ?? this.logoId,
      subCategory: subCategory ?? this.subCategory,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      id: id ?? this.id,
    );
  }
}
