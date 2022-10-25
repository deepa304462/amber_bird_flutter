import 'dart:convert';

import 'package:amber_bird/data/deal_product/meta_data.dart';
import 'package:amber_bird/data/deal_product/name.dart';

import 'chapter.dart';
import 'ui_config.dart';

class ProductGuide {
  MetaData? metaData;
  Name? subject;
  Name? description;
  List<dynamic>? images;
  List<dynamic>? keywords;
  List<Chapter>? chapters;
  UiConfig? uiConfig;
  String? id;

  ProductGuide({
    this.metaData,
    this.subject,
    this.description,
    this.images,
    this.keywords,
    this.chapters,
    this.uiConfig,
    this.id,
  });

  @override
  String toString() {
    return 'ProductGuide(metaData: $metaData, subject: $subject, description: $description, images: $images, keywords: $keywords, chapters: $chapters, uiConfig: $uiConfig, id: $id)';
  }

  factory ProductGuide.fromMap(Map<String, dynamic> data) => ProductGuide(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        subject: data['subject'] == null
            ? null
            : Name.fromMap(data['subject'] as Map<String, dynamic>),
        description: data['description'] == null
            ? null
            : Name.fromMap(data['description'] as Map<String, dynamic>),
        images: data['images'] as List<dynamic>?,
        keywords: data['keywords'] as List<dynamic>?,
        chapters: (data['chapters'] as List<dynamic>?)
            ?.map((e) => Chapter.fromMap(e as Map<String, dynamic>))
            .toList(),
        uiConfig: data['uiConfig'] == null
            ? null
            : UiConfig.fromMap(data['uiConfig'] as Map<String, dynamic>),
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'subject': subject?.toMap(),
        'description': description?.toMap(),
        'images': images,
        'keywords': keywords,
        'chapters': chapters?.map((e) => e.toMap()).toList(),
        'uiConfig': uiConfig?.toMap(),
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProductGuide].
  factory ProductGuide.fromJson(String data) {
    return ProductGuide.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProductGuide] to a JSON string.
  String toJson() => json.encode(toMap());
}
