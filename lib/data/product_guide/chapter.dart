import 'dart:convert';

import 'package:amber_bird/data/deal_product/name.dart';
import 'package:amber_bird/data/deal_product/product.dart';

class Chapter {
  Name? label;
  List<dynamic>? images;
  Name? subLabel;
  List<ProductSummary>? products;

  Chapter({this.label, this.images, this.subLabel, this.products});

  @override
  String toString() {
    return 'Chapter(label: $label, images: $images, subLabel: $subLabel, products: $products)';
  }

  factory Chapter.fromMap(Map<String, dynamic> data) => Chapter(
        label: data['label'] == null
            ? null
            : Name.fromMap(data['label'] as Map<String, dynamic>),
        images: data['images'] as List<dynamic>?,
        subLabel: data['subLabel'] == null
            ? null
            : Name.fromMap(data['subLabel'] as Map<String, dynamic>),
        products: (data['products'] as List<dynamic>?)
            ?.map((e) => ProductSummary.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'label': label?.toMap(),
        'images': images,
        'subLabel': subLabel?.toMap(),
        'products': products?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Chapter].
  factory Chapter.fromJson(String data) {
    return Chapter.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Chapter] to a JSON string.
  String toJson() => json.encode(toMap());
}
