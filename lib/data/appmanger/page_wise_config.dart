import 'dart:convert';
import 'package:amber_bird/data/appmanger/intro_image.dart';


class PageWiseConfig {
  String? pageType;
  List<IntroImage>? coverImages;

  PageWiseConfig({this.pageType, this.coverImages});

  @override
  String toString() {
    return 'PageWiseConfig(pageType: $pageType, coverImages: $coverImages)';
  }

  factory PageWiseConfig.fromMap(Map<String, dynamic> data) {
    return PageWiseConfig(
      pageType: data['pageType'] as String?,
      coverImages: (data['coverImages'] as List<dynamic>?)
          ?.map((e) => IntroImage.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'pageType': pageType,
        'coverImages': coverImages?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PageWiseConfig].
  factory PageWiseConfig.fromJson(String data) {
    return PageWiseConfig.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PageWiseConfig] to a JSON string.
  String toJson() => json.encode(toMap());

  PageWiseConfig copyWith({
    String? pageType,
    List<IntroImage>? coverImages,
  }) {
    return PageWiseConfig(
      pageType: pageType ?? this.pageType,
      coverImages: coverImages ?? this.coverImages,
    );
  }
}
