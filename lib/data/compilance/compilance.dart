import 'dart:convert';

import 'package:amber_bird/data/deal_product/meta_data.dart';

import 'detailed_content.dart';

class Compilance {
  MetaData? metaData;
  List<DetailedContent>? detailedContent;
  String? type;
  String? id;

  Compilance({this.metaData, this.detailedContent, this.type, this.id});

  @override
  String toString() {
    return 'Compilance(metaData: $metaData, detailedContent: $detailedContent, type: $type, id: $id)';
  }

  factory Compilance.fromMap(Map<String, dynamic> data) => Compilance(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        detailedContent: (data['detailedContent'] as List<dynamic>?)
            ?.map((e) => DetailedContent.fromMap(e as Map<String, dynamic>))
            .toList(),
        type: data['type'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'detailedContent': detailedContent?.map((e) => e.toMap()).toList(),
        'type': type,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Compilance].
  factory Compilance.fromJson(String data) {
    return Compilance.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Compilance] to a JSON string.
  String toJson() => json.encode(toMap());

  Compilance copyWith({
    MetaData? metaData,
    List<DetailedContent>? detailedContent,
    String? type,
    String? id,
  }) {
    return Compilance(
      metaData: metaData ?? this.metaData,
      detailedContent: detailedContent ?? this.detailedContent,
      type: type ?? this.type,
      id: id ?? this.id,
    );
  }
}
