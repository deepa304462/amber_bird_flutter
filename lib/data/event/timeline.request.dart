import 'dart:convert';

class Timeline {
	int? timelineId;
	String? topic;
	String? durationInMinutes;
	bool? gap;
	bool? done;
	String? finalComment;

	Timeline({
		this.timelineId, 
		this.topic, 
		this.durationInMinutes, 
		this.gap, 
		this.done, 
		this.finalComment, 
	});

	@override
	String toString() {
		return 'Timeline(timelineId: $timelineId, topic: $topic, durationInMinutes: $durationInMinutes, gap: $gap, done: $done, finalComment: $finalComment)';
	}

	factory Timeline.fromMap(Map<String, dynamic> data) => Timeline(
				timelineId: data['timelineId'] as int?,
				topic: data['topic'] as String?,
				durationInMinutes: data['durationInMinutes'] as String?,
				gap: data['gap'] as bool?,
				done: data['done'] as bool?,
				finalComment: data['finalComment'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'timelineId': timelineId,
				'topic': topic,
				'durationInMinutes': durationInMinutes,
				'gap': gap,
				'done': done,
				'finalComment': finalComment,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Timeline].
	factory Timeline.fromJson(String data) {
		return Timeline.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Timeline] to a JSON string.
	String toJson() => json.encode(toMap());

	Timeline copyWith({
		int? timelineId,
		String? topic,
		String? durationInMinutes,
		bool? gap,
		bool? done,
		String? finalComment,
	}) {
		return Timeline(
			timelineId: timelineId ?? this.timelineId,
			topic: topic ?? this.topic,
			durationInMinutes: durationInMinutes ?? this.durationInMinutes,
			gap: gap ?? this.gap,
			done: done ?? this.done,
			finalComment: finalComment ?? this.finalComment,
		);
	}
}
