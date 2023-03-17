import 'dart:convert';

import 'location.shipping.dart';

class Event {
  String? timestamp;
  Location? location;
  String? statusCode;
  String? description;

  Event({this.timestamp, this.location, this.statusCode, this.description});

  @override
  String toString() {
    return 'Event(timestamp: $timestamp, location: $location, statusCode: $statusCode, description: $description)';
  }

  factory Event.fromMap(Map<String, dynamic> data) => Event(
        timestamp: data['timestamp'] as String?,
        location: data['location'] == null
            ? null
            : Location.fromMap(data['location'] as Map<String, dynamic>),
        statusCode: data['statusCode'] as String?,
        description: data['description'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'timestamp': timestamp,
        'location': location?.toMap(),
        'statusCode': statusCode,
        'description': description,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Event].
  factory Event.fromJson(String data) {
    return Event.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Event] to a JSON string.
  String toJson() => json.encode(toMap());

  Event copyWith({
    String? timestamp,
    Location? location,
    String? statusCode,
    String? description,
  }) {
    return Event(
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      statusCode: statusCode ?? this.statusCode,
      description: description ?? this.description,
    );
  }
}
