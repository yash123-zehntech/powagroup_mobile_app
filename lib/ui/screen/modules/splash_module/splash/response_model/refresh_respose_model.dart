// To parse this JSON data, do
//
//     final refreshTokenResponse = refreshTokenResponseFromJson(jsonString);

import 'dart:convert';

RefreshTokenResponse refreshTokenResponseFromJson(String str) =>
    RefreshTokenResponse.fromJson(json.decode(str));

String refreshTokenResponseToJson(RefreshTokenResponse data) =>
    json.encode(data.toJson());

class RefreshTokenResponse {
  String? token;
  DateTime? utcExpiryDate;
  int? statusCode;
  String? error;

  RefreshTokenResponse(
      {this.token, this.utcExpiryDate, this.statusCode, this.error});

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse(
        token: json["token"],
        utcExpiryDate: json["utc_expiry_date"] == null
            ? null
            : DateTime.parse(json["utc_expiry_date"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "utc_expiry_date": utcExpiryDate?.toIso8601String(),
      };
}
