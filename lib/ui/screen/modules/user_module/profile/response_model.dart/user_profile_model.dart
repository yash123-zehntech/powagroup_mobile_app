// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';

part 'user_profile_model.g.dart';

UserProfile userProfileFromJson(String str) =>
    UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

@HiveType(typeId: 42)
class UserProfile {
  UserProfile({this.user, this.error, this.statusCode});

  @HiveField(0)
  UserObject? user;

  @HiveField(1)
  String? error;

  @HiveField(2)
  int? statusCode;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        user: json["user"] == null ? null : UserObject.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user == null ? null : user!.toJson(),
      };
}

@HiveType(typeId: 41)
class UserObject {
  UserObject(
      {this.userId,
      this.partnerId,
      this.name,
      this.email,
      this.isLoggedIn,
      this.priceListId,
      this.priceListName,
      this.paymentTermId,
      this.paymentTermName,
      this.preferredDeliveryMethodId,
      this.preferredDeliveryMethodName,
      this.id,
      this.phone,
      this.mobile,
      this.type,
      this.street1,
      this.street2,
      this.city,
      this.state,
      this.country,
      this.showPricing});

  @HiveField(0)
  int? userId;

  @HiveField(1)
  int? partnerId;

  @HiveField(2)
  String? name;

  @HiveField(3)
  String? email;

  @HiveField(4)
  bool? isLoggedIn;

  @HiveField(5)
  int? priceListId;

  @HiveField(6)
  String? priceListName;

  @HiveField(7)
  dynamic paymentTermId;

  @HiveField(8)
  dynamic paymentTermName;

  @HiveField(9)
  dynamic preferredDeliveryMethodId;

  @HiveField(10)
  dynamic preferredDeliveryMethodName;

  @HiveField(11)
  int? id;

  @HiveField(12)
  String? phone;

  @HiveField(13)
  String? mobile;

  @HiveField(14)
  String? type;

  @HiveField(15)
  String? street1;

  @HiveField(16)
  String? street2;

  @HiveField(17)
  String? city;

  @HiveField(18)
  String? state;

  @HiveField(19)
  String? country;

  @HiveField(20)
  bool? showPricing;

  factory UserObject.fromJson(Map<String, dynamic> json) => UserObject(
        userId: json["user_id"] == null ? null : json["user_id"],
        partnerId: json["partner_id"] == null ? null : json["partner_id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        isLoggedIn: json["is_logged_in"] == null ? null : json["is_logged_in"],
        priceListId:
            json["price_list_id"] == null ? null : json["price_list_id"],
        priceListName:
            json["price_list_name"] == null ? null : json["price_list_name"],
        paymentTermId:
            json["payment_term_id"] == null ? null : json["payment_term_id"],
        paymentTermName: json["payment_term_name"] == null
            ? null
            : json["payment_term_name"],
        preferredDeliveryMethodId: json["preferred_delivery_method_id"] == null
            ? null
            : json["preferred_delivery_method_id"],
        preferredDeliveryMethodName:
            json["preferred_delivery_method_name"] == null
                ? null
                : json["preferred_delivery_method_name"],
        id: json["id"] == null ? null : json["id"],
        phone: json["phone"] == null ? null : json["phone"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        type: json["type"] == null ? null : json["type"],
        street1: json["street1"] == null ? null : json["street1"],
        street2: json["name"] == null ? null : json["name"],
        city: json["city"] == null ? null : json["city"],
        state: json["state"] == null ? null : json["state"],
        country: json["country"] == null ? null : json["country"],
        showPricing:
            json["show_pricing"] == null ? false : json["show_pricing"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "partner_id": partnerId == null ? null : partnerId,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "is_logged_in": isLoggedIn == null ? null : isLoggedIn,
        "price_list_id": priceListId == null ? null : priceListId,
        "price_list_name": priceListName == null ? null : priceListName,
        "payment_term_id": paymentTermId == null ? null : paymentTermId,
        "payment_term_name": paymentTermName == null ? null : paymentTermName,
        "preferred_delivery_method_id": preferredDeliveryMethodId == null
            ? null
            : preferredDeliveryMethodId,
        "preferred_delivery_method_name": preferredDeliveryMethodName == null
            ? null
            : preferredDeliveryMethodName,
        "id": id == null ? null : id,
        "show_pricing": showPricing
      };
}
