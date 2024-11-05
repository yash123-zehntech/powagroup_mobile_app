// To parse this JSON data, do
//
//     final siteContactResponse = siteContactResponseFromJson(jsonString);

import 'dart:convert';

import 'sitecontact_info_response.dart';

SiteContactResponse siteContactResponseFromJson(String str) =>
    SiteContactResponse.fromJson(json.decode(str));

String siteContactResponseToJson(SiteContactResponse data) =>
    json.encode(data.toJson());

class SiteContactResponse {
  SiteContactResponse({this.siteContactInfo, this.error, this.statusCode});

  List<SiteContactInfo>? siteContactInfo;
  String? error;
  int? statusCode;

  factory SiteContactResponse.fromJson(Map<String, dynamic> json) =>
      SiteContactResponse(
        siteContactInfo: List<SiteContactInfo>.from(
            json["siteContactInfo"].map((x) => SiteContactInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "siteContactInfo":
            List<dynamic>.from(siteContactInfo!.map((x) => x.toJson())),
      };
}
