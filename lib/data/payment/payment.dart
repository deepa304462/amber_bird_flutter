import 'dart:convert';
 
import 'package:amber_bird/data/deal_product/meta_data.dart';

import 'amount.dart'; 
import 'application_fee.dart';
import 'details.dart';
import 'embedded.dart';
import 'links.dart'; 

class Payment {
  String? resource;
  String? id;
  String? mode;
  dynamic? createdAt;
  String? status;
  dynamic? authorizedAt;
  dynamic? paidAt;
  dynamic? canceledAt;
  dynamic? expiresAt;
  dynamic? expiredAt;
  dynamic? failedAt;
  Amount? amount;
  Amount? amountRefunded;
  Amount? amountRemaining;
  Amount? amountCaptured;
  String? description;
  String? redirectUrl;
  String? webhookUrl;
  String? method;
  MetaData? metadata;
  String? locale;
  String? countryCode;
  String? profileId;
  Amount? settlementAmount;
  String? settlementId;
  String? customerId;
  String? sequenceType;
  String? mandateId;
  String? subscriptionId;
  String? orderId;
  ApplicationFee? applicationFee;
  Details? details;
  bool? cancelable;
  Links? links;
  Embedded? embedded;

  Payment({
    this.resource,
    this.id,
    this.mode,
    this.createdAt,
    this.status,
    this.authorizedAt,
    this.paidAt,
    this.canceledAt,
    this.expiresAt,
    this.expiredAt,
    this.failedAt,
    this.amount,
    this.amountRefunded,
    this.amountRemaining,
    this.amountCaptured,
    this.description,
    this.redirectUrl,
    this.webhookUrl,
    this.method,
    this.metadata,
    this.locale,
    this.countryCode,
    this.profileId,
    this.settlementAmount,
    this.settlementId,
    this.customerId,
    this.sequenceType,
    this.mandateId,
    this.subscriptionId,
    this.orderId,
    this.applicationFee,
    this.details,
    this.cancelable,
    this.links,
    this.embedded,
  });

  @override
  String toString() {
    return 'Paymnet(resource: $resource, id: $id, mode: $mode, createdAt: $createdAt, status: $status, authorizedAt: $authorizedAt, paidAt: $paidAt, canceledAt: $canceledAt, expiresAt: $expiresAt, expiredAt: $expiredAt, failedAt: $failedAt, amount: $amount, amountRefunded: $amountRefunded, amountRemaining: $amountRemaining, amountCaptured: $amountCaptured, description: $description, redirectUrl: $redirectUrl, webhookUrl: $webhookUrl, method: $method, metadata: $metadata, locale: $locale, countryCode: $countryCode, profileId: $profileId, settlementAmount: $settlementAmount, settlementId: $settlementId, customerId: $customerId, sequenceType: $sequenceType, mandateId: $mandateId, subscriptionId: $subscriptionId, orderId: $orderId, applicationFee: $applicationFee, details: $details, cancelable: $cancelable, links: $links, embedded: $embedded)';
  }

