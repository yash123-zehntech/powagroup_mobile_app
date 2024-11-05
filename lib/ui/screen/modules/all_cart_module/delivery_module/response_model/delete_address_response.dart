// To parse this JSON data, do
//
//     final deleteContactResponse = deleteContactResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DeleteContactResponse deleteContactResponseFromJson(String str) =>
    DeleteContactResponse.fromJson(json.decode(str));

String deleteContactResponseToJson(DeleteContactResponse data) =>
    json.encode(data.toJson());

class DeleteContactResponse {
  String? jsonrpc;
  dynamic id;
  String? result;
  String? error;
  int? statusCode;

  DeleteContactResponse(
      {this.jsonrpc, this.id, this.result, this.error, this.statusCode});

  factory DeleteContactResponse.fromJson(Map<String, dynamic> json) =>
      DeleteContactResponse(
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
