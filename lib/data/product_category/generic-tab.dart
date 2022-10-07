import 'dart:convert';

class GenericTab {
  String? image;
  String? id;
  String? text;
  String? type;

  GenericTab({this.image, this.text, this.id, this.type});

  factory GenericTab.fromMap(Map<String, dynamic> data) => GenericTab(
        id: data['id'] as String?,
        image: data['image'] as String?,
        type: data['type'] as String?,
        text: data['text'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'image': image,
        'type': type,
        'id': id,
        'text': text,
      };

  /// `dart:convert`
  ///
  factory GenericTab.fromJson(String data) {
    return GenericTab.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  String toJson() => json.encode(toMap());
}
