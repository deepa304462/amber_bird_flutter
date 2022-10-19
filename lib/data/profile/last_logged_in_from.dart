import 'dart:convert';

class LastLoggedInFrom {
  String? browserVersion;
  String? operatingSystem;
  String? browserName;
  String? deviceType;
  bool? mobileDevice;
  String? clientUrl;
  String? time;
  String? ipAddress;

  LastLoggedInFrom({
    this.browserVersion,
    this.operatingSystem,
    this.browserName,
    this.deviceType,
    this.mobileDevice,
    this.clientUrl,
    this.time,
    this.ipAddress,
  });

  @override
  String toString() {
    return 'LastLoggedInFrom(browserVersion: $browserVersion, operatingSystem: $operatingSystem, browserName: $browserName, deviceType: $deviceType, mobileDevice: $mobileDevice, clientUrl: $clientUrl, time: $time, ipAddress: $ipAddress)';
  }

  factory LastLoggedInFrom.fromMap(Map<String, dynamic> data) {
    return LastLoggedInFrom(
      browserVersion: data['browserVersion'] as String?,
      operatingSystem: data['operatingSystem'] as String?,
      browserName: data['browserName'] as String?,
      deviceType: data['deviceType'] as String?,
      mobileDevice: data['mobileDevice'] as bool?,
      clientUrl: data['clientUrl'] as String?,
      time: data['time'] as String?,
      ipAddress: data['ipAddress'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'browserVersion': browserVersion,
        'operatingSystem': operatingSystem,
        'browserName': browserName,
        'deviceType': deviceType,
        'mobileDevice': mobileDevice,
        'clientUrl': clientUrl,
        'time': time,
        'ipAddress': ipAddress,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LastLoggedInFrom].
  factory LastLoggedInFrom.fromJson(String data) {
    return LastLoggedInFrom.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LastLoggedInFrom] to a JSON string.
  String toJson() => json.encode(toMap());

  LastLoggedInFrom copyWith({
    String? browserVersion,
    String? operatingSystem,
    String? browserName,
    String? deviceType,
    bool? mobileDevice,
    String? clientUrl,
    String? time,
    String? ipAddress,
  }) {
    return LastLoggedInFrom(
      browserVersion: browserVersion ?? this.browserVersion,
      operatingSystem: operatingSystem ?? this.operatingSystem,
      browserName: browserName ?? this.browserName,
      deviceType: deviceType ?? this.deviceType,
      mobileDevice: mobileDevice ?? this.mobileDevice,
      clientUrl: clientUrl ?? this.clientUrl,
      time: time ?? this.time,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }
}
