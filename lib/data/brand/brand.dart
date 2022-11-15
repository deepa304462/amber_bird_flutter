import 'dart:convert';

import 'package:amber_bird/data/deal_product/description.dart';
import 'package:amber_bird/data/deal_product/meta_data.dart';

class Brand {
  MetaData? metaData;
  String? name;
  String? logoId;
  Description? description;
  bool? active;
  String? countryCode;
  String? businessId;
  int? orderBy;
  String? id;

  Brand({
    this.metaData,
    this.name,
    this.logoId,
    this.description,
    this.active,
    this.countryCode,
    this.businessId,
    this.orderBy,
    this.id,
  });

  factory Brand.fromMap(Map<String, dynamic> data) => Brand(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        name: data['name'] as String?,
        logoId: data['logoId'] as String?,
        description: data['description'] == null
            ? null
            : Description.fromMap(data['description'] as Map<String, dynamic>),
        active: data['active'] as bool?,
        countryCode: data['countryCode'] as String?,
        businessId: data['businessId'] as String?,
        orderBy: data['orderBy'] as int?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'name': name,
        'logoId': logoId,
        'description': description?.toMap(),
        'active': active,
        'countryCode': countryCode,
        'businessId': businessId,
        'orderBy': orderBy,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Brand].
  factory Brand.fromJson(String data) {
    return Brand.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Brand] to a JSON string.
  String toJson() => json.encode(toMap());
}
