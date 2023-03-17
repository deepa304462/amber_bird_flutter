import 'dart:convert';

import 'location.shipping.dart';

class Status {
  String? timestamp;
  Location? location;
  String? statusCode;
  String? description;

  Status({
    this.timestamp,
    this.location,
    this.statusCode,
    this.description,
  });

  @override
  String toString() {
    return 'Status(timestamp: $timestamp, location: $location, statusCode: $statusCode, description: $description)';
  }

  factory Status.fromMap(Map<String, dynamic> data) => Status(
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
  /// Parses the string and returns the resulting Json object as [Status].
  factory Status.fromJson(String data) {
    return Status.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Status] to a JSON string.
  String toJson() => json.encode(toMap());

  Status copyWith({
    String? timestamp,
    Location? location,
    String? statusCode,
    String? description,
  }) {
    return Status(
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      statusCode: statusCode ?? this.statusCode,
      description: description ?? this.description,
    );
  }
}
