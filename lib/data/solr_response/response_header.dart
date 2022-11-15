import 'dart:convert';

import 'params.dart';

class ResponseHeader {
  int? status;
  int? qTime;
  Params? params;

  ResponseHeader({this.status, this.qTime, this.params});

  factory ResponseHeader.fromMap(Map<String, dynamic> data) {
    return ResponseHeader(
      status: data['status'] as int?,
      qTime: data['QTime'] as int?,
      params: data['params'] == null
          ? null
          : Params.fromMap(data['params'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'status': status,
        'QTime': qTime,
        'params': params?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ResponseHeader].
  factory ResponseHeader.fromJson(String data) {
    return ResponseHeader.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ResponseHeader] to a JSON string.
  String toJson() => json.encode(toMap());
}