  factory Payment.fromMap(Map<String, dynamic> data) => Payment(
        resource: data['resource'] as String?,
        id: data['id'] as String?,
        mode: data['mode'] as String?,
        createdAt: data['createdAt'] == null
            ? null
            : (data['createdAt'] as dynamic),
        status: data['status'] as String?,
        authorizedAt: data['authorizedAt'] == null
            ? null
            :  (data['authorizedAt'] as dynamic),
        paidAt: data['paidAt'] == null
            ? null
            :  (data['paidAt'] as dynamic),
        canceledAt: data['canceledAt'] == null
            ? null
            :  (data['canceledAt'] as dynamic),
        expiresAt: data['expiresAt'] == null
            ? null
            :  (data['expiresAt'] as dynamic),
        expiredAt: data['expiredAt'] == null
            ? null
            :  (data['expiredAt'] as dynamic),
        failedAt: data['failedAt'] == null
            ? null
            :  (data['failedAt'] as dynamic),
        amount: data['amount'] == null
            ? null
            : Amount.fromMap(data['amount'] as Map<String, dynamic>),
        amountRefunded: data['amountRefunded'] == null
            ? null
            : Amount.fromMap(
                data['amountRefunded'] as Map<String, dynamic>),
        amountRemaining: data['amountRemaining'] == null
            ? null
            : Amount.fromMap(
                data['amountRemaining'] as Map<String, dynamic>),
        amountCaptured: data['amountCaptured'] == null
            ? null
            : Amount.fromMap(
                data['amountCaptured'] as Map<String, dynamic>),
        description: data['description'] as String?,
        redirectUrl: data['redirectUrl'] as String?,
        webhookUrl: data['webhookUrl'] as String?,
        method: data['method'] as String?,
        metadata: data['metadata'] == null
            ? null
            : MetaData.fromMap(data['metadata'] as Map<String, dynamic>),
        locale: data['locale'] as String?,
        countryCode: data['countryCode'] as String?,
        profileId: data['profileId'] as String?,
        settlementAmount: data['settlementAmount'] == null
            ? null
            : Amount.fromMap(
                data['settlementAmount'] as Map<String, dynamic>),
        settlementId: data['settlementId'] as String?,
        customerId: data['customerId'] as String?,
        sequenceType: data['sequenceType'] as String?,
        mandateId: data['mandateId'] as String?,
        subscriptionId: data['subscriptionId'] as String?,
        orderId: data['orderId'] as String?,
        applicationFee: data['applicationFee'] == null
            ? null
            : ApplicationFee.fromMap(
                data['applicationFee'] as Map<String, dynamic>),
        details: data['details'] == null
            ? null
            : Details.fromMap(data['details'] as Map<String, dynamic>),
        cancelable: data['cancelable'] as bool?,
        links: data['_links'] == null
            ? null
            : Links.fromMap(data['_links'] as Map<String, dynamic>),
        embedded: data['_embedded'] == null
            ? null
            : Embedded.fromMap(data['_embedded'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'resource': resource,
        'id': id,
        'mode': mode,
        'createdAt': createdAt?.toIso8601String(),
        'status': status,
        'authorizedAt': authorizedAt?.toIso8601String(),
        'paidAt': paidAt?.toIso8601String(),
        'canceledAt': canceledAt?.toIso8601String(),
        'expiresAt': expiresAt?.toIso8601String(),
        'expiredAt': expiredAt?.toIso8601String(),
        'failedAt': failedAt?.toIso8601String(),
        'amount': amount?.toMap(),
        'amountRefunded': amountRefunded?.toMap(),
        'amountRemaining': amountRemaining?.toMap(),
        'amountCaptured': amountCaptured?.toMap(),
        'description': description,
        'redirectUrl': redirectUrl,
        'webhookUrl': webhookUrl,
        'method': method,
        'metadata': metadata?.toMap(),
        'locale': locale,
        'countryCode': countryCode,
        'profileId': profileId,
        'settlementAmount': settlementAmount?.toMap(),
        'settlementId': settlementId,
        'customerId': customerId,
        'sequenceType': sequenceType,
        'mandateId': mandateId,
        'subscriptionId': subscriptionId,
        'orderId': orderId,
        'applicationFee': applicationFee?.toMap(),
        'details': details?.toMap(),
        'cancelable': cancelable,
        '_links': links?.toMap(),
        '_embedded': embedded?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Payment].
  factory Payment.fromJson(String data) {
    return Payment.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Payment] to a JSON string.
  String toJson() => json.encode(toMap());

  Payment copyWith({
    String? resource,
    String? id,
    String? mode,
    dynamic? createdAt,
    String? status,
    dynamic? authorizedAt,
    dynamic? paidAt,
    dynamic? canceledAt,
    dynamic? expiresAt,
    dynamic? expiredAt,
    dynamic? failedAt,
    Amount? amount,
    Amount? amountRefunded,
    Amount? amountRemaining,
    Amount? amountCaptured,
    String? description,
    String? redirectUrl,
    String? webhookUrl,
    String? method,
    MetaData? metadata,
    String? locale,
    String? countryCode,
    String? profileId,
    Amount? settlementAmount,
    String? settlementId,
    String? customerId,
    String? sequenceType,
    String? mandateId,
    String? subscriptionId,
    String? orderId,
    ApplicationFee? applicationFee,
    Details? details,
    bool? cancelable,
    Links? links,
    Embedded? embedded,
  }) {
    return Payment(
      resource: resource ?? this.resource,
      id: id ?? this.id,
      mode: mode ?? this.mode,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      authorizedAt: authorizedAt ?? this.authorizedAt,
      paidAt: paidAt ?? this.paidAt,
      canceledAt: canceledAt ?? this.canceledAt,
      expiresAt: expiresAt ?? this.expiresAt,
      expiredAt: expiredAt ?? this.expiredAt,
      failedAt: failedAt ?? this.failedAt,
      amount: amount ?? this.amount,
      amountRefunded: amountRefunded ?? this.amountRefunded,
      amountRemaining: amountRemaining ?? this.amountRemaining,
      amountCaptured: amountCaptured ?? this.amountCaptured,
      description: description ?? this.description,
      redirectUrl: redirectUrl ?? this.redirectUrl,
      webhookUrl: webhookUrl ?? this.webhookUrl,
      method: method ?? this.method,
      metadata: metadata ?? this.metadata,
      locale: locale ?? this.locale,
      countryCode: countryCode ?? this.countryCode,
      profileId: profileId ?? this.profileId,
      settlementAmount: settlementAmount ?? this.settlementAmount,
      settlementId: settlementId ?? this.settlementId,
      customerId: customerId ?? this.customerId,
      sequenceType: sequenceType ?? this.sequenceType,
      mandateId: mandateId ?? this.mandateId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      orderId: orderId ?? this.orderId,
      applicationFee: applicationFee ?? this.applicationFee,
      details: details ?? this.details,
      cancelable: cancelable ?? this.cancelable,
      links: links ?? this.links,
      embedded: embedded ?? this.embedded,
    );
  }
}
