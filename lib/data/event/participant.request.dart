import 'dart:convert';

import 'member_profile_ref.request.dart';

class Participant {
  MemberProfileRef? memberProfileRef;
  String? attendanceId;
  String? joinTime;
  String? leftTime;

  Participant({
    this.memberProfileRef,
    this.attendanceId,
    this.joinTime,
    this.leftTime,
  });

  @override
  String toString() {
    return 'Participant(memberProfileRef: $memberProfileRef, attendanceId: $attendanceId, joinTime: $joinTime, leftTime: $leftTime)';
  }

  factory Participant.fromMap(Map<String, dynamic> data) => Participant(
        memberProfileRef: data['memberProfileRef'] == null
            ? null
            : MemberProfileRef.fromMap(
                data['memberProfileRef'] as Map<String, dynamic>),
        attendanceId: data['attendanceId'] as String?,
        joinTime: data['joinTime'] as String?,
        leftTime: data['leftTime'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'memberProfileRef': memberProfileRef?.toMap(),
        'attendanceId': attendanceId,
        'joinTime': joinTime,
        'leftTime': leftTime,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Participant].
  factory Participant.fromJson(String data) {
    return Participant.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Participant] to a JSON string.
  String toJson() => json.encode(toMap());

  Participant copyWith({
    MemberProfileRef? memberProfileRef,
    String? attendanceId,
    String? joinTime,
    String? leftTime,
  }) {
    return Participant(
      memberProfileRef: memberProfileRef ?? this.memberProfileRef,
      attendanceId: attendanceId ?? this.attendanceId,
      joinTime: joinTime ?? this.joinTime,
      leftTime: leftTime ?? this.leftTime,
    );
  }
}
