import 'dart:convert';

import 'meta_data.request.dart';
import 'organizer.request.dart';
import 'participant.request.dart';
import 'timeline.request.dart';

class Event {
	MetaData? metaData;
	String? type;
	String? title;
	String? toDate;
	String? fromDate;
	String? time;
	String? eventVenue;
	int? durationInMinutes;
	String? status;
	List<Participant>? participants;
	Organizer? organizer;
	List<Timeline>? timelines;

	Event({
		this.metaData, 
		this.type, 
		this.title, 
		this.toDate, 
		this.fromDate, 
		this.time, 
		this.eventVenue, 
		this.durationInMinutes, 
		this.status, 
		this.participants, 
		this.organizer, 
		this.timelines, 
	});

	@override
	String toString() {
		return 'Event(metaData: $metaData, type: $type, title: $title, toDate: $toDate, fromDate: $fromDate, time: $time, eventVenue: $eventVenue, durationInMinutes: $durationInMinutes, status: $status, participants: $participants, organizer: $organizer, timelines: $timelines)';
	}

	factory Event.fromMap(Map<String, dynamic> data) => Event(
				metaData: data['metaData'] == null
						? null
						: MetaData.fromMap(data['metaData'] as Map<String, dynamic>),
				type: data['type'] as String?,
				title: data['title'] as String?,
				toDate: data['toDate'] as String?,
				fromDate: data['fromDate'] as String?,
				time: data['time'] as String?,
				eventVenue: data['eventVenue'] as String?,
				durationInMinutes: data['durationInMinutes'] as int?,
				status: data['status'] as String?,
				participants: (data['participants'] as List<dynamic>?)
						?.map((e) => Participant.fromMap(e as Map<String, dynamic>))
						.toList(),
				organizer: data['organizer'] == null
						? null
						: Organizer.fromMap(data['organizer'] as Map<String, dynamic>),
				timelines: (data['timelines'] as List<dynamic>?)
						?.map((e) => Timeline.fromMap(e as Map<String, dynamic>))
						.toList(),
			);

	Map<String, dynamic> toMap() => {
				'metaData': metaData?.toMap(),
				'type': type,
				'title': title,
				'toDate': toDate,
				'fromDate': fromDate,
				'time': time,
				'eventVenue': eventVenue,
				'durationInMinutes': durationInMinutes,
				'status': status,
				'participants': participants?.map((e) => e.toMap()).toList(),
				'organizer': organizer?.toMap(),
				'timelines': timelines?.map((e) => e.toMap()).toList(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Event].
	factory Event.fromJson(String data) {
		return Event.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Event] to a JSON string.
	String toJson() => json.encode(toMap());

	Event copyWith({
		MetaData? metaData,
		String? type,
		String? title,
		String? toDate,
		String? fromDate,
		String? time,
		String? eventVenue,
		int? durationInMinutes,
		String? status,
		List<Participant>? participants,
		Organizer? organizer,
		List<Timeline>? timelines,
	}) {
		return Event(
			metaData: metaData ?? this.metaData,
			type: type ?? this.type,
			title: title ?? this.title,
			toDate: toDate ?? this.toDate,
			fromDate: fromDate ?? this.fromDate,
			time: time ?? this.time,
			eventVenue: eventVenue ?? this.eventVenue,
			durationInMinutes: durationInMinutes ?? this.durationInMinutes,
			status: status ?? this.status,
			participants: participants ?? this.participants,
			organizer: organizer ?? this.organizer,
			timelines: timelines ?? this.timelines,
		);
	}
}
