// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({this.token, this.utcExpiryDate, this.error, this.statusCode});

  String? token;
  DateTime? utcExpiryDate;
  String? error;
  int? statusCode;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["token"] == null ? null : json["token"],
        utcExpiryDate: json["utc_expiry_date"] == null
            ? null
            : DateTime.parse(json["utc_expiry_date"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token == null ? null : token,
        "utc_expiry_date": utcExpiryDate?.toIso8601String(),
      };
}
