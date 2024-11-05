// // To parse this JSON data, do
// //
// //     final SubmitResponse = RegisterResponseFromJson(jsonString);

// import 'dart:convert';

// SubmitResponse submitResponseFromJson(String str) =>
//     SubmitResponse.fromJson(json.decode(str));

// String submitResponseToJson(SubmitResponse data) =>
//     json.encode(data.toJson());

// class SubmitResponse {
//   SubmitResponse({this.token, this.error, this.statusCode});

//   String? token;
//   String? error;
//   int? statusCode;

//   factory SubmitResponse.fromJson(Map<String, dynamic> json) =>
//       SubmitResponse(
//         token: json["token"] == null ? null : json["token"],
//       );

//   Map<String, dynamic> toJson() => {
//         "token": token == null ? null : token,
//       };
// }

// To parse this JSON data, do
//
//     final submitResponse = submitResponseFromJson(jsonString);

import 'dart:convert';

SubmitResponse submitResponseFromJson(String str) =>
    SubmitResponse.fromJson(json.decode(str));

String submitResponseToJson(SubmitResponse data) => json.encode(data.toJson());

class SubmitResponse {
  SubmitResponse({this.success, this.result, this.error, this.statusCode});

  bool? success;
  int? result;
  String? error;
  int? statusCode;

  factory SubmitResponse.fromJson(Map<String, dynamic> json) => SubmitResponse(
        success: json["success"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "result": result,
      };
}
