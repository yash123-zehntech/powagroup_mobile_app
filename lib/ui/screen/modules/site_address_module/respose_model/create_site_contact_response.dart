// To parse this JSON data, do
//
//     final createSiteContactResponse = createSiteContactResponseFromJson(jsonString);

import 'dart:convert';

CreateSiteContactResponse createSiteContactResponseFromJson(String str) =>
    CreateSiteContactResponse.fromJson(json.decode(str));

String createSiteContactResponseToJson(CreateSiteContactResponse data) =>
    json.encode(data.toJson());

class CreateSiteContactResponse {
  String? jsonrpc;
  dynamic id;
  String? result;
  int? statusCode;
  String? error;

  CreateSiteContactResponse(
      {this.jsonrpc, this.id, this.result, this.statusCode, this.error});

  factory CreateSiteContactResponse.fromJson(Map<String, dynamic> json) =>
      CreateSiteContactResponse(
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
