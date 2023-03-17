import 'dart:convert';

import 'destination.shipping.dart';
import 'details.shipping.dart';
import 'event.shipping.dart';
import 'origin.shipping.dart';
import 'status.shipping.dart';

class Shipment {
  String? id;
  String? service;
  Origin? origin;
  Destination? destination;
  Status? status;
  String? estimatedTimeOfDelivery;
  Details? details;
  List<Event>? events;

  Shipment({
    this.id,
    this.service,
    this.origin,
    this.destination,
    this.status,
    this.estimatedTimeOfDelivery,
    this.details,
    this.events,
  });

  @override
  String toString() {
    return 'Shipment(id: $id, service: $service, origin: $origin, destination: $destination, status: $status, estimatedTimeOfDelivery: $estimatedTimeOfDelivery, details: $details, events: $events)';
  }

  factory Shipment.fromMap(Map<String, dynamic> data) => Shipment(
        id: data['id'] as String?,
        service: data['service'] as String?,
        origin: data['origin'] == null
            ? null
            : Origin.fromMap(data['origin'] as Map<String, dynamic>),
        destination: data['destination'] == null
            ? null
            : Destination.fromMap(data['destination'] as Map<String, dynamic>),
        status: data['status'] == null
            ? null
            : Status.fromMap(data['status'] as Map<String, dynamic>),
        estimatedTimeOfDelivery: data['estimatedTimeOfDelivery'] as String?,
        details: data['details'] == null
            ? null
            : Details.fromMap(data['details'] as Map<String, dynamic>),
        events: (data['events'] as List<dynamic>?)
            ?.map((e) => Event.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'service': service,
        'origin': origin?.toMap(),
        'destination': destination?.toMap(),
        'status': status?.toMap(),
        'estimatedTimeOfDelivery': estimatedTimeOfDelivery,
        'details': details?.toMap(),
        'events': events?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Shipment].
  factory Shipment.fromJson(String data) {
    return Shipment.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Shipment] to a JSON string.
  String toJson() => json.encode(toMap());

  Shipment copyWith({
    String? id,
    String? service,
    Origin? origin,
    Destination? destination,
    Status? status,
    String? estimatedTimeOfDelivery,
    Details? details,
    List<Event>? events,
  }) {
    return Shipment(
      id: id ?? this.id,
      service: service ?? this.service,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      status: status ?? this.status,
      estimatedTimeOfDelivery:
          estimatedTimeOfDelivery ?? this.estimatedTimeOfDelivery,
      details: details ?? this.details,
      events: events ?? this.events,
    );
  }
}
