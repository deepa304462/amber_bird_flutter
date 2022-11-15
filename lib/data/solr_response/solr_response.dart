import 'dart:convert';

import 'response.dart';
import 'response_header.dart';

class SolrResponse {
  ResponseHeader? responseHeader;
  Response? response;

  SolrResponse({this.responseHeader, this.response});

  factory SolrResponse.fromMap(Map<String, dynamic> data) => SolrResponse(
        responseHeader: data['responseHeader'] == null
            ? null
            : ResponseHeader.fromMap(
                data['responseHeader'] as Map<String, dynamic>),
        response: data['response'] == null
            ? null
            : Response.fromMap(data['response'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'responseHeader': responseHeader?.toMap(),
        'response': response?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SolrResponse].
  factory SolrResponse.fromJson(String data) {
    return SolrResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SolrResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}
