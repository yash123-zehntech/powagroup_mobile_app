// To parse this JSON data, do
//
//     final createAddressResponse = createAddressResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CreateAddressResponse createAddressResponseFromJson(String str) =>
    CreateAddressResponse.fromJson(json.decode(str));

String createAddressResponseToJson(CreateAddressResponse data) =>
    json.encode(data.toJson());

class CreateAddressResponse {
  String? jsonrpc;
  dynamic id;
  String? result;
  String? error;
  int? statusCode;

  CreateAddressResponse(
      {this.jsonrpc, this.id, this.result, this.error, this.statusCode});

  factory CreateAddressResponse.fromJson(Map<String, dynamic> json) =>
      CreateAddressResponse(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result,
      };
}
