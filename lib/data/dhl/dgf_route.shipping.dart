import 'dart:convert';

import 'dgf_place_of_acceptance.shipping.dart';
import 'dgf_place_of_delivery.shipping.dart';
import 'dgf_port_of_loading.shipping.dart';
import 'dgf_port_of_unloading.shipping.dart';

class DgfRoute {
  DgfPlaceOfAcceptance? dgfPlaceOfAcceptance;
  DgfPortOfLoading? dgfPortOfLoading;
  DgfPortOfUnloading? dgfPortOfUnloading;
  DgfPlaceOfDelivery? dgfPlaceOfDelivery;

  DgfRoute({
    this.dgfPlaceOfAcceptance,
    this.dgfPortOfLoading,
    this.dgfPortOfUnloading,
    this.dgfPlaceOfDelivery,
  });

  @override
  String toString() {
    return 'DgfRoute(dgfPlaceOfAcceptance: $dgfPlaceOfAcceptance, dgfPortOfLoading: $dgfPortOfLoading, dgfPortOfUnloading: $dgfPortOfUnloading, dgfPlaceOfDelivery: $dgfPlaceOfDelivery)';
  }

  factory DgfRoute.fromMap(Map<String, dynamic> data) => DgfRoute(
        dgfPlaceOfAcceptance: data['dgf:placeOfAcceptance'] == null
            ? null
            : DgfPlaceOfAcceptance.fromMap(
                data['dgf:placeOfAcceptance'] as Map<String, dynamic>),
        dgfPortOfLoading: data['dgf:portOfLoading'] == null
            ? null
            : DgfPortOfLoading.fromMap(
                data['dgf:portOfLoading'] as Map<String, dynamic>),
        dgfPortOfUnloading: data['dgf:portOfUnloading'] == null
            ? null
            : DgfPortOfUnloading.fromMap(
                data['dgf:portOfUnloading'] as Map<String, dynamic>),
        dgfPlaceOfDelivery: data['dgf:placeOfDelivery'] == null
            ? null
            : DgfPlaceOfDelivery.fromMap(
                data['dgf:placeOfDelivery'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'dgf:placeOfAcceptance': dgfPlaceOfAcceptance?.toMap(),
        'dgf:portOfLoading': dgfPortOfLoading?.toMap(),
        'dgf:portOfUnloading': dgfPortOfUnloading?.toMap(),
        'dgf:placeOfDelivery': dgfPlaceOfDelivery?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DgfRoute].
  factory DgfRoute.fromJson(String data) {
    return DgfRoute.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DgfRoute] to a JSON string.
  String toJson() => json.encode(toMap());

  DgfRoute copyWith({
    DgfPlaceOfAcceptance? dgfPlaceOfAcceptance,
    DgfPortOfLoading? dgfPortOfLoading,
    DgfPortOfUnloading? dgfPortOfUnloading,
    DgfPlaceOfDelivery? dgfPlaceOfDelivery,
  }) {
    return DgfRoute(
      dgfPlaceOfAcceptance: dgfPlaceOfAcceptance ?? this.dgfPlaceOfAcceptance,
      dgfPortOfLoading: dgfPortOfLoading ?? this.dgfPortOfLoading,
      dgfPortOfUnloading: dgfPortOfUnloading ?? this.dgfPortOfUnloading,
      dgfPlaceOfDelivery: dgfPlaceOfDelivery ?? this.dgfPlaceOfDelivery,
    );
  }
}
