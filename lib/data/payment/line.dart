import 'dart:convert';

import 'package:amber_bird/data/deal_product/meta_data.dart';
import 'package:amber_bird/data/payment/amount.dart';
 
import 'links.dart'; 
 
class Line {
  String? resource;
  String? id;
  String? type;
  String? name;
  String? status;
  int? quantity;
  int? quantityShipped;
  Amount? amountShipped;
  int? quantityRefunded;
  Amount? amountRefunded;
  int? quantityCanceled;
  Amount? amountCanceled;
  int? shippableQuantity;
  int? refundableQuantity;
  int? cancelableQuantity;
  Amount? unitPrice;
  Amount? discountAmount;
  Amount? totalAmount;
  String? vatRate;
  Amount? vatAmount;
  String? sku;
  DateTime? createdAt;
  MetaData? metadata;
  bool? cancelable;
  Links? links;

  Line({
    this.resource,
    this.id,
    this.type,
    this.name,
    this.status,
    this.quantity,
    this.quantityShipped,
    this.amountShipped,
    this.quantityRefunded,
    this.amountRefunded,
    this.quantityCanceled,
    this.amountCanceled,
    this.shippableQuantity,
    this.refundableQuantity,
    this.cancelableQuantity,
    this.unitPrice,
    this.discountAmount,
    this.totalAmount,
    this.vatRate,
    this.vatAmount,
    this.sku,
    this.createdAt,
    this.metadata,
    this.cancelable,
    this.links,
  });

  @override
  String toString() {
    return 'Line(resource: $resource, id: $id, type: $type, name: $name, status: $status, quantity: $quantity, quantityShipped: $quantityShipped, amountShipped: $amountShipped, quantityRefunded: $quantityRefunded, amountRefunded: $amountRefunded, quantityCanceled: $quantityCanceled, amountCanceled: $amountCanceled, shippableQuantity: $shippableQuantity, refundableQuantity: $refundableQuantity, cancelableQuantity: $cancelableQuantity, unitPrice: $unitPrice, discountAmount: $discountAmount, totalAmount: $totalAmount, vatRate: $vatRate, vatAmount: $vatAmount, sku: $sku, createdAt: $createdAt, metadata: $metadata, cancelable: $cancelable, links: $links)';
  }

  factory Line.fromMap(Map<String, dynamic> data) => Line(
        resource: data['resource'] as String?,
        id: data['id'] as String?,
        type: data['type'] as String?,
        name: data['name'] as String?,
        status: data['status'] as String?,
        quantity: data['quantity'] as int?,
        quantityShipped: data['quantityShipped'] as int?,
        amountShipped: data['amountShipped'] == null
            ? null
            : Amount.fromMap(
                data['amountShipped'] as Map<String, dynamic>),
        quantityRefunded: data['quantityRefunded'] as int?,
        amountRefunded: data['amountRefunded'] == null
            ? null
            : Amount.fromMap(
                data['amountRefunded'] as Map<String, dynamic>),
        quantityCanceled: data['quantityCanceled'] as int?,
        amountCanceled: data['amountCanceled'] == null
            ? null
            : Amount.fromMap(
                data['amountCanceled'] as Map<String, dynamic>),
        shippableQuantity: data['shippableQuantity'] as int?,
        refundableQuantity: data['refundableQuantity'] as int?,
        cancelableQuantity: data['cancelableQuantity'] as int?,
        unitPrice: data['unitPrice'] == null
            ? null
            : Amount.fromMap(data['unitPrice'] as Map<String, dynamic>),
        discountAmount: data['discountAmount'] == null
            ? null
            : Amount.fromMap(
                data['discountAmount'] as Map<String, dynamic>),
        totalAmount: data['totalAmount'] == null
            ? null
            : Amount.fromMap(data['totalAmount'] as Map<String, dynamic>),
        vatRate: data['vatRate'] as String?,
        vatAmount: data['vatAmount'] == null
            ? null
            : Amount.fromMap(data['vatAmount'] as Map<String, dynamic>),
        sku: data['sku'] as String?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        metadata: data['metadata'] == null
            ? null
            : MetaData.fromMap(data['metadata'] as Map<String, dynamic>),
        cancelable: data['cancelable'] as bool?,
        links: data['_links'] == null
            ? null
            : Links.fromMap(data['_links'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'resource': resource,
        'id': id,
        'type': type,
        'name': name,
        'status': status,
        'quantity': quantity,
        'quantityShipped': quantityShipped,
        'amountShipped': amountShipped?.toMap(),
        'quantityRefunded': quantityRefunded,
        'amountRefunded': amountRefunded?.toMap(),
        'quantityCanceled': quantityCanceled,
        'amountCanceled': amountCanceled?.toMap(),
        'shippableQuantity': shippableQuantity,
        'refundableQuantity': refundableQuantity,
        'cancelableQuantity': cancelableQuantity,
        'unitPrice': unitPrice?.toMap(),
        'discountAmount': discountAmount?.toMap(),
        'totalAmount': totalAmount?.toMap(),
        'vatRate': vatRate,
        'vatAmount': vatAmount?.toMap(),
        'sku': sku,
        'createdAt': createdAt?.toIso8601String(),
        'metadata': metadata?.toMap(),
        'cancelable': cancelable,
        '_links': links?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Line].
  factory Line.fromJson(String data) {
    return Line.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Line] to a JSON string.
  String toJson() => json.encode(toMap());

  Line copyWith({
    String? resource,
    String? id,
    String? type,
    String? name,
    String? status,
    int? quantity,
    int? quantityShipped,
    Amount? amountShipped,
    int? quantityRefunded,
    Amount? amountRefunded,
    int? quantityCanceled,
    Amount? amountCanceled,
    int? shippableQuantity,
    int? refundableQuantity,
    int? cancelableQuantity,
    Amount? unitPrice,
    Amount? discountAmount,
    Amount? totalAmount,
    String? vatRate,
    Amount? vatAmount,
    String? sku,
    DateTime? createdAt,
    MetaData? metadata,
    bool? cancelable,
    Links? links,
  }) {
    return Line(
      resource: resource ?? this.resource,
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
      quantityShipped: quantityShipped ?? this.quantityShipped,
      amountShipped: amountShipped ?? this.amountShipped,
      quantityRefunded: quantityRefunded ?? this.quantityRefunded,
      amountRefunded: amountRefunded ?? this.amountRefunded,
      quantityCanceled: quantityCanceled ?? this.quantityCanceled,
      amountCanceled: amountCanceled ?? this.amountCanceled,
      shippableQuantity: shippableQuantity ?? this.shippableQuantity,
      refundableQuantity: refundableQuantity ?? this.refundableQuantity,
      cancelableQuantity: cancelableQuantity ?? this.cancelableQuantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      vatRate: vatRate ?? this.vatRate,
      vatAmount: vatAmount ?? this.vatAmount,
      sku: sku ?? this.sku,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
      cancelable: cancelable ?? this.cancelable,
      links: links ?? this.links,
    );
  }
}
