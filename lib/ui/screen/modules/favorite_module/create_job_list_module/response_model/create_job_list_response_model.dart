// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

CreateJobListResponse createJobListResponseFromJson(String str) =>
    CreateJobListResponse.fromJson(json.decode(str));

String createJobListResponseToJson(CreateJobListResponse data) =>
    json.encode(data.toJson());

class CreateJobListResponse {
  CreateJobListResponse({this.token, this.error, this.statusCode});

  String? token;
  String? error;
  int? statusCode;

  factory CreateJobListResponse.fromJson(Map<String, dynamic> json) =>
      CreateJobListResponse(
        token: json["token"] == null ? null : json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token == null ? null : token,
      };
}
