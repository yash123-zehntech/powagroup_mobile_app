// // // To parse this JSON data, do
// // //
// // //     final SalesOrderDetails = SalesOrderDetailsFromJson(jsonString);

// // import 'dart:convert';

// // import 'package:powagroup/ui/screen/modules/sales_order_detail_module/response_model.dart/order_detail_response.dart';

// // SalesOrderDetails SalesOrderDetailsFromJson(String str) => SalesOrderDetails.fromJson(json.decode(str));

// // String SalesOrderDetailsToJson(SalesOrderDetails data) => json.encode(data.toJson());

// // class SalesOrderDetails {
// //     SalesOrderDetails({
// //         this.order,
// //         this.user,
// //         this.statusCode,
// //         this.error
// //     });

// //     Orders? order;
// //     User? user;
// //       int? statusCode;
// //   String? error;

// //     factory SalesOrderDetails.fromJson(Map<String, dynamic> json) => SalesOrderDetails(
// //         order: Orders.fromJson(json["order"]),
// //         user: User.fromJson(json["user"]),
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "order": order!.toJson(),
// //         "user": user!.toJson(),
// //     };
// // }

// // class User {
// //     User({
// //         this.userId,
// //         this.partnerId,
// //         this.name,
// //         this.email,
// //         this.isLoggedIn,
// //     });

// //     int? userId;
// //     int? partnerId;
// //     String? name;
// //     String? email;
// //     dynamic isLoggedIn;

// //     factory User.fromJson(Map<String, dynamic> json) => User(
// //         userId: json["user_id"],
// //         partnerId: json["partner_id"],
// //         name: json["name"],
// //         email: json["email"],
// //         isLoggedIn: json["is_logged_in"],
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "user_id": userId,
// //         "partner_id": partnerId,
// //         "name": name,
// //         "email": email,
// //         "is_logged_in": isLoggedIn,
// //     };
// // }
// // To parse this JSON data, do
// //
// //     final salesOrderDetails = salesOrderDetailsFromJson(jsonString);

// import 'dart:convert';

// import 'package:hive/hive.dart';
// import 'package:powagroup/ui/screen/modules/sales_order_detail_module/response_model.dart/order_detail_response.dart';

// part 'sales_details_model.g.dart';
// SalesOrderDetails salesOrderDetailsFromJson(String str) =>
//     SalesOrderDetails.fromJson(json.decode(str));

// String salesOrderDetailsToJson(SalesOrderDetails data) =>
//     json.encode(data.toJson());
// @HiveType(typeId: 25)
// class SalesOrderDetails {
//   SalesOrderDetails({this.order, this.user, this.error, this.statusCode});
//   @HiveField(0)
//   Orders? order;
//     @HiveField(1)
//   User? user;
//    @HiveField(2)
//   int? statusCode;
//    @HiveField(3)
//   String? error;

//   factory SalesOrderDetails.fromJson(Map<String, dynamic> json) =>
//       SalesOrderDetails(
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
//     final salesOrderDetails = salesOrderDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:powagroup/ui/screen/modules/sales_order_detail_module/response_model.dart/order_detail_response.dart';
part 'sales_details_model.g.dart';

SalesOrderDetails salesOrderDetailsFromJson(String str) =>
    SalesOrderDetails.fromJson(json.decode(str));

String salesOrderDetailsToJson(SalesOrderDetails data) =>
    json.encode(data.toJson());

@HiveType(typeId: 25)
class SalesOrderDetails {
  SalesOrderDetails({this.order, this.user, this.statusCode, this.error});

  @HiveField(0)
  Orders? order;
  @HiveField(1)
  User? user;
  @HiveField(2)
  int? statusCode;
  @HiveField(3)
  String? error;

  factory SalesOrderDetails.fromJson(Map<String, dynamic> json) =>
      SalesOrderDetails(
        order: Orders.fromJson(json["order"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "order": order!.toJson(),
        "user": user!.toJson(),
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
