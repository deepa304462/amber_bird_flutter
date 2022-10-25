import 'dart:convert';

import 'package:amber_bird/data/deal_product/meta_data.dart';

import 'amount.dart';
import 'embedded.dart';
import 'line.dart';
import 'links.dart';

class Refund {
  String? resource;
  String? id;
  Amount? amount;
  String? settlementId;
  Amount? settlementAmount;
  String? description;
  MetaData? metadata;
  String? status;
  List<Line>? lines;
  String? paymentId;
  String? orderId;
  DateTime? createdAt;
  Embedded? embedded;
  Links? links;

  Refund({
    this.resource,
    this.id,
    this.amount,
    this.settlementId,
    this.settlementAmount,
    this.description,
    this.metadata,
    this.status,
    this.lines,
    this.paymentId,
    this.orderId,
    this.createdAt,
    this.embedded,
    this.links,
  });

  @override
  String toString() {
    return 'Refund(resource: $resource, id: $id, amount: $amount, settlementId: $settlementId, settlementAmount: $settlementAmount, description: $description, metadata: $metadata, status: $status, lines: $lines, paymentId: $paymentId, orderId: $orderId, createdAt: $createdAt, embedded: $embedded, links: $links)';
  }

  factory Refund.fromMap(Map<String, dynamic> data) => Refund(
        resource: data['resource'] as String?,
        id: data['id'] as String?,
        amount: data['amount'] == null
            ? null
            : Amount.fromMap(data['amount'] as Map<String, dynamic>),
        settlementId: data['settlementId'] as String?,
        settlementAmount: data['settlementAmount'] == null
            ? null
            : Amount.fromMap(data['settlementAmount'] as Map<String, dynamic>),
        description: data['description'] as String?,
        metadata: data['metadata'] == null
            ? null
            : MetaData.fromMap(data['metadata'] as Map<String, dynamic>),
        status: data['status'] as String?,
        lines: (data['lines'] as List<dynamic>?)
            ?.map((e) => Line.fromMap(e as Map<String, dynamic>))
            .toList(),
        paymentId: data['paymentId'] as String?,
        orderId: data['orderId'] as String?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        embedded: data['_embedded'] == null
            ? null
            : Embedded.fromMap(data['_embedded'] as Map<String, dynamic>),
        links: data['_links'] == null
            ? null
            : Links.fromMap(data['_links'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'resource': resource,
        'id': id,
        'amount': amount?.toMap(),
        'settlementId': settlementId,
        'settlementAmount': settlementAmount?.toMap(),
        'description': description,
        'metadata': metadata?.toMap(),
        'status': status,
        'lines': lines?.map((e) => e.toMap()).toList(),
        'paymentId': paymentId,
        'orderId': orderId,
        'createdAt': createdAt?.toIso8601String(),
        '_embedded': embedded?.toMap(),
        '_links': links?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Refund].
  factory Refund.fromJson(String data) {
    return Refund.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Refund] to a JSON string.
  String toJson() => json.encode(toMap());

  Refund copyWith({
    String? resource,
    String? id,
    Amount? amount,
    String? settlementId,
    Amount? settlementAmount,
    String? description,
    MetaData? metadata,
    String? status,
    List<Line>? lines,
    String? paymentId,
    String? orderId,
    DateTime? createdAt,
    Embedded? embedded,
    Links? links,
  }) {
    return Refund(
      resource: resource ?? this.resource,
      id: id ?? this.id,
      amount: amount ?? this.amount,
      settlementId: settlementId ?? this.settlementId,
      settlementAmount: settlementAmount ?? this.settlementAmount,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
      status: status ?? this.status,
      lines: lines ?? this.lines,
      paymentId: paymentId ?? this.paymentId,
      orderId: orderId ?? this.orderId,
      createdAt: createdAt ?? this.createdAt,
      embedded: embedded ?? this.embedded,
      links: links ?? this.links,
    );
  }
}
