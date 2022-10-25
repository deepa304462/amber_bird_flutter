import 'dart:convert';

class SocialMediaOAuth {
  String? type;
  String? socialMediaId;
  String? imageFromSocialMedia;
  String? verifiedAccountId;
  String? username;
  String? socialMediaName;
  String? socialMediaAvatar;

  SocialMediaOAuth({
    this.type,
    this.socialMediaId,
    this.imageFromSocialMedia,
    this.verifiedAccountId,
    this.username,
    this.socialMediaName,
    this.socialMediaAvatar,
  });

  factory SocialMediaOAuth.fromMap(Map<String, dynamic> data) {
    return SocialMediaOAuth(
      type: data['type'] as String?,
      socialMediaId: data['socialMediaId'] as String?,
      imageFromSocialMedia: data['imageFromSocialMedia'] as String?,
      verifiedAccountId: data['verifiedAccountId'] as String?,
      username: data['username'] as String?,
      socialMediaName: data['socialMediaName'] as String?,
      socialMediaAvatar: data['socialMediaAvatar'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'type': type,
        'socialMediaId': socialMediaId,
        'imageFromSocialMedia': imageFromSocialMedia,
        'verifiedAccountId': verifiedAccountId,
        'username': username,
        'socialMediaName': socialMediaName,
        'socialMediaAvatar': socialMediaAvatar,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SocialMediaOAuth].
  factory SocialMediaOAuth.fromJson(String data) {
    return SocialMediaOAuth.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SocialMediaOAuth] to a JSON string.
  String toJson() => json.encode(toMap());
}
