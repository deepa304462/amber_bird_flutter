import 'dart:convert';

class HashTag {
  List<String>? lessSale;
  List<String>? shortExpiry;
  List<String>? intentionalPush;
  List<String>? remainingTags;

  HashTag({
    this.lessSale,
    this.shortExpiry,
    this.intentionalPush,
    this.remainingTags,
  });

  @override
  String toString() {
    return 'HashTag(lessSale: $lessSale, shortExpiry: $shortExpiry, intentionalPush: $intentionalPush, remainingTags: $remainingTags)';
  }

  factory HashTag.fromMap(Map<String, dynamic> data) => HashTag(
        lessSale: (data['lessSale'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        shortExpiry: (data['shortExpiry'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        intentionalPush: (data['intentionalPush'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        remainingTags: (data['remainingTags'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'lessSale': lessSale,
        'shortExpiry': shortExpiry,
        'intentionalPush': intentionalPush,
        'remainingTags': remainingTags,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [HashTag].
  factory HashTag.fromJson(String data) {
    return HashTag.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [HashTag] to a JSON string.
  String toJson() => json.encode(toMap());

  HashTag copyWith({
    List<String>? lessSale,
    List<String>? shortExpiry,
    List<String>? intentionalPush,
    List<String>? remainingTags,
  }) {
    return HashTag(
      lessSale: lessSale ?? this.lessSale,
      shortExpiry: shortExpiry ?? this.shortExpiry,
      intentionalPush: intentionalPush ?? this.intentionalPush,
      remainingTags: remainingTags ?? this.remainingTags,
    );
  }
}
