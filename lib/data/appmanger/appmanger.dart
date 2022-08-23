import 'dart:convert';

import 'package:amber_bird/data/deal_product/meta_data.dart';

import 'app_intro.dart';
import 'page_wise_config.dart';

class Appmanger {
  MetaData? metaData;
  AppIntro? appIntro;
  PageWiseConfig? pageWiseConfig;
  String? id;

  Appmanger({this.metaData, this.appIntro, this.pageWiseConfig, this.id});

  @override
  String toString() {
    return 'Appmanger(metaData: $metaData, appIntro: $appIntro, pageWiseConfig: $pageWiseConfig, id: $id)';
  }

  factory Appmanger.fromMap(Map<String, dynamic> data) => Appmanger(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        appIntro: data['appIntro'] == null
            ? null
            : AppIntro.fromMap(data['appIntro'] as Map<String, dynamic>),
        pageWiseConfig: data['pageWiseConfig'] == null
            ? null
            : PageWiseConfig.fromMap(
                data['pageWiseConfig'] as Map<String, dynamic>),
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'appIntro': appIntro?.toMap(),
        'pageWiseConfig': pageWiseConfig?.toMap(),
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Appmanger].
  factory Appmanger.fromJson(String data) {
    return Appmanger.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Appmanger] to a JSON string.
  String toJson() => json.encode(toMap());

  Appmanger copyWith({
    MetaData? metaData,
    AppIntro? appIntro,
    PageWiseConfig? pageWiseConfig,
    String? id,
  }) {
    return Appmanger(
      metaData: metaData ?? this.metaData,
      appIntro: appIntro ?? this.appIntro,
      pageWiseConfig: pageWiseConfig ?? this.pageWiseConfig,
      id: id ?? this.id,
    );
  }
}
