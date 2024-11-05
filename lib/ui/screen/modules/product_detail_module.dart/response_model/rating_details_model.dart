// To parse this JSON data, do
//
//     final ratingDetail = ratingDetailFromJson(jsonString);

import 'dart:convert';

RatingDetail ratingDetailFromJson(String str) =>
    RatingDetail.fromJson(json.decode(str));

String ratingDetailToJson(RatingDetail data) => json.encode(data.toJson());

class RatingDetail {
  RatingDetail({this.review, this.user, this.error, this.statusCode});

  Review? review;
  User? user;
  String? error;
  int? statusCode;

  factory RatingDetail.fromJson(Map<String, dynamic> json) => RatingDetail(
        review: Review.fromJson(json["review"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "review": review!.toJson(),
        "user": user!.toJson(),
      };
}

class Review {
  Review({
    this.title,
    this.review,
    this.rating,
    this.reviewedBy,
  });

  String? title;
  String? review;
  int? rating;
  ReviewedBy? reviewedBy;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        title: json["title"],
        review: json["review"],
        rating: json["rating"],
        reviewedBy: ReviewedBy.fromJson(json["reviewed_by"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "review": review,
        "rating": rating,
        "reviewed_by": reviewedBy!.toJson(),
      };
}

class ReviewedBy {
  ReviewedBy({
    this.id,
    this.name,
    this.company,
  });

  int? id;
  String? name;
  String? company;

  factory ReviewedBy.fromJson(Map<String, dynamic> json) => ReviewedBy(
        id: json["id"],
        name: json["name"],
        company: json["company"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "company": company,
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
