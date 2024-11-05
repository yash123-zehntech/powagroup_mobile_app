import 'dart:convert';

class RegisterResponse {
  bool? success;
  int? result;
  int? statusCode;
  String? error;

  RegisterResponse({this.success, this.result, this.statusCode, this.error});

  factory RegisterResponse.fromRawJson(String str) =>
      RegisterResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        success: json["success"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "result": result,
      };
}
