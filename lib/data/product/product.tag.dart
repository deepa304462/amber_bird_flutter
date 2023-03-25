import 'dart:convert';

import 'package:amber_bird/data/deal_product/meta_data.dart';

 
class ProductTag {
  MetaData? metaData;
  String? title;
  String? description;
  String? imageId;
  String? id;

  ProductTag({
    this.metaData,
    this.title,
    this.description,
    this.imageId,
    this.id,
  });

  @override
  String toString() {
    return 'ProductTag(metaData: $metaData, title: $title, description: $description, imageId: $imageId, id: $id)';
  }

  factory ProductTag.fromMap(Map<String, dynamic> data) => ProductTag(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        title: data['title'] as String?,
        description: data['description'] as String?,
        imageId: data['imageId'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'title': title,
        'description': description,
        'imageId': imageId,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Product].
  factory ProductTag.fromJson(String data) {
    return ProductTag.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProductTag] to a JSON string.
  String toJson() => json.encode(toMap());

  ProductTag copyWith({
    MetaData? metaData,
    String? title,
    String? description,
    String? imageId,
    String? id,
  }) {
    return ProductTag(
      metaData: metaData ?? this.metaData,
      title: title ?? this.title,
      description: description ?? this.description,
      imageId: imageId ?? this.imageId,
      id: id ?? this.id,
    );
  }
}
