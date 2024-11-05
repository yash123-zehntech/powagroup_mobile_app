// To parse this JSON data, do
//
//     final deliveryInfo = deliveryInfoFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
part 'delivery_info.g.dart';

List<DeliveryInfo> deliveryInfoFromJson(String str) => List<DeliveryInfo>.from(
    json.decode(str).map((x) => DeliveryInfo.fromJson(x)));

String deliveryInfoToJson(List<DeliveryInfo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 19)
class DeliveryInfo {
  DeliveryInfo(
      {this.id,
      this.name,
      this.email,
      this.type,
      this.street1,
      this.street2,
      this.city,
      this.state,
      this.country,
      this.completeAddress,
      this.selected,
      this.phone});

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
  bool? selected = false;

  @HiveField(10)
  String? completeAddress;

  @HiveField(11)
  String? phone;


  factory DeliveryInfo.fromJson(Map<String, dynamic> json) => DeliveryInfo(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        type: json["type"] == null ? null : json["type"],
        street1: json["street1"] == null ? null : json["street1"],
        street2: json["street2"] == null ? null : json["street2"],
        city: json["city"] == null ? null : json["city"],
        state: json["state"] == null ? null : json["state"],
        country: json["country"] == null ? null : json["country"],
        phone: json["phone"] == null ? null : json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "type": type == null ? null : type,
        "street1": street1 == null ? null : street1,
        "street2": street2 == null ? null : street2,
        "city": city == null ? null : city,
        "state": state == null ? null : state,
        "country": country == null ? null : country,
         "phone": phone == null ? null : phone,
      };
}
