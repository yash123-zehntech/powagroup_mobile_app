// // To parse this JSON data, do
// //
// //     final quotationResponse = quotationResponseFromJson(jsonString);

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

// part 'quotation_response.g.dart';

// // To parse this JSON data, do
// //
// //     final quotationResponse = quotationResponseFromJson(jsonString);

// QuotationResponse quotationResponseFromJson(String str) =>
//     QuotationResponse.fromJson(json.decode(str));

// String quotationResponseToJson(QuotationResponse data) =>
//     json.encode(data.toJson());

// class QuotationResponse {
//   QuotationResponse(
//       {this.quotationOrders, this.user, this.statusCode, this.error});

//   List<QuotationOrder>? quotationOrders;
//   User? user;
//   int? statusCode;
//   String? error;

//   factory QuotationResponse.fromJson(Map<String, dynamic> json) =>
//       QuotationResponse(
//         quotationOrders: List<QuotationOrder>.from(
//             json["orders"].map((x) => QuotationOrder.fromJson(x))),
//         user: User.fromJson(json["user"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "orders": List<dynamic>.from(quotationOrders!.map((x) => x.toJson())),
//         "user": user!.toJson(),
//       };
// }
// To parse this JSON data, do
//
//     final quotationResponse = quotationResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/address_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/customer_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/orderlist.model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/site_contact_model.dart';
part 'quotation_response.g.dart';

QuotationResponse quotationResponseFromJson(String str) =>
    QuotationResponse.fromJson(json.decode(str));

String quotationResponseToJson(QuotationResponse data) =>
    json.encode(data.toJson());

class QuotationResponse {
  QuotationResponse({this.orders, this.user, this.statusCode, this.error});

  List<QuotationOrder>? orders;
  User? user;
  int? statusCode;
  String? error;

  factory QuotationResponse.fromJson(Map<String, dynamic> json) =>
      QuotationResponse(
        orders: List<QuotationOrder>.from(
            json["orders"].map((x) => QuotationOrder.fromJson(x))),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders!.map((x) => x.toJson())),
        "user": user!.toJson(),
      };
}

// part 'quotation_response.g.dart';
@HiveType(typeId: 14)
// class QuotationOrder {
//   QuotationOrder(
//       {this.id,
//       this.name,
//       this.order_date,
//       this.expiryDate,
//       this.customerId,
//       this.customerName,
//       this.amountTotal,
//       this.state,
//       this.isExpand});
//   @HiveField(0)
//   int? id;
//   @HiveField(1)
//   String? name;
//   @HiveField(2)
//   String? order_date;
//   @HiveField(3)
//   dynamic expiryDate;
//   @HiveField(4)
//   int? customerId;
//   @HiveField(5)
//   String? customerName;
//   @HiveField(6)
//   double? amountTotal;
//   @HiveField(7)
//   String? state;
//   @HiveField(8)
//   bool? isExpand = false;

//   factory QuotationOrder.fromJson(Map<String, dynamic> json) => QuotationOrder(
//         id: json["id"],
//         name: json["name"],
//         order_date: json["order_date"],
//         expiryDate: json["expiry_date"],
//         customerId: json["customer_id"],
//         customerName: json["customer_name"],
//         amountTotal: json["amount_total"].toDouble(),
//         state: json["state"],
//         isExpand: false,
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "order_date": order_date,
//         "expiry_date": expiryDate,
//         "customer_id": customerId,
//         "customer_name": customerName,
//         "amount_total": amountTotal,
//         "state": state,
//       };
// }

// enum ExtraImage { WEB_IMAGE_PRODUCT_IMAGE_IMAGE_1024 }

// final extraImageValues = EnumValues({
//   "/web/image/product.image/image_1024":
//       ExtraImage.WEB_IMAGE_PRODUCT_IMAGE_IMAGE_1024
// });
class QuotationOrder {
  QuotationOrder(
      {this.id,
      this.name,
      this.customerId,
      this.customerName,
      this.customer,
      this.invoiceAddress,
      this.shippingAddress,
      this.siteContact,
      this.orderDate,
      this.expiryDate,
      this.paymentStatus,
      this.shippingStatus,
      this.state,
      this.invoices,
      this.deliveries,
      this.deliveryEx,
      this.subtotalExDelivery,
      this.tax,
      this.subtotal,
      this.total,
      this.isExpand});
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  int? customerId;
  @HiveField(3)
  String? customerName;
  @HiveField(4)
  Customer? customer;
  @HiveField(5)
  Address? invoiceAddress;
  @HiveField(6)
  Address? shippingAddress;
  @HiveField(7)
  SiteContact? siteContact;
  @HiveField(8)
  String? orderDate;
  @HiveField(9)
  dynamic expiryDate;
  @HiveField(10)
  String? paymentStatus;
  @HiveField(11)
  String? shippingStatus;
  @HiveField(12)
  String? state;
  @HiveField(13)
  List<dynamic>? invoices;
  @HiveField(14)
  List<dynamic>? deliveries;
  @HiveField(15)
  dynamic deliveryEx;
  @HiveField(16)
  double? subtotalExDelivery;
  @HiveField(17)
  double? tax;
  @HiveField(18)
  double? subtotal;
  @HiveField(19)
  double? total;
  @HiveField(20)
  bool? isExpand = false;

  factory QuotationOrder.fromJson(Map<String, dynamic> json) => QuotationOrder(
        id: json["id"],
        name: json["name"],
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        customer: Customer.fromJson(json["customer"]),
        invoiceAddress: Address.fromJson(json["invoice_address"]),
        shippingAddress: Address.fromJson(json["shipping_address"]),
        siteContact: SiteContact.fromJson(json["site_contact"]),
        orderDate: json["order_date"],
        expiryDate: json["expiry_date"],
        paymentStatus: json["payment_status"],
        shippingStatus: json["shipping_status"],
        state: json["state"],
        invoices: List<dynamic>.from(json["invoices"].map((x) => x)),
        deliveries: List<dynamic>.from(json["deliveries"].map((x) => x)),
        deliveryEx: json["delivery_ex"] ?? null,
        subtotalExDelivery: json["subtotal_ex_delivery"] ?? null,
        tax: json["tax"] ?? null,
        subtotal: json["subtotal"] ?? null,
        total: json["total"] ?? null,
        isExpand: false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "customer_id": customerId,
        "customer_name": customerName,
        "customer": customer!.toJson(),
        "invoice_address": invoiceAddress!.toJson(),
        "shipping_address": shippingAddress!.toJson(),
        "site_contact": siteContact!.toJson(),
        "order_date": orderDate,
        "expiry_date": expiryDate,
        "payment_status": paymentStatus,
        "shipping_status": shippingStatus,
        "state": state,
        "invoices": List<dynamic>.from(invoices!.map((x) => x)),
        "deliveries": List<dynamic>.from(deliveries!.map((x) => x)),
        "delivery_ex": deliveryEx,
        "subtotal_ex_delivery": subtotalExDelivery,
        "tax": tax,
        "subtotal": subtotal,
        "total": total,
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
  dynamic email;
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
