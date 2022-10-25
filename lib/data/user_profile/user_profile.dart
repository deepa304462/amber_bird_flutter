import 'dart:convert';

import 'package:amber_bird/data/deal_product/meta_data.dart';
import 'package:amber_bird/data/profile/ref.dart';

import 'notification_setting.dart';
import 'social_media_o_auth.dart';

class UserProfile {
  MetaData? metaData;
  String? email;
  String? fullName;
  String? mobile;
  Ref? thirdPartyRef;
  String? type;
  String? extraData;
  String? deviceId;
  String? userName;
  String? profileIcon;
  NotificationSetting? notificationSetting;
  List<SocialMediaOAuth>? socialMediaOAuths;
  String? id;

  UserProfile({
    this.metaData,
    this.email,
    this.fullName,
    this.mobile,
    this.thirdPartyRef,
    this.type,
    this.extraData,
    this.deviceId,
    this.userName,
    this.profileIcon,
    this.notificationSetting,
    this.socialMediaOAuths,
    this.id,
  });

  factory UserProfile.fromMap(Map<String, dynamic> data) => UserProfile(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        email: data['email'] as String?,
        fullName: data['fullName'] as String?,
        mobile: data['mobile'] as String?,
        thirdPartyRef: data['thirdPartyRef'] == null
            ? null
            : Ref.fromMap(data['thirdPartyRef'] as Map<String, dynamic>),
        type: data['type'] as String?,
        extraData: data['extraData'] as String?,
        deviceId: data['deviceId'] as String?,
        userName: data['userName'] as String?,
        profileIcon: data['profileIcon'] as String?,
        notificationSetting: data['notificationSetting'] == null
            ? null
            : NotificationSetting.fromMap(
                data['notificationSetting'] as Map<String, dynamic>),
        socialMediaOAuths: (data['socialMediaOAuths'] as List<dynamic>?)
            ?.map((e) => SocialMediaOAuth.fromMap(e as Map<String, dynamic>))
            .toList(),
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'email': email,
        'fullName': fullName,
        'mobile': mobile,
        'thirdPartyRef': thirdPartyRef?.toMap(),
        'type': type,
        'extraData': extraData,
        'deviceId': deviceId,
        'userName': userName,
        'profileIcon': profileIcon,
        'notificationSetting': notificationSetting?.toMap(),
        'socialMediaOAuths': socialMediaOAuths?.map((e) => e.toMap()).toList(),
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserProfile].
  factory UserProfile.fromJson(String data) {
    return UserProfile.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserProfile] to a JSON string.
  String toJson() => json.encode(toMap());
}
