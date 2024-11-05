import 'dart:convert';

import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';

SearchResponse searchResponseFromJson(String str) =>
    SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
  SearchResponse(
      {this.products,
      this.user,
      this.error,
      this.statusCode,
      this.productResult,
      this.deliveryEx,
      this.deliveryInc,
      this.deliveryTax});

  List<ProductData>? products;
  User? user;
  String? error;
  int? statusCode;
  SearchResponse? productResult;
  dynamic deliveryEx;
  dynamic deliveryInc;
  dynamic deliveryTax;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        products: List<ProductData>.from(
            json["products"].map((x) => ProductData.fromJson(x))),
        user: User.fromJson(json["user"]),
        deliveryEx: json["delivery_ex"],
        deliveryInc: json["delivery_inc"],
        deliveryTax: json["delivery_tax"],
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
        "user": user!.toJson(),
        "delivery_ex": deliveryEx,
        "delivery_inc": deliveryInc,
        "delivery_tax": deliveryTax
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
