import 'dart:convert';

import 'package:amber_bird/data/deal_product/meta_data.dart';

import 'extra_data.dart';

class ShortLink {
  MetaData? metaData;
  String? type;
  String? shortUrl;
  ExtraData? extraData;
  String? redirectUrl;
  String? expireTime;
  String? createdForService;
  String? id;

  ShortLink({
    this.metaData,
    this.type,
    this.shortUrl,
    this.extraData,
    this.redirectUrl,
    this.expireTime,
    this.createdForService,
    this.id,
  });

  factory ShortLink.fromMap(Map<String, dynamic> data) => ShortLink(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        type: data['type'] as String?,
        shortUrl: data['shortUrl'] as String?,
        extraData: data['extraData'] == null
            ? null
            : ExtraData.fromMap(data['extraData'] as Map<String, dynamic>),
        redirectUrl: data['redirectUrl'] as String?,
        expireTime: data['expireTime'] as String?,
        createdForService: data['createdForService'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'type': type,
        'shortUrl': shortUrl,
        'extraData': extraData?.toMap(),
        'redirectUrl': redirectUrl,
        'expireTime': expireTime,
        'createdForService': createdForService,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ShortLink].
  factory ShortLink.fromJson(String data) {
    return ShortLink.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ShortLink] to a JSON string.
  String toJson() => json.encode(toMap());
}
