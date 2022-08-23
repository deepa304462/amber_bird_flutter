import 'dart:convert';

class IntroImage {
  String? imageId;
  String? link;
  String? altText;

  IntroImage({this.imageId, this.link, this.altText});

  @override
  String toString() {
    return 'IntroImage(imageId: $imageId, link: $link, altText: $altText)';
  }

  factory IntroImage.fromMap(Map<String, dynamic> data) => IntroImage(
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
  /// Parses the string and returns the resulting Json object as [IntroImage].
  factory IntroImage.fromJson(String data) {
    return IntroImage.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [IntroImage] to a JSON string.
  String toJson() => json.encode(toMap());

  IntroImage copyWith({
    String? imageId,
    String? link,
    String? altText,
  }) {
    return IntroImage(
      imageId: imageId ?? this.imageId,
      link: link ?? this.link,
      altText: altText ?? this.altText,
    );
  }
}
