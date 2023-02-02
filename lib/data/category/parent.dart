import 'dart:convert';

import 'package:amber_bird/data/deal_product/name.dart';

class Parent {
  Name? name;
  String? logoId;
  bool? subCategory;
  String? parentCategoryId;
  Parent? parent;
  String? id;

  Parent({
    this.name,
    this.logoId,
    this.subCategory,
    this.parentCategoryId,
    this.parent,
    this.id,
  });

  @override
  String toString() {
    return 'Parent(name: $name, logoId: $logoId, subCategory: $subCategory, parentCategoryId: $parentCategoryId, parent: $parent, id: $id)';
  }

  factory Parent.fromMap(Map<String, dynamic> data) => Parent(
        name: data['name'] == null
            ? null
            : Name.fromMap(data['name'] as Map<String, dynamic>),
        logoId: data['logoId'] as String?,
        subCategory: data['subCategory'] as bool?,
        parentCategoryId: data['parentCategoryId'] as String?,
        parent: data['parent'] == null
            ? null
            : Parent.fromMap(data['parent'] as Map<String, dynamic>), 
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name?.toMap(),
        'logoId': logoId,
        'subCategory': subCategory,
        'parentCategoryId': parentCategoryId,
        'parent': parent?.toMap(),
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Parent].
  factory Parent.fromJson(String data) {
    return Parent.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Parent] to a JSON string.
  String toJson() => json.encode(toMap());

  Parent copyWith({
    Name? name,
    String? logoId,
    bool? subCategory,
    String? parentCategoryId,
    Parent? parent,
    String? id,
  }) {
    return Parent(
      name: name ?? this.name,
      logoId: logoId ?? this.logoId,
      subCategory: subCategory ?? this.subCategory,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      parent: parent ?? this.parent,
      id: id ?? this.id,
    );
  }
}
