// To parse this JSON data, do
//
//     final quotationAddNewComments = quotationAddNewCommentsFromJson(jsonString);

import 'dart:convert';

QuotationAddNewComments quotationAddNewCommentsFromJson(String str) =>
    QuotationAddNewComments.fromJson(json.decode(str));

String quotationAddNewCommentsToJson(QuotationAddNewComments data) =>
    json.encode(data.toJson());

class QuotationAddNewComments {
  QuotationAddNewComments({this.status, this.statusCode, this.error});

  String? status;
  int? statusCode;
  String? error;
  factory QuotationAddNewComments.fromJson(Map<String, dynamic> json) =>
      QuotationAddNewComments(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
