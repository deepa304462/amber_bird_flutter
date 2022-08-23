import 'dart:convert';

class CoverImage {
  String? imageId;
  String? link;
  String? altText;

  CoverImage({this.imageId, this.link, this.altText});

  @override
  String toString() {
    return 'CoverImage(imageId: $imageId, link: $link, altText: $altText)';
  }

  factory CoverImage.fromMap(Map<String, dynamic> data) => CoverImage(
        imageId: data['imageId'] as String?,
        link: data['link'] as String?,
        altText: data['altText'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'imageId': imageId,
        'link': link,
        'altText': altText,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CoverImage].
  factory CoverImage.fromJson(String data) {
    return CoverImage.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CoverImage] to a JSON string.
  String toJson() => json.encode(toMap());

  CoverImage copyWith({
    String? imageId,
    String? link,
    String? altText,
  }) {
    return CoverImage(
      imageId: imageId ?? this.imageId,
      link: link ?? this.link,
      altText: altText ?? this.altText,
    );
  }
}
