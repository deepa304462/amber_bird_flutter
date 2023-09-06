/// line1 : null
/// line2 : null
/// locality : "Ashburn"
/// state : "Virginia"
/// country : "US"
/// landMark : null
/// zipCode : "20147"
/// geo : {"type":"point","coordinates":[-77.4875,39.0437]}

class Location {
  Location({
      dynamic line1, 
      dynamic line2, 
      String? locality, 
      String? state, 
      String? country, 
      dynamic landMark, 
      String? zipCode, 
      Geo? geo,}){
    _line1 = line1;
    _line2 = line2;
    _locality = locality;
    _state = state;
    _country = country;
    _landMark = landMark;
    _zipCode = zipCode;
    _geo = geo;
}

  Location.fromJson(dynamic json) {
    _line1 = json['line1'];
    _line2 = json['line2'];
    _locality = json['locality'];
    _state = json['state'];
    _country = json['country'];
    _landMark = json['landMark'];
    _zipCode = json['zipCode'];
    _geo = json['geo'] != null ? Geo.fromJson(json['geo']) : null;
  }
  dynamic _line1;
  dynamic _line2;
  String? _locality;
  String? _state;
  String? _country;
  dynamic _landMark;
  String? _zipCode;
  Geo? _geo;
Location copyWith({  dynamic line1,
  dynamic line2,
  String? locality,
  String? state,
  String? country,
  dynamic landMark,
  String? zipCode,
  Geo? geo,
}) => Location(  line1: line1 ?? _line1,
  line2: line2 ?? _line2,
  locality: locality ?? _locality,
  state: state ?? _state,
  country: country ?? _country,
  landMark: landMark ?? _landMark,
  zipCode: zipCode ?? _zipCode,
  geo: geo ?? _geo,
);
  dynamic get line1 => _line1;
  dynamic get line2 => _line2;
  String? get locality => _locality;
  String? get state => _state;
  String? get country => _country;
  dynamic get landMark => _landMark;
  String? get zipCode => _zipCode;
  Geo? get geo => _geo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['line1'] = _line1;
    map['line2'] = _line2;
    map['locality'] = _locality;
    map['state'] = _state;
    map['country'] = _country;
    map['landMark'] = _landMark;
    map['zipCode'] = _zipCode;
    if (_geo != null) {
      map['geo'] = _geo?.toJson();
    }
    return map;
  }

}

/// type : "point"
/// coordinates : [-77.4875,39.0437]

class Geo {
  Geo({
      String? type, 
      List<num>? coordinates,}){
    _type = type;
    _coordinates = coordinates;
}

  Geo.fromJson(dynamic json) {
    _type = json['type'];
    _coordinates = json['coordinates'] != null ? json['coordinates'].cast<num>() : [];
  }
  String? _type;
  List<num>? _coordinates;
Geo copyWith({  String? type,
  List<num>? coordinates,
}) => Geo(  type: type ?? _type,
  coordinates: coordinates ?? _coordinates,
);
  String? get type => _type;
  List<num>? get coordinates => _coordinates;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['coordinates'] = _coordinates;
    return map;
  }

}