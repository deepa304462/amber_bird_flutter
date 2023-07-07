import 'dart:convert';

import 'package:amber_bird/data/deal_product/meta_data.dart';

import 'detailed_content.dart';

class Complaince {
  MetaData? metaData;
  List<DetailedContent>? detailedContent;
  String? type;
  int? orderBy;
  String? id;

  Complaince({
    this.metaData,
    this.detailedContent,
    this.type,
    this.orderBy,
    this.id,
  });

  @override
  String toString() {
    return 'Complaince(metaData: $metaData, detailedContent: $detailedContent, type: $type, orderBy: $orderBy, id: $id)';
  }

  factory Complaince.fromMap(Map<String, dynamic> data) => Complaince(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        detailedContent: (data['detailedContent'] as List<dynamic>?)
            ?.map((e) => DetailedContent.fromMap(e as Map<String, dynamic>))
            .toList(),
        type: data['type'] as String?,
        orderBy: data['orderBy'] as int?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'detailedContent': detailedContent?.map((e) => e.toMap()).toList(),
        'type': type,
        'orderBy': orderBy,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Complaince].
  factory Complaince.fromJson(String data) {
    return Complaince.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Complaince] to a JSON string.
  String toJson() => json.encode(toMap());

  Complaince copyWith({
    MetaData? metaData,
    List<DetailedContent>? detailedContent,
    String? type,
    int? orderBy,
    String? id,
  }) {
    return Complaince(
      metaData: metaData ?? this.metaData,
      detailedContent: detailedContent ?? this.detailedContent,
      type: type ?? this.type,
      orderBy: orderBy ?? this.orderBy,
      id: id ?? this.id,
    );
  }
}
