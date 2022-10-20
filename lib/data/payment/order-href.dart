import 'dart:convert';

class OrderHref {
  String? href;
  String? type;

  OrderHref({this.href, this.type});

  @override
  String toString() => 'Order(href: $href, type: $type)';

  factory OrderHref.fromMap(Map<String, dynamic> data) => OrderHref(
        href: data['href'] as String?,
        type: data['type'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'href': href,
        'type': type,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Order].
  factory OrderHref.fromJson(String data) {
    return OrderHref.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OrderHref] to a JSON string.
  String toJson() => json.encode(toMap());

  OrderHref copyWith({
    String? href,
    String? type,
  }) {
    return OrderHref(
      href: href ?? this.href,
      type: type ?? this.type,
    );
  }
}
