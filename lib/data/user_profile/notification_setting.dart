import 'dart:convert';

class NotificationSetting {
  String? userHasDevice;
  List<String>? platform;

  NotificationSetting({this.userHasDevice, this.platform});

  factory NotificationSetting.fromMap(Map<String, dynamic> data) {
    return NotificationSetting(
      userHasDevice: data['userHasDevice'] as String?,
      platform: data['platform'] as List<String>?,
    );
  }

  Map<String, dynamic> toMap() => {
        'userHasDevice': userHasDevice,
        'platform': platform,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [NotificationSetting].
  factory NotificationSetting.fromJson(String data) {
    return NotificationSetting.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [NotificationSetting] to a JSON string.
  String toJson() => json.encode(toMap());
}
