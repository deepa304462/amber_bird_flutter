import 'dart:convert';

 import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/meta_data.dart';
import 'package:amber_bird/data/deal_product/name.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/product.dart';

class Multi {
  MetaData? metaData;
  Name? name;
  List<ProductSummary>? products;
  String? displayImageId;
  Price? price;
  bool? active;
  String? type;
  dynamic businessId;
  Constraint? constraint;
  String? id;

  Multi({
    this.metaData,
    this.name,
    this.products,
    this.displayImageId,
    this.price,
    this.active,
    this.type,
    this.businessId,
    this.constraint,
    this.id,
  });

  @override
  String toString() {
    return 'Multi(metaData: $metaData, name: $name, products: $products, displayImageId: $displayImageId, price: $price, active: $active, type: $type, businessId: $businessId, constraint: $constraint, id: $id)';
  }

  factory Multi.fromMap(Map<String, dynamic> data) => Multi(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        name: data['name'] == null
            ? null
            : Name.fromMap(data['name'] as Map<String, dynamic>),
        products: (data['products'] as List<dynamic>?)
            ?.map((e) => ProductSummary.fromMap(e as Map<String, dynamic>))
            .toList(),
        displayImageId: data['displayImageId'] as String?,
        price: data['price'] == null
            ? null
            : Price.fromMap(data['price'] as Map<String, dynamic>),
        active: data['active'] as bool?,
        type: data['type'] as String?,
        businessId: data['businessId'] as dynamic,
        constraint: data['constraint'] == null
            ? null
            : Constraint.fromMap(data['constraint'] as Map<String, dynamic>),
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'name': name?.toMap(),
        'products': products?.map((e) => e.toMap()).toList(),
        'displayImageId': displayImageId,
        'price': price?.toMap(),
        'active': active,
        'type': type,
        'businessId': businessId,
        'constraint': constraint,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Multi].
  factory Multi.fromJson(String data) {
    return Multi.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Multi] to a JSON string.
  String toJson() => json.encode(toMap());

  Multi copyWith({
    MetaData? metaData,
    Name? name,
    List<ProductSummary>? products,
    String? displayImageId,
    Price? price,
    bool? active,
    String? type,
    dynamic businessId,
    Constraint? constraint,
    String? id,
  }) {
    return Multi(
      metaData: metaData ?? this.metaData,
      name: name ?? this.name,
      products: products ?? this.products,
      displayImageId: displayImageId ?? this.displayImageId,
      price: price ?? this.price,
      active: active ?? this.active,
      type: type ?? this.type,
      businessId: businessId ?? this.businessId,
      constraint: constraint ?? this.constraint,
      id: id ?? this.id,
    );
  }
}
