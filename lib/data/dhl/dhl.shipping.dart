import 'dart:convert';

import 'shipment.shipping.dart';

class Dhl {
  List<Shipment>? shipments;
  String? url;
  String? firstUrl;
  String? prevUrl;
  String? nextUrl;
  String? lastUrl;
  List<String>? possibleAdditionalShipmentsUrl;

  Dhl({
    this.shipments,
    this.url,
    this.firstUrl,
    this.prevUrl,
    this.nextUrl,
    this.lastUrl,
    this.possibleAdditionalShipmentsUrl,
  });

  @override
  String toString() {
    return 'Dhl(shipments: $shipments, url: $url, firstUrl: $firstUrl, prevUrl: $prevUrl, nextUrl: $nextUrl, lastUrl: $lastUrl, possibleAdditionalShipmentsUrl: $possibleAdditionalShipmentsUrl)';
  }

  factory Dhl.fromMap(Map<String, dynamic> data) => Dhl(
        shipments: (data['shipments'] as List<dynamic>?)
            ?.map((e) => Shipment.fromMap(e as Map<String, dynamic>))
            .toList(),
        url: data['url'] as String?,
        firstUrl: data['firstUrl'] as String?,
        prevUrl: data['prevUrl'] as String?,
        nextUrl: data['nextUrl'] as String?,
        lastUrl: data['lastUrl'] as String?,
        possibleAdditionalShipmentsUrl:
            (data['possibleAdditionalShipmentsUrl'] as List<dynamic>?)
                ?.map((e) => (e as String))
                .toList(),
      );

  Map<String, dynamic> toMap() => {
        'shipments': shipments?.map((e) => e.toMap()).toList(),
        'url': url,
        'firstUrl': firstUrl,
        'prevUrl': prevUrl,
        'nextUrl': nextUrl,
        'lastUrl': lastUrl,
        'possibleAdditionalShipmentsUrl': possibleAdditionalShipmentsUrl,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Dhl].
  factory Dhl.fromJson(String data) {
    return Dhl.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Dhl] to a JSON string.
  String toJson() => json.encode(toMap());

  Dhl copyWith({
    List<Shipment>? shipments,
    String? url,
    String? firstUrl,
    String? prevUrl,
    String? nextUrl,
    String? lastUrl,
    List<String>? possibleAdditionalShipmentsUrl,
  }) {
    return Dhl(
      shipments: shipments ?? this.shipments,
      url: url ?? this.url,
      firstUrl: firstUrl ?? this.firstUrl,
      prevUrl: prevUrl ?? this.prevUrl,
      nextUrl: nextUrl ?? this.nextUrl,
      lastUrl: lastUrl ?? this.lastUrl,
      possibleAdditionalShipmentsUrl:
          possibleAdditionalShipmentsUrl ?? this.possibleAdditionalShipmentsUrl,
    );
  }
}
