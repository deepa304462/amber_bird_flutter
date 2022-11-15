import 'dart:convert';

import 'doc.dart';

class Response {
  int? numFound;
  int? start;
  bool? numFoundExact;
  List<Doc>? docs;

  Response({this.numFound, this.start, this.numFoundExact, this.docs});

  factory Response.fromMap(Map<String, dynamic> data) => Response(
        numFound: data['numFound'] as int?,
        start: data['start'] as int?,
        numFoundExact: data['numFoundExact'] as bool?,
        docs: (data['docs'] as List<dynamic>?)
            ?.map((e) => Doc.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'numFound': numFound,
        'start': start,
        'numFoundExact': numFoundExact,
        'docs': docs?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Response].
  factory Response.fromJson(String data) {
    return Response.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Response] to a JSON string.
  String toJson() => json.encode(toMap());
}
