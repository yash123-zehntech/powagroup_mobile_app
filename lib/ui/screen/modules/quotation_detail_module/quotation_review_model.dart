// To parse this JSON data, do
//
//     final quotationComments = quotationCommentsFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
part 'quotation_review_model.g.dart';

QuotationComments quotationCommentsFromJson(String str) =>
    QuotationComments.fromJson(json.decode(str));

String quotationCommentsToJson(QuotationComments data) =>
    json.encode(data.toJson());

class QuotationComments {
  QuotationComments({this.messages, this.user, this.statusCode, this.error});

  List<Message>? messages;
  User? user;
  int? statusCode;
  String? error;

  factory QuotationComments.fromJson(Map<String, dynamic> json) =>
      QuotationComments(
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "messages": List<dynamic>.from(messages!.map((x) => x.toJson())),
        "user": user!.toJson(),
      };
}

@HiveType(typeId: 36)
class Message {
  Message({
    this.id,
    this.datetime,
    this.note,
  });
  @HiveField(0)
  int? id;
  @HiveField(1)
  DateTime? datetime;
  @HiveField(2)
  String? note;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        datetime: DateTime.parse(json["datetime"]),
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "datetime": datetime!.toIso8601String(),
        "note": note,
      };
}

class User {
  User({
    this.userId,
    this.partnerId,
    this.name,
    this.email,
    this.isLoggedIn,
  });

  int? userId;
  int? partnerId;
  String? name;
  String? email;
  bool? isLoggedIn;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        partnerId: json["partner_id"],
        name: json["name"],
        email: json["email"],
        isLoggedIn: json["is_logged_in"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "partner_id": partnerId,
        "name": name,
        "email": email,
        "is_logged_in": isLoggedIn,
      };
}
