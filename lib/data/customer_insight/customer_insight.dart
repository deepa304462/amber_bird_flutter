import 'dart:convert';

import 'package:amber_bird/data/deal_product/meta_data.dart';
import 'package:amber_bird/data/order/address.dart';
import 'package:amber_bird/data/profile/ref.dart';

class CustomerInsight {
  MetaData? metaData;
  String? name;
  List<Address>? addresses;
  String? businessId;
  String? membershipType;
  int? currentPointLevel;
  Ref? customerTrackerRef;
  String? email;
  String? userFriendlyCustomerId;
  dynamic? scoins;
  dynamic? spoints;
  String? id;

  CustomerInsight({
    this.metaData,
    this.name,
    this.addresses,
    this.businessId,
    this.membershipType,
    this.currentPointLevel,
    this.customerTrackerRef,
    this.email,
    this.userFriendlyCustomerId,
    this.scoins,
    this.spoints,
    this.id,
  });

  @override
  String toString() {
    return 'CustomerInsight(metaData: $metaData, name: $name, addresses: $addresses, businessId: $businessId, membershipType: $membershipType, currentPointLevel: $currentPointLevel, customerTrackerRef: $customerTrackerRef, email: $email,userFriendlyCustomerId:$userFriendlyCustomerId,scoins:$scoins,spoints:$spoints, id: $id)';
  }

  factory CustomerInsight.fromMap(Map<String, dynamic> data) {
    return CustomerInsight(
      metaData: data['metaData'] == null
          ? null
          : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
      name: data['name'] as String?,
      addresses: (data['addresses'] as List<dynamic>?)
          ?.map((e) => Address.fromMap(e as Map<String, dynamic>))
          .toList(),
      businessId: data['businessId'] as String?,
      membershipType: data['membershipType'] as String?,
      currentPointLevel: data['currentPointLevel'] as int?,
      customerTrackerRef: data['customerTrackerRef'] == null
          ? null
          : Ref.fromMap(data['customerTrackerRef'] as Map<String, dynamic>),
      email: data['email'] as String?,
      userFriendlyCustomerId: data['userFriendlyCustomerId'] as String?,
      scoins: data['scoins'] as dynamic?,
      spoints: data['spoints'] as dynamic?,
      id: data['_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'name': name,
        'addresses': addresses?.map((e) => e.toMap()).toList(),
        'businessId': businessId,
        'membershipType': membershipType,
        'currentPointLevel': currentPointLevel,
        'customerTrackerRef': customerTrackerRef?.toMap(),
        'email': email,
        'userFriendlyCustomerId': userFriendlyCustomerId,
        'scoins': scoins,
        'spoints': spoints,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CustomerInsight].
  factory CustomerInsight.fromJson(String data) {
    return CustomerInsight.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CustomerInsight] to a JSON string.
  String toJson() => json.encode(toMap());

  CustomerInsight copyWith({
    MetaData? metaData,
    String? name,
    List<Address>? addresses,
    String? businessId,
    String? membershipType,
    int? currentPointLevel,
    Ref? customerTrackerRef,
    String? email,
    String? userFriendlyCustomerId,
    dynamic? scoins,
    dynamic? spoints,
    String? id,
  }) {
    return CustomerInsight(
      metaData: metaData ?? this.metaData,
      name: name ?? this.name,
      addresses: addresses ?? this.addresses,
      businessId: businessId ?? this.businessId,
      membershipType: membershipType ?? this.membershipType,
      currentPointLevel: currentPointLevel ?? this.currentPointLevel,
      customerTrackerRef: customerTrackerRef ?? this.customerTrackerRef,
      email: email ?? this.email,
      userFriendlyCustomerId: userFriendlyCustomerId ?? this.userFriendlyCustomerId,
      scoins: scoins ?? this.scoins,
      spoints: spoints ?? this.spoints,
      id: id ?? this.id,
    );
  }
}
