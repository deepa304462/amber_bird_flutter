import 'dart:convert';

import 'address.request.dart';

class Contact {
	String? mobileNumber;
	String? emailAddress;
	Address? address;

	Contact({this.mobileNumber, this.emailAddress, this.address});

	@override
	String toString() {
		return 'Contact(mobileNumber: $mobileNumber, emailAddress: $emailAddress, address: $address)';
	}

	factory Contact.fromMap(Map<String, dynamic> data) => Contact(
				mobileNumber: data['mobileNumber'] as String?,
				emailAddress: data['emailAddress'] as String?,
				address: data['address'] == null
						? null
						: Address.fromMap(data['address'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toMap() => {
				'mobileNumber': mobileNumber,
				'emailAddress': emailAddress,
				'address': address?.toMap(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Contact].
	factory Contact.fromJson(String data) {
		return Contact.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Contact] to a JSON string.
	String toJson() => json.encode(toMap());

	Contact copyWith({
		String? mobileNumber,
		String? emailAddress,
		Address? address,
	}) {
		return Contact(
			mobileNumber: mobileNumber ?? this.mobileNumber,
			emailAddress: emailAddress ?? this.emailAddress,
			address: address ?? this.address,
		);
	}
}
