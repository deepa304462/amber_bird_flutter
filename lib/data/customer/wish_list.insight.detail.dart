import 'dart:convert';

import 'package:amber_bird/data/deal_product/meta_data.dart';
import 'package:amber_bird/data/profile/ref.dart';

 import 'favorite.insight.detail.dart';
 
class WishList {
  MetaData? metaData;
  Ref? customerRef;
  List<Favorite>? favorites;
  String? id;

  WishList({this.metaData, this.customerRef, this.favorites, this.id});

  @override
  String toString() {
    return 'WishList(metaData: $metaData, customerRef: $customerRef, favorites: $favorites, id: $id)';
  }

  factory WishList.fromMap(Map<String, dynamic> data) => WishList(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        customerRef: data['customerRef'] == null
            ? null
            :  Ref.fromMap(data['customerRef'] as Map<String, dynamic>),
        favorites: (data['favorites'] as List<dynamic>?)
            ?.map((e) => Favorite.fromMap(e as Map<String, dynamic>))
            .toList(),
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'customerRef': customerRef?.toMap(),
        'favorites': favorites?.map((e) => e.toMap()).toList(),
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [WishList].
  factory WishList.fromJson(String data) {
    return WishList.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [WishList] to a JSON string.
  String toJson() => json.encode(toMap());

  WishList copyWith({
    MetaData? metaData,
     Ref? customerRef,
    List<Favorite>? favorites,
    String? id,
  }) {
    return WishList(
      metaData: metaData ?? this.metaData,
      customerRef: customerRef ?? this.customerRef,
      favorites: favorites ?? this.favorites,
      id: id ?? this.id,
    );
  }
}
