import 'dart:convert';

class Faq {
  MetaData? metaData;
  String? topic;
  List<QuestionElement>? questions;
  String? image;
  String? url;
  int? orderBy;
  String? id;

  Faq({
    this.metaData,
    this.topic,
    this.questions,
    this.image,
    this.url,
    this.orderBy,
    this.id,
  });

  factory Faq.fromJson(String str) => Faq.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Faq.fromMap(Map<String, dynamic> json) => Faq(
        metaData: json["metaData"] == null
            ? null
            : MetaData.fromMap(json["metaData"]),
        topic: json["topic"],
        questions: json["questions"] == null
            ? []
            : List<QuestionElement>.from(
                json["questions"]!.map((x) => QuestionElement.fromMap(x))),
        image: json["image"],
        url: json["url"],
        orderBy: json["orderBy"],
        id: json["_id"],
      );

  Map<String, dynamic> toMap() => {
        "metaData": metaData?.toMap(),
        "topic": topic,
        "questions": questions == null
            ? []
            : List<dynamic>.from(questions!.map((x) => x.toMap())),
        "image": image,
        "url": url,
        "orderBy": orderBy,
        "_id": id,
      };
}

class MetaData {
  String? createdAt;
  String? updatedAt;
  int? version;
  String? state;
  String? timeZone;

  MetaData({
    this.createdAt,
    this.updatedAt,
    this.version,
    this.state,
    this.timeZone,
  });

  factory MetaData.fromJson(String str) => MetaData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MetaData.fromMap(Map<String, dynamic> json) => MetaData(
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        version: json["version"],
        state: json["state"],
        timeZone: json["timeZone"],
      );

  Map<String, dynamic> toMap() => {
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "version": version,
        "state": state,
        "timeZone": timeZone,
      };
}

class QuestionElement {
  QuestionQuestion? question;
  Answer? answer;
  int? orderBy;

  QuestionElement({
    this.question,
    this.answer,
    this.orderBy,
  });

  factory QuestionElement.fromJson(String str) =>
      QuestionElement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QuestionElement.fromMap(Map<String, dynamic> json) => QuestionElement(
        question: json["question"] == null
            ? null
            : QuestionQuestion.fromMap(json["question"]),
        answer: json["answer"] == null ? null : Answer.fromMap(json["answer"]),
        orderBy: json["orderBy"],
      );

  Map<String, dynamic> toMap() => {
        "question": question?.toMap(),
        "answer": answer?.toMap(),
        "orderBy": orderBy,
      };
}

class Answer {
  String? text;
  Font? font;
  String? imgUrl;
  String? videoUrl;

  Answer({
    this.text,
    this.font,
    this.imgUrl,
    this.videoUrl,
  });

  factory Answer.fromJson(String str) => Answer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Answer.fromMap(Map<String, dynamic> json) => Answer(
        text: json["text"],
        font: json["font"] == null ? null : Font.fromMap(json["font"]),
        imgUrl: json["imgUrl"],
        videoUrl: json["videoUrl"],
      );

  Map<String, dynamic> toMap() => {
        "text": text,
        "font": font?.toMap(),
        "imgUrl": imgUrl,
        "videoUrl": videoUrl,
      };
}

class Font {
  dynamic family;
  dynamic size;
  dynamic color;

  Font({
    this.family,
    this.size,
    this.color,
  });

  factory Font.fromJson(String str) => Font.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Font.fromMap(Map<String, dynamic> json) => Font(
        family: json["family"],
        size: json["size"],
        color: json["color"],
      );

  Map<String, dynamic> toMap() => {
        "family": family,
        "size": size,
        "color": color,
      };
}

class QuestionQuestion {
  String? text;
  Font? font;

  QuestionQuestion({
    this.text,
    this.font,
  });

  factory QuestionQuestion.fromJson(String str) =>
      QuestionQuestion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QuestionQuestion.fromMap(Map<String, dynamic> json) =>
      QuestionQuestion(
        text: json["text"],
        font: json["font"] == null ? null : Font.fromMap(json["font"]),
      );

  Map<String, dynamic> toMap() => {
        "text": text,
        "font": font?.toMap(),
      };
}
