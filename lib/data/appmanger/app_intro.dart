import 'dart:convert';

import 'intro_image.dart';
import 'offer_image.dart';

class AppIntro {
  List<OfferImage>? offerImages;
  List<IntroImage>? introImages;
  String? businessId;

  AppIntro({this.offerImages, this.introImages, this.businessId});

  @override
  String toString() {
    return 'AppIntro(offerImages: $offerImages, introImages: $introImages, businessId: $businessId)';
  }

  factory AppIntro.fromMap(Map<String, dynamic> data) => AppIntro(
        offerImages: (data['offerImages'] as List<dynamic>?)
            ?.map((e) => OfferImage.fromMap(e as Map<String, dynamic>))
            .toList(),
        introImages: (data['introImages'] as List<dynamic>?)
            ?.map((e) => IntroImage.fromMap(e as Map<String, dynamic>))
            .toList(),
        businessId: data['businessId'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'offerImages': offerImages?.map((e) => e.toMap()).toList(),
        'introImages': introImages?.map((e) => e.toMap()).toList(),
        'businessId': businessId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AppIntro].
  factory AppIntro.fromJson(String data) {
    return AppIntro.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AppIntro] to a JSON string.
  String toJson() => json.encode(toMap());

  AppIntro copyWith({
    List<OfferImage>? offerImages,
    List<IntroImage>? introImages,
    String? businessId,
  }) {
    return AppIntro(
      offerImages: offerImages ?? this.offerImages,
      introImages: introImages ?? this.introImages,
      businessId: businessId ?? this.businessId,
    );
  }
}
