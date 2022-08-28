import 'dart:convert';

class Dimension {
  double? width;
  double? height;
  double? length;

  Dimension({this.width, this.height, this.length});

  @override
  String toString() {
    return 'Dimension(width: $width, height: $height, length: $length)';
  }

  factory Dimension.fromMap(Map<String, dynamic> data) => Dimension(
        width: data['width'] as double?,
        height: data['height'] as double?,
        length: data['length'] as double?,
      );

  Map<String, dynamic> toMap() => {
        'width': width,
        'height': height,
        'length': length,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Dimension].
  factory Dimension.fromJson(String data) {
    return Dimension.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Dimension] to a JSON string.
  String toJson() => json.encode(toMap());

  Dimension copyWith({
    double? width,
    double? height,
    double? length,
  }) {
    return Dimension(
      width: width ?? this.width,
      height: height ?? this.height,
      length: length ?? this.length,
    );
  }
}
