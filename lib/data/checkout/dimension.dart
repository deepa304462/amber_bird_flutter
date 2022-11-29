import 'dart:convert';

class Dimension {
  int? width;
  int? height;
  int? length;

  Dimension({this.width, this.height, this.length});

  @override
  String toString() {
    return 'Dimension(width: $width, height: $height, length: $length)';
  }

  factory Dimension.fromMap(Map<String, dynamic> data) => Dimension(
        width: data['width'] as int?,
        height: data['height'] as int?,
        length: data['length'] as int?,
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
    int? width,
    int? height,
    int? length,
  }) {
    return Dimension(
      width: width ?? this.width,
      height: height ?? this.height,
      length: length ?? this.length,
    );
  }
}
