// To parse this JSON data, do
//
//     final productReview = productReviewFromJson(jsonString);

// import 'dart:convert';

// import 'package:hive/hive.dart';
// part 'review_model.g.dart';

// ProductReview productReviewFromJson(String str) =>
//     ProductReview.fromJson(json.decode(str));

// String productReviewToJson(ProductReview data) => json.encode(data.toJson());

// class ProductReview {
//   ProductReview({this.reviews, this.totalCount, this.error, this.statusCode});

//   List<UserReview>? reviews;
//   int? totalCount;
//   int? statusCode;
//   String? error;

//   factory ProductReview.fromJson(Map<String, dynamic> json) => ProductReview(
//         reviews: json["reviews"] == null
//             ? null
//             : List<UserReview>.from(
//                 json["reviews"].map((x) => UserReview.fromJson(x))),
//         totalCount: json["total_review_count"] == null
//             ? null
//             : json["total_review_count"],
//       );

//   Map<String, dynamic> toJson() => {
//         "reviews": reviews == null
//             ? null
//             : List<dynamic>.from(
//                 reviews!.map((x) => x.toJson()),
//               ),
//         "total_review_count": totalCount == null ? null : totalCount,
//       };
// }

// @HiveType(typeId: 16)
// class UserReview {
//   UserReview({
//     this.title,
//     this.review,
//     this.rating,
//     this.reviewedBy,
//   });

//   @HiveField(0)
//   String? title;

//   @HiveField(1)
//   String? review;

//   @HiveField(2)
//   int? rating;

//   @HiveField(3)
//   ReviewedBy? reviewedBy;

//   factory UserReview.fromJson(Map<String, dynamic> json) => UserReview(
//         title: json["title"] == null ? null : json["title"],
//         review: json["review"] == null ? null : json["review"],
//         rating: json["rating"] == null ? null : json["rating"],
//         reviewedBy: json["reviewed_by"] == null
//             ? null
//             : ReviewedBy.fromJson(json["reviewed_by"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "title": title == null ? null : title,
//         "review": review == null ? null : review,
//         "rating": rating == null ? null : rating,
//         "reviewed_by": reviewedBy == null ? null : reviewedBy!.toJson(),
//       };
// }

// @HiveType(typeId: 17)
// class ReviewedBy {
//   ReviewedBy({
//     this.id,
//     this.name,
//     this.company,
//   });

//   @HiveField(0)
//   int? id;

//   @HiveField(1)
//   String? name;

//   @HiveField(2)
//   String? company;

//   factory ReviewedBy.fromJson(Map<String, dynamic> json) => ReviewedBy(
//         id: json["id"] == null ? null : json["id"],
//         name: json["name"] == null ? null : json["name"],
//         company: json["company"] == null ? null : json["company"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "name": name == null ? null : name,
//         "company": company == null ? null : company,
//       };
// }

// To parse this JSON data, do
//
//     final productReview = productReviewFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
part 'review_model.g.dart';

ProductReview productReviewFromJson(String str) =>
    ProductReview.fromJson(json.decode(str));

String productReviewToJson(ProductReview data) => json.encode(data.toJson());

class ProductReview {
  ProductReview(
      {this.reviews, this.totalReviewCount, this.statusCode, this.error});

  List<UserReview>? reviews;
  int? totalReviewCount;
  int? statusCode;
  String? error;

  factory ProductReview.fromJson(Map<String, dynamic> json) => ProductReview(
        reviews: List<UserReview>.from(
            json["reviews"].map((x) => UserReview.fromJson(x))),
        totalReviewCount: json["total_review_count"],
      );

  Map<String, dynamic> toJson() => {
        "reviews": List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "total_review_count": totalReviewCount,
      };
}

@HiveType(typeId: 16)
class UserReview {
  UserReview({
    this.title,
    this.review,
    this.rating,
    this.reviewedBy,
    this.date,
  });

  @HiveField(0)
  String? title;

  @HiveField(1)
  String? review;

  @HiveField(2)
  int? rating;

  @HiveField(3)
  ReviewedBy? reviewedBy;

  @HiveField(4)
  DateTime? date;

  factory UserReview.fromJson(Map<String, dynamic> json) => UserReview(
        title: json["title"],
        review: json["review"],
        rating: json["rating"],
        reviewedBy: ReviewedBy.fromJson(json["reviewed_by"]),
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "review": review,
        "rating": rating,
        "reviewed_by": reviewedBy!.toJson(),
        "date": date!.toIso8601String(),
      };
}

@HiveType(typeId: 17)
class ReviewedBy {
  ReviewedBy({
    this.id,
    this.name,
    this.company,
  });
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
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
