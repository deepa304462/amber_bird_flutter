import 'dart:convert';

import 'package:amber_bird/data/deal_product/description.dart';
import 'package:amber_bird/data/deal_product/meta_data.dart';
import 'package:amber_bird/data/deal_product/name.dart';

class ProductTag {
  MetaData? metaData;
  Name? title;
  Description? description;
  String? imageId;
  String? id;

  ProductTag({
    this.metaData,
    this.title,
    this.description,
    this.imageId,
    this.id,
  });

  factory ProductTag.fromMap(Map<String, dynamic> data) => ProductTag(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        title: data['title'] == null
            ? null
            : Name.fromMap(data['title'] as Map<String, dynamic>),
        description: data['description'] == null
            ? null
            : Description.fromMap(data['description'] as Map<String, dynamic>),
        imageId: data['imageId'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'title': title?.toMap(),
        'description': description?.toMap(),
        'imageId': imageId,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProductTag].
  factory ProductTag.fromJson(String data) {
    return ProductTag.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProductTag] to a JSON string.
  String toJson() => json.encode(toMap());
}
