// To parse this JSON data, do
//
//     final sliderItem = sliderItemFromMap(jsonString);

import 'dart:convert';

class SliderItem {
  SliderItem({
    required this.imageUrl,
    required this.desc,
    required this.title,
  });

  String imageUrl;
  String desc;
  String title;

  factory SliderItem.fromJson(String str) =>
      SliderItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SliderItem.fromMap(Map<String, dynamic> json) => SliderItem(
        imageUrl: json["imageUrl"],
        desc: json["desc"],
        title: json["title"],
      );

  Map<String, dynamic> toMap() => {
        "imageUrl": imageUrl,
        "desc": desc,
        "title": title,
      };
}
