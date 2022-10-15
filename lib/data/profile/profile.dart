import 'dart:convert';

import 'package:amber_bird/data/deal_product/meta_data.dart';

import 'authority.dart';
import 'last_logged_in_from.dart';
import 'ref.dart';

class Profile {
  MetaData? metaData;
  String? password;
  String? username;
  List<Authority>? authorities;
  List<String>? acls;
  bool? accountNonExpired;
  bool? accountNonLocked;
  bool? credentialsNonExpired;
  bool? enabled;
  String? accessType;
  LastLoggedInFrom? lastLoggedInFrom;
  String? serviceName;
  String? authEmail;
  bool? authEmailVerified;
  Ref? orgRef;
  bool? needTfa;
  Ref? mappedTo;
  String? orgShortCode;
  String? parentTokenManager;
  String? mobile;
  bool? mobileVerified;
  String? id;

  Profile({
    this.metaData,
    this.password,
    this.username,
    this.authorities,
    this.acls,
    this.accountNonExpired,
    this.accountNonLocked,
    this.credentialsNonExpired,
    this.enabled,
    this.accessType,
    this.lastLoggedInFrom,
    this.serviceName,
    this.authEmail,
    this.authEmailVerified,
    this.orgRef,
    this.needTfa,
    this.mappedTo,
    this.orgShortCode,
    this.parentTokenManager,
    this.mobile,
    this.mobileVerified,
    this.id,
  });

  @override
  String toString() {
    return 'Profile(metaData: $metaData, password: $password, username: $username, authorities: $authorities, acls: $acls, accountNonExpired: $accountNonExpired, accountNonLocked: $accountNonLocked, credentialsNonExpired: $credentialsNonExpired, enabled: $enabled, accessType: $accessType, lastLoggedInFrom: $lastLoggedInFrom, serviceName: $serviceName, authEmail: $authEmail, authEmailVerified: $authEmailVerified, orgRef: $orgRef, needTfa: $needTfa, mappedTo: $mappedTo, orgShortCode: $orgShortCode, parentTokenManager: $parentTokenManager, mobile: $mobile, mobileVerified: $mobileVerified, id: $id)';
  }

  factory Profile.fromMap(Map<String, dynamic> data) => Profile(
        metaData: data['metaData'] == null
            ? null
            : MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
        password: data['password'] as String?,
        username: data['username'] as String?,
        authorities: (data['authorities'] as List<dynamic>?)
            ?.map((e) => Authority.fromMap(e as Map<String, dynamic>))
            .toList(),
        acls: data['acls'] as List<String>?,
        accountNonExpired: data['accountNonExpired'] as bool?,
        accountNonLocked: data['accountNonLocked'] as bool?,
        credentialsNonExpired: data['credentialsNonExpired'] as bool?,
        enabled: data['enabled'] as bool?,
        accessType: data['accessType'] as String?,
        lastLoggedInFrom: data['lastLoggedInFrom'] == null
            ? null
            : LastLoggedInFrom.fromMap(
                data['lastLoggedInFrom'] as Map<String, dynamic>),
        serviceName: data['serviceName'] as String?,
        authEmail: data['authEmail'] as String?,
        authEmailVerified: data['authEmailVerified'] as bool?,
        orgRef: data['orgRef'] == null
            ? null
            : Ref.fromMap(data['orgRef'] as Map<String, dynamic>),
        needTfa: data['needTfa'] as bool?,
        mappedTo: data['mappedTo'] == null
            ? null
            : Ref.fromMap(data['mappedTo'] as Map<String, dynamic>),
        orgShortCode: data['orgShortCode'] as String?,
        parentTokenManager: data['parentTokenManager'] as String?,
        mobile: data['mobile'] as String?,
        mobileVerified: data['mobileVerified'] as bool?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'metaData': metaData?.toMap(),
        'password': password,
        'username': username,
        'authorities': authorities?.map((e) => e.toMap()).toList(),
        'acls': acls,
        'accountNonExpired': accountNonExpired,
        'accountNonLocked': accountNonLocked,
        'credentialsNonExpired': credentialsNonExpired,
        'enabled': enabled,
        'accessType': accessType,
        'lastLoggedInFrom': lastLoggedInFrom?.toMap(),
        'serviceName': serviceName,
        'authEmail': authEmail,
        'authEmailVerified': authEmailVerified,
        'orgRef': orgRef?.toMap(),
        'needTfa': needTfa,
        'mappedTo': mappedTo?.toMap(),
        'orgShortCode': orgShortCode,
        'parentTokenManager': parentTokenManager,
        'mobile': mobile,
        'mobileVerified': mobileVerified,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Profile].
  factory Profile.fromJson(String data) {
    return Profile.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Profile] to a JSON string.
  String toJson() => json.encode(toMap());

  Profile copyWith({
    MetaData? metaData,
    String? password,
    String? username,
    List<Authority>? authorities,
    List<String>? acls,
    bool? accountNonExpired,
    bool? accountNonLocked,
    bool? credentialsNonExpired,
    bool? enabled,
    String? accessType,
    LastLoggedInFrom? lastLoggedInFrom,
    String? serviceName,
    String? authEmail,
    bool? authEmailVerified,
    Ref? orgRef,
    bool? needTfa,
    Ref? mappedTo,
    String? orgShortCode,
    String? parentTokenManager,
    String? mobile,
    bool? mobileVerified,
    String? id,
  }) {
    return Profile(
      metaData: metaData ?? this.metaData,
      password: password ?? this.password,
      username: username ?? this.username,
      authorities: authorities ?? this.authorities,
      acls: acls ?? this.acls,
      accountNonExpired: accountNonExpired ?? this.accountNonExpired,
      accountNonLocked: accountNonLocked ?? this.accountNonLocked,
      credentialsNonExpired:
          credentialsNonExpired ?? this.credentialsNonExpired,
      enabled: enabled ?? this.enabled,
      accessType: accessType ?? this.accessType,
      lastLoggedInFrom: lastLoggedInFrom ?? this.lastLoggedInFrom,
      serviceName: serviceName ?? this.serviceName,
      authEmail: authEmail ?? this.authEmail,
      authEmailVerified: authEmailVerified ?? this.authEmailVerified,
      orgRef: orgRef ?? this.orgRef,
      needTfa: needTfa ?? this.needTfa,
      mappedTo: mappedTo ?? this.mappedTo,
      orgShortCode: orgShortCode ?? this.orgShortCode,
      parentTokenManager: parentTokenManager ?? this.parentTokenManager,
      mobile: mobile ?? this.mobile,
      mobileVerified: mobileVerified ?? this.mobileVerified,
      id: id ?? this.id,
    );
  }
}
