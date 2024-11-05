// To parse this JSON data, do
//
//     final allFavouriteProductResponse = allFavouriteProductResponseFromJson(jsonString);

import 'dart:convert';

JobProductResponse jobProductResponseFromJson(String str) =>
    JobProductResponse.fromJson(json.decode(str));

String jobProductResponseToJson(JobProductResponse data) =>
    json.encode(data.toJson());

class JobProductResponse {
  JobProductResponse({this.products, this.user, this.error, this.statusCode});

  List<Product>? products;
  User? user;
  String? error;
  int? statusCode;

  factory JobProductResponse.fromJson(Map<String, dynamic> json) =>
      JobProductResponse(
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
        "user": user!.toJson(),
      };
}

class Product {
  Product({
    this.id,
    this.name,
    this.code,
    this.price,
    this.qtyBreaks,
    this.mainImageUrl,
    this.extraImages,
  });

  int? id;
  String? name;
  String? code;
  int? price;
  List<QtyBreak>? qtyBreaks;
  String? mainImageUrl;
  List<String>? extraImages;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        price: json["price"],
        qtyBreaks: List<QtyBreak>.from(
            json["qty_breaks"].map((x) => QtyBreak.fromJson(x))),
        mainImageUrl: json["main_image_url"],
        extraImages: List<String>.from(json["extra_images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "price": price,
        "qty_breaks": List<dynamic>.from(qtyBreaks!.map((x) => x.toJson())),
        "main_image_url": mainImageUrl,
        "extra_images": List<dynamic>.from(extraImages!.map((x) => x)),
      };
}

class QtyBreak {
  QtyBreak({
    this.qty,
    this.price,
  });

  String? qty;
  int? price;

  factory QtyBreak.fromJson(Map<String, dynamic> json) => QtyBreak(
        qty: json["qty"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "qty": qty,
        "price": price,
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
