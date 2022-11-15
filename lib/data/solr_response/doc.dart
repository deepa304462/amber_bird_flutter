import 'dart:convert';

class Doc {
  String? id;
  String? name;
  String? indexName;
  String? refId;
  String? extraData;
  String? indexData;
  int? version;

  Doc({
    this.id,
    this.name,
    this.indexName,
    this.refId,
    this.extraData,
    this.indexData,
    this.version,
  });

  factory Doc.fromMap(Map<String, dynamic> data) => Doc(
        id: data['id'] as String?,
        name: data['name'] as String?,
        indexName: data['indexName'] as String?,
        refId: data['refId'] as String?,
        extraData: data['extraData'] as String?,
        indexData: data['indexData'] as String?,
        version: data['_version_'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'indexName': indexName,
        'refId': refId,
        'extraData': extraData,
        'indexData': indexData,
        '_version_': version,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Doc].
  factory Doc.fromJson(String data) {
    return Doc.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Doc] to a JSON string.
  String toJson() => json.encode(toMap());
}
