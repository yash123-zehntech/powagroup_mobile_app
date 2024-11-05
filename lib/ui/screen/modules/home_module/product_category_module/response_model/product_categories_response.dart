// To parse this JSON data, do
//
//     final productCategoriesResponse = productCategoriesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
part 'product_categories_response.g.dart';

ProductCategoriesResponse productCategoriesResponseFromJson(String str) =>
    ProductCategoriesResponse.fromJson(json.decode(str));

String productCategoriesResponseToJson(ProductCategoriesResponse data) =>
    json.encode(data.toJson());

class ProductCategoriesResponse {
  ProductCategoriesResponse(
      {this.categories, this.user, this.error, this.statusCode});

  List<Category>? categories;
  UserDetails? user;
  String? error;
  int? statusCode;

  factory ProductCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      ProductCategoriesResponse(
        categories: json["categories"] == null
            ? null
            : List<Category>.from(
                json["categories"].map((x) => Category.fromJson(x))),
        user: json["user"] == null ? null : UserDetails.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "user": user == null ? null : user!.toJson(),
      };
}

@HiveType(typeId: 0)
class Category {
  Category({
    this.name,
    this.parentId,
    this.parentName,
    this.parentPath,
    this.imageUrl,
  });

  @HiveField(0)
  String? name;

  @HiveField(1)
  dynamic parentId;

  @HiveField(2)
  dynamic parentName;

  @HiveField(3)
  String? parentPath;

  @HiveField(4)
  String? imageUrl;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"] == null ? null : json["name"],
        parentId: json["parent_id"],
        parentName: json["parent_name"],
        parentPath: json["parent_path"] == null ? null : json["parent_path"],
        imageUrl: json["image_url"] == null ? null : json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "parent_id": parentId,
        "parent_name": parentName,
        "parent_path": parentPath == null ? null : parentPath,
        "image_url": imageUrl == null ? null : imageUrl,
      };
}

class UserDetails {
  UserDetails({
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

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        userId: json["user_id"] == null ? null : json["user_id"],
        partnerId: json["partner_id"] == null ? null : json["partner_id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        isLoggedIn: json["is_logged_in"] == null ? null : json["is_logged_in"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "partner_id": partnerId == null ? null : partnerId,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "is_logged_in": isLoggedIn == null ? null : isLoggedIn,
      };
}
