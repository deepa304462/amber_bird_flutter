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
    this.spointsRangeMin,
    this.spointsRangeMax,
    this.id,
  });

  @override
  String toString() {
    return 'Membership(metaData: $metaData, membershipType: $membershipType, name: $name, description: $description, benefits: $benefits, imageId: $imageId, spointsRangeMin: $spointsRangeMin, spointsRangeMax: $spointsRangeMax, id: $id)';
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
        benefits: data['benefits'] as List<String>?,
        imageId: data['imageId'] as String?,
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
      spointsRangeMin: spointsRangeMin ?? this.spointsRangeMin,
      spointsRangeMax: spointsRangeMax ?? this.spointsRangeMax,
      id: id ?? this.id,
    );
  }
}
