// To parse this JSON data, do
//
//     final blogDetailModel = blogDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';

part 'blog_detail.g.dart';

BlogDetailModel blogDetailModelFromJson(String str) =>
    BlogDetailModel.fromJson(json.decode(str));

String blogDetailModelToJson(BlogDetailModel data) =>
    json.encode(data.toJson());

class BlogDetailModel {
  BlogDetailModel({this.blogPosts, this.user, this.error, this.statusCode});

  List<BlogPost>? blogPosts;
  User? user;
  String? error;
  int? statusCode;

  factory BlogDetailModel.fromJson(Map<String, dynamic> json) =>
      BlogDetailModel(
        blogPosts: List<BlogPost>.from(
            json["blog_posts"].map((x) => BlogPost.fromJson(x))),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "blog_posts": List<dynamic>.from(blogPosts!.map((x) => x.toJson())),
        "user": user!.toJson(),
      };
}

@HiveType(typeId: 10)
class BlogPost {
  BlogPost(
      {this.id,
      this.name,
      this.subTitle,
      this.tags,
      this.author,
      this.createDate,
      this.postDate,
      this.lastEditDate,
      this.lastEditBy,
      this.metaTitle,
      this.metaDescription,
      this.metaKeywords,
      this.imageUrl});

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? subTitle;

  @HiveField(3)
  List<dynamic>? tags;

  @HiveField(4)
  Author? author;

  @HiveField(5)
  String? createDate;

  @HiveField(6)
  String? postDate;

  @HiveField(7)
  String? lastEditDate;

  @HiveField(8)
  Author? lastEditBy;

  @HiveField(9)
  String? metaTitle;

  @HiveField(10)
  String? metaDescription;

  @HiveField(11)
  String? metaKeywords;

  @HiveField(12)
  String? imageUrl;

  factory BlogPost.fromJson(Map<String, dynamic> json) => BlogPost(
        id: json["id"],
        name: json["name"],
        subTitle: json["sub_title"],
        tags: List<dynamic>.from(json["tags"].map((x) => x)),
        author: Author.fromJson(json["author"]),
        createDate: json["create_date"],
        postDate: json["post_date"],
        lastEditDate: json["last_edit_date"],
        lastEditBy: Author.fromJson(json["last_edit_by"]),
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        metaKeywords: json["meta_keywords"],
        imageUrl: json["image_url"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sub_title": subTitle,
        "tags": List<dynamic>.from(tags!.map((x) => x)),
        "author": author!.toJson(),
        "create_date": createDate,
        "post_date": postDate,
        "last_edit_date": lastEditDate,
        "last_edit_by": lastEditBy!.toJson(),
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "meta_keywords": metaKeywords,
        "image_url": imageUrl,
      };
}

@HiveType(typeId: 11)
class Author {
  Author({
    this.id,
    this.name,
  });

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
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
