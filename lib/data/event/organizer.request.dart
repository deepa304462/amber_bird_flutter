import 'dart:convert';

import 'contact.request.dart';

class Organizer {
	String? userType;
	Contact? contact;

	Organizer({this.userType, this.contact});

	@override
	String toString() => 'Organizer(userType: $userType, contact: $contact)';

	factory Organizer.fromMap(Map<String, dynamic> data) => Organizer(
				userType: data['userType'] as String?,
				contact: data['contact'] == null
						? null
						: Contact.fromMap(data['contact'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toMap() => {
				'userType': userType,
				'contact': contact?.toMap(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Organizer].
	factory Organizer.fromJson(String data) {
		return Organizer.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Organizer] to a JSON string.
	String toJson() => json.encode(toMap());

	Organizer copyWith({
		String? userType,
		Contact? contact,
	}) {
		return Organizer(
			userType: userType ?? this.userType,
			contact: contact ?? this.contact,
		);
	}
}
