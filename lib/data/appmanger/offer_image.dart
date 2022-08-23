import 'dart:convert';

class OfferImage {
  String? imageId;
  String? link;
  String? altText;

  OfferImage({this.imageId, this.link, this.altText});

  @override
  String toString() {
    return 'OfferImage(imageId: $imageId, link: $link, altText: $altText)';
  }

  factory OfferImage.fromMap(Map<String, dynamic> data) => OfferImage(
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
  /// Parses the string and returns the resulting Json object as [OfferImage].
  factory OfferImage.fromJson(String data) {
    return OfferImage.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OfferImage] to a JSON string.
  String toJson() => json.encode(toMap());

  OfferImage copyWith({
    String? imageId,
    String? link,
    String? altText,
  }) {
    return OfferImage(
      imageId: imageId ?? this.imageId,
      link: link ?? this.link,
      altText: altText ?? this.altText,
    );
  }
}
