import 'dart:convert';

class MarketingInfo {
  String? socialMediaImage;
  String? socialMediaTitle;
  String? socialMediaDescription;

  MarketingInfo({
    this.socialMediaImage,
    this.socialMediaTitle,
    this.socialMediaDescription,
  });

  @override
  String toString() {
    return 'MarketingInfo(socialMediaImage: $socialMediaImage, socialMediaTitle: $socialMediaTitle, socialMediaDescription: $socialMediaDescription)';
  }

  factory MarketingInfo.fromMap(Map<String, dynamic> data) => MarketingInfo(
        socialMediaImage: data['socialMediaImage'] as String?,
        socialMediaTitle: data['socialMediaTitle'] as String?,
        socialMediaDescription: data['socialMediaDescription'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'socialMediaImage': socialMediaImage,
        'socialMediaTitle': socialMediaTitle,
        'socialMediaDescription': socialMediaDescription,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MarketingInfo].
  factory MarketingInfo.fromJson(String data) {
    return MarketingInfo.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MarketingInfo] to a JSON string.
  String toJson() => json.encode(toMap());

  MarketingInfo copyWith({
    String? socialMediaImage,
    String? socialMediaTitle,
    String? socialMediaDescription,
  }) {
    return MarketingInfo(
      socialMediaImage: socialMediaImage ?? this.socialMediaImage,
      socialMediaTitle: socialMediaTitle ?? this.socialMediaTitle,
      socialMediaDescription:
          socialMediaDescription ?? this.socialMediaDescription,
    );
  }
}
