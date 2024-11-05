// To parse this JSON data, do
//
//     final siteContactInfo = siteContactInfoFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';
part 'sitecontact_info_response.g.dart';

List<SiteContactInfo> siteContactInfoFromJson(String str) =>
    List<SiteContactInfo>.from(
        json.decode(str).map((x) => SiteContactInfo.fromJson(x)));

String siteContactInfoToJson(List<SiteContactInfo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 21)
class SiteContactInfo {
  SiteContactInfo({
    this.id,
    this.name,
    this.email,
    this.type,
    this.street1,
    this.street2,
    this.city,
    this.state,
    this.country,
    required this.selected,
  });
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? type;
  @HiveField(4)
  String? street1;
  @HiveField(5)
  String? street2;
  @HiveField(6)
  String? city;
  @HiveField(7)
  String? state;
  @HiveField(8)
  String? country;
  @HiveField(9)
  bool selected = false;

  factory SiteContactInfo.fromJson(Map<String, dynamic> json) =>
      SiteContactInfo(
          id: json["id"],
          name: json["name"],
          email: json["email"],
          type: json["type"],
          street1: json["street1"],
          street2: json["street2"],
          city: json["city"],
          state: json["state"],
          country: json["country"],
          selected: true);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "type": type,
        "street1": street1,
        "street2": street2,
        "city": city,
        "state": state,
        "country": country,
      };
}
