import 'dart:convert';

class LastMovement {
  String? locationName;
  String? time;
  String? status;
  String? comment;

  LastMovement({this.locationName, this.time, this.status, this.comment});

  @override
  String toString() {
    return 'LastMovement(locationName: $locationName, time: $time, status: $status, comment: $comment)';
  }

  factory LastMovement.fromMap(Map<String, dynamic> data) => LastMovement(
        locationName: data['locationName'] as String?,
        time: data['time'] as String?,
        status: data['status'] as String?,
        comment: data['comment'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'locationName': locationName,
        'time': time,
        'status': status,
        'comment': comment,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LastMovement].
  factory LastMovement.fromJson(String data) {
    return LastMovement.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LastMovement] to a JSON string.
  String toJson() => json.encode(toMap());

  LastMovement copyWith({
    String? locationName,
    String? time,
    String? status,
    String? comment,
  }) {
    return LastMovement(
      locationName: locationName ?? this.locationName,
      time: time ?? this.time,
      status: status ?? this.status,
      comment: comment ?? this.comment,
    );
  }
}
