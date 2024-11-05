// To parse this JSON data, do
//
//     final SalesOrderResponse = SalesOrderResponseFromJson(jsonString);

// To parse this JSON data, do
//
//     final salesOrderResponse = salesOrderResponseFromJson(jsonString);

import 'dart:convert';

import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/orderlist.model.dart';

SalesOrderResponse salesOrderResponseFromJson(String str) =>
    SalesOrderResponse.fromJson(json.decode(str));

String salesOrderResponseToJson(SalesOrderResponse data) =>
    json.encode(data.toJson());

class SalesOrderResponse {
  SalesOrderResponse({this.orders, this.user, this.statusCode, this.error});

  List<Order>? orders;
  User? user;
  int? statusCode;
  String? error;

  factory SalesOrderResponse.fromJson(Map<String, dynamic> json) =>
      SalesOrderResponse(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders!.map((x) => x.toJson())),
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
