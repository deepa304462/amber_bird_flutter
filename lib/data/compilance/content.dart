import 'dart:convert';

import 'package:amber_bird/data/deal_product/name.dart';

class Content {
  Name? subHeading;
  List<Name>? content;

  Content({this.subHeading, this.content});

  @override
  String toString() => 'Content(subHeading: $subHeading, content: $content)';

  factory Content.fromMap(Map<String, dynamic> data) => Content(
        subHeading: data['subHeading'] == null
            ? null
            : Name.fromMap(data['subHeading'] as Map<String, dynamic>),
        content: (data['Name'] as List<dynamic>?)
            ?.map((e) => Name.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'subHeading': subHeading?.toMap(),
        'content': content?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Content].
  factory Content.fromJson(String data) {
    return Content.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Content] to a JSON string.
  String toJson() => json.encode(toMap());

  Content copyWith({
    Name? subHeading,
    List<Name>? content,
  }) {
    return Content(
      subHeading: subHeading ?? this.subHeading,
      content: content ?? this.content,
    );
  }
}
