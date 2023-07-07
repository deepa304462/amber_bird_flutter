import 'dart:convert';

import 'package:amber_bird/data/deal_product/description.dart';

import 'content.dart';

class DetailedContent {
  Description? sectionHeading;
  List<Content>? content;

  DetailedContent({this.sectionHeading, this.content});

  @override
  String toString() {
    return 'DetailedContent(sectionHeading: $sectionHeading, content: $content)';
  }

  factory DetailedContent.fromMap(Map<String, dynamic> data) {
    return DetailedContent(
      sectionHeading: data['sectionHeading'] == null
          ? null
          : Description.fromMap(data['sectionHeading'] as Map<String, dynamic>),
      content: (data['content'] as List<dynamic>?)
          ?.map((e) => Content.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'sectionHeading': sectionHeading?.toMap(),
        'content': content?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DetailedContent].
  factory DetailedContent.fromJson(String data) {
    return DetailedContent.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DetailedContent] to a JSON string.
  String toJson() => json.encode(toMap());

  DetailedContent copyWith({
    Description? sectionHeading,
    List<Content>? content,
  }) {
    return DetailedContent(
      sectionHeading: sectionHeading ?? this.sectionHeading,
      content: content ?? this.content,
    );
  }
}
