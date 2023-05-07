import 'dart:convert';

import 'package:amber_bird/data/deal_product/description.dart';
import 'package:amber_bird/data/deal_product/meta_data.dart';
import 'package:amber_bird/data/deal_product/name.dart';

class Membership {
  MetaData? metaData;
  String? membershipType;
  Name? name;
  Description? description;
  List<String>? benefits;
  String? imageId;
  double? msdProductDiscountPercent;
  double? msdFlatDiscountPercent;
  double? cartValueAboveWhichOfferShippingApplied;
  double? standardShippingCharge;
  double? offerShippingCharge;
  int? spointsRangeMin;
  int? spointsRangeMax;
  String? id;

  Membership({
    this.metaData,
    this.membershipType,
    this.name,
    this.description,
    this.benefits,
    this.imageId,
    this.msdProductDiscountPercent,
    this.msdFlatDiscountPercent,
    this.cartValueAboveWhichOfferShippingApplied,
    this.standardShippingCharge,
    this.offerShippingCharge,
    this.spointsRangeMin,
    this.spointsRangeMax,
    this.id,
  });

  @override
  String toString() {
    return 'Membership(metaData: $metaData, membershipType: $membershipType, name: $name, description: $description, benefits: $benefits, imageId: $imageId, msdProductDiscountPercent: $msdProductDiscountPercent, msdFlatDiscountPercent: $msdFlatDiscountPercent, cartValueAboveWhichOfferShippingApplied: $cartValueAboveWhichOfferShippingApplied, standardShippingCharge: $standardShippingCharge, offerShippingCharge: $offerShippingCharge, spointsRangeMin: $spointsRangeMin, spointsRangeMax: $spointsRangeMax, id: $id)';
  }

  factory Membership.fromMap(Map<String, dynamic> data) => Membership(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        membershipType: data['membershipType'] as String?,
        name: data['name'] == null
            ? null
            : Name.fromMap(data['name'] as Map<String, dynamic>),
        description: data['description'] == null
            ? null
            : Description.fromMap(data['description'] as Map<String, dynamic>),
        benefits: (data['benefits'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        imageId: data['imageId'] as String?,
        msdProductDiscountPercent: data['msdProductDiscountPercent'] as double?,
        msdFlatDiscountPercent: data['msdFlatDiscountPercent'] as double?,
        cartValueAboveWhichOfferShippingApplied:
            data['cartValueAboveWhichOfferShippingApplied'] as double?,
        standardShippingCharge: data['standardShippingCharge'] as double?,
        offerShippingCharge: data['offerShippingCharge'] as double?,
        spointsRangeMin: data['spointsRangeMin'] as int?,
        spointsRangeMax: data['spointsRangeMax'] as int?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'membershipType': membershipType,
        'name': name?.toMap(),
        'description': description?.toMap(),
        'benefits': benefits,
        'imageId': imageId,
        'msdProductDiscountPercent': msdProductDiscountPercent,
        'msdFlatDiscountPercent': msdFlatDiscountPercent,
        'cartValueAboveWhichOfferShippingApplied':
            cartValueAboveWhichOfferShippingApplied,
        'standardShippingCharge': standardShippingCharge,
        'offerShippingCharge': offerShippingCharge,
        'spointsRangeMin': spointsRangeMin,
        'spointsRangeMax': spointsRangeMax,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Membership].
  factory Membership.fromJson(String data) {
    return Membership.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Membership] to a JSON string.
  String toJson() => json.encode(toMap());

  Membership copyWith({
    MetaData? metaData,
    String? membershipType,
    Name? name,
    Description? description,
    List<String>? benefits,
    String? imageId,
    double? msdProductDiscountPercent,
    double? msdFlatDiscountPercent,
    double? cartValueAboveWhichOfferShippingApplied,
    double? standardShippingCharge,
    double? offerShippingCharge,
    int? spointsRangeMin,
    int? spointsRangeMax,
    String? id,
  }) {
    return Membership(
      metaData: metaData ?? this.metaData,
      membershipType: membershipType ?? this.membershipType,
      name: name ?? this.name,
      description: description ?? this.description,
      benefits: benefits ?? this.benefits,
      imageId: imageId ?? this.imageId,
      msdProductDiscountPercent:
          msdProductDiscountPercent ?? this.msdProductDiscountPercent,
      msdFlatDiscountPercent:
          msdFlatDiscountPercent ?? this.msdFlatDiscountPercent,
      cartValueAboveWhichOfferShippingApplied:
          cartValueAboveWhichOfferShippingApplied ??
              this.cartValueAboveWhichOfferShippingApplied,
      standardShippingCharge:
          standardShippingCharge ?? this.standardShippingCharge,
      offerShippingCharge: offerShippingCharge ?? this.offerShippingCharge,
      spointsRangeMin: spointsRangeMin ?? this.spointsRangeMin,
      spointsRangeMax: spointsRangeMax ?? this.spointsRangeMax,
      id: id ?? this.id,
    );
  }
}
