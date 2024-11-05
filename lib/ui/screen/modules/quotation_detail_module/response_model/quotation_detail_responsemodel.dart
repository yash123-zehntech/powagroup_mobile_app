// import 'dart:convert';

// import 'package:hive/hive.dart';
// //     final quotationOrderDetailsList = quotationOrderDetailsListFromJson(jsonString);

// import 'dart:convert';

// import 'package:powagroup/ui/screen/modules/sales_order_detail_module/response_model.dart/order_detail_response.dart';
// part 'quotation_detail_responsemodel.g.dart';
// QuotationOrderDetailsList quotationOrderDetailsListFromJson(String str) =>
//     QuotationOrderDetailsList.fromJson(json.decode(str));

// String quotationOrderDetailsListToJson(QuotationOrderDetailsList data) =>
//     json.encode(data.toJson());

// @HiveType(typeId: 28)
// class QuotationOrderDetailsList {
//   QuotationOrderDetailsList(
//       {this.order, this.user, this.error, this.statusCode});
//   @HiveField(0)
//   Orders? order;
//   @HiveField(1)
//   User? user;
//   @HiveField(2)
//   int? statusCode;
//   @HiveField(3)
//   String? error;

//   factory QuotationOrderDetailsList.fromJson(Map<String, dynamic> json) =>
//       QuotationOrderDetailsList(
//         order: Orders.fromJson(json["order"]),
//         user: User.fromJson(json["user"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "order": order!.toJson(),
//         "user": user!.toJson(),
//       };
// }

// To parse this JSON data, do
//
//     final quotationOrderDetailsList = quotationOrderDetailsListFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:powagroup/ui/screen/modules/sales_order_detail_module/response_model.dart/order_detail_response.dart';
part 'quotation_detail_responsemodel.g.dart';

QuotationOrderDetailsList quotationOrderDetailsListFromJson(String str) =>
    QuotationOrderDetailsList.fromJson(json.decode(str));

String quotationOrderDetailsListToJson(QuotationOrderDetailsList data) =>
    json.encode(data.toJson());

@HiveType(typeId: 28)
class QuotationOrderDetailsList {
  QuotationOrderDetailsList(
      {this.order, this.user, this.statusCode, this.error});
  @HiveField(0)
  Orders? order;
  @HiveField(1)
  User? user;
  @HiveField(2)
  int? statusCode;
  @HiveField(3)
  String? error;
  @HiveField(4)
  // List<Message>? messages;

  factory QuotationOrderDetailsList.fromJson(Map<String, dynamic> json) =>
      QuotationOrderDetailsList(
        order: Orders.fromJson(json["order"]),
        user: User.fromJson(json["user"]),
        // messages:
        //     List<Message>.from(json["reviews"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "order": order!.toJson(),
        "user": user!.toJson(),
        // "messages": List<dynamic>.from(messages!.map((x) => x.toJson())),
      };
}

// @HiveType(typeId: 36)
// class Message {
//   Message({
//     this.id,
//     this.datetime,
//     this.note,
//   });

//   @HiveField(0)
//   int? id;
//   @HiveField(1)
//   DateTime? datetime;
//   @HiveField(2)
//   String? note;

//   factory Message.fromJson(Map<String, dynamic> json) => Message(
//         id: json["id"],
//         datetime: DateTime.parse(json["datetime"]),
//         note: json["note"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "datetime": datetime!.toIso8601String(),
//         "note": note,
//       };
// }

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
  dynamic isLoggedIn;

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
