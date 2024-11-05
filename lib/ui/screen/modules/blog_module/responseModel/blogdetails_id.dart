// To parse this JSON data, do
//
//     final blogDetailByIndex = blogDetailByIndexFromJson(jsonString);

import 'dart:convert';

import 'package:powagroup/ui/screen/modules/home_module/home_module/model/blog_detail.dart';

BlogDetailByIndex blogDetailByIndexFromJson(String str) =>
    BlogDetailByIndex.fromJson(json.decode(str));

String blogDetailByIndexToJson(BlogDetailByIndex data) =>
    json.encode(data.toJson());

class BlogDetailByIndex {
  BlogDetailByIndex(
      {this.blogPost, this.user, this.error, this.statusCode}); //this.user

  BlogPostData? blogPost;
  User? user;
  String? error;
  int? statusCode;

  factory BlogDetailByIndex.fromJson(Map<String, dynamic> json) =>
      BlogDetailByIndex(
        blogPost: BlogPostData.fromJson(json["blog_post"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "blog_post": blogPost!.toJson(),
        //"user": user!.toJson(),
      };
}

class BlogPostData {
  BlogPostData(
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
      this.content,
      this.image});

  int? id;
  String? name;
  String? subTitle;
  List<dynamic>? tags;
  Author? author;
  String? createDate;
  String? postDate;
  String? lastEditDate;
  Author? lastEditBy;
  String? metaTitle;
  String? metaDescription;
  String? metaKeywords;
  String? content;
  String? image;

  factory BlogPostData.fromJson(Map<String, dynamic> json) => BlogPostData(
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
        content: json["content"],
        image: json["image"] ?? '',
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
        "content": content,
        "image": image,
      };
}

class Author {
  Author({
    this.id,
    this.name,
  });

  int? id;
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
