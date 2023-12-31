import 'dart:convert';
import 'package:amber_bird/data/profile/ref.dart';
import 'destination.dart';
import 'last_movement.dart';

class Shipping {
  Destination? source;
  Destination? destination;
  Ref? orderRef;
  String? finalStatus;
  LastMovement? lastMovement;
  String? businessId;
  List<String>? dhlShipmentNumbers;

  Shipping(
      {this.source,
      this.destination,
      this.orderRef,
      this.finalStatus,
      this.lastMovement,
      this.businessId,
      this.dhlShipmentNumbers});

  @override
  String toString() {
    return 'Shipping(source: $source, destination: $destination, orderRef: $orderRef, finalStatus: $finalStatus, lastMovement: $lastMovement, businessId: $businessId,dhlShipmentNumbers:$dhlShipmentNumbers)';
  }

  factory Shipping.fromMap(Map<String, dynamic> data) => Shipping(
        source: data['source'] == null
            ? null
            : Destination.fromMap(data['source'] as Map<String, dynamic>),
        destination: data['destination'] == null
            ? null
            : Destination.fromMap(data['destination'] as Map<String, dynamic>),
        orderRef: data['orderRef'] == null
            ? null
            : Ref.fromMap(data['orderRef'] as Map<String, dynamic>),
        finalStatus: data['finalStatus'] as String?,
        lastMovement: data['lastMovement'] == null
            ? null
            : LastMovement.fromMap(
                data['lastMovement'] as Map<String, dynamic>),
        businessId: data['businessId'] as String?,
        dhlShipmentNumbers: (data['dhlShipmentNumbers'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'source': source?.toMap(),
        'destination': destination?.toMap(),
        'orderRef': orderRef?.toMap(),
        'finalStatus': finalStatus,
        'lastMovement': lastMovement?.toMap(),
        'businessId': businessId,
        'dhlShipmentNumber': dhlShipmentNumbers
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Shipping].
  factory Shipping.fromJson(String data) {
    return Shipping.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Shipping] to a JSON string.
  String toJson() => json.encode(toMap());

  Shipping copyWith(
      {Destination? source,
      Destination? destination,
      Ref? orderRef,
      String? finalStatus,
      LastMovement? lastMovement,
      String? businessId,
      List<String>? dhlShipmentNumbers}) {
    return Shipping(
        source: source ?? this.source,
        destination: destination ?? this.destination,
        orderRef: orderRef ?? this.orderRef,
        finalStatus: finalStatus ?? this.finalStatus,
        lastMovement: lastMovement ?? this.lastMovement,
        businessId: businessId ?? this.businessId,
        dhlShipmentNumbers: dhlShipmentNumbers ?? this.dhlShipmentNumbers);
  }
}
