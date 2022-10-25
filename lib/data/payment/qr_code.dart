import 'dart:convert';

class QrCode {
  int? height;
  int? width;
  String? src;

  QrCode({this.height, this.width, this.src});

  @override
  String toString() => 'QrCode(height: $height, width: $width, src: $src)';

  factory QrCode.fromMap(Map<String, dynamic> data) => QrCode(
        height: data['height'] as int?,
        width: data['width'] as int?,
        src: data['src'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'height': height,
        'width': width,
        'src': src,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [QrCode].
  factory QrCode.fromJson(String data) {
    return QrCode.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [QrCode] to a JSON string.
  String toJson() => json.encode(toMap());

  QrCode copyWith({
    int? height,
    int? width,
    String? src,
  }) {
    return QrCode(
      height: height ?? this.height,
      width: width ?? this.width,
      src: src ?? this.src,
    );
  }
}
