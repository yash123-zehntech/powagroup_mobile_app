// To parse this JSON data, do
//
//     final deliveryMethodsResponse = deliveryMethodsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
part 'delivery_methods_response.g.dart';

// import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';

DeliveryMethodsResponse deliveryMethodsResponseFromJson(String str) =>
    DeliveryMethodsResponse.fromJson(json.decode(str));

String deliveryMethodsResponseToJson(DeliveryMethodsResponse data) =>
    json.encode(data.toJson());

class DeliveryMethodsResponse {
  String? jsonrpc;
  dynamic id;
  String? result;
  int? statusCode;
  String? error;
  DeliveryMethodsResponse? deliveryMethodsResult;
  List<DeliveryMethod>? products;

  DeliveryMethodsResponse(
      {this.jsonrpc,
      this.id,
      this.result,
      this.statusCode,
      this.error,
      this.deliveryMethodsResult,
      this.products});

  factory DeliveryMethodsResponse.fromJson(Map<String, dynamic> json) =>
      DeliveryMethodsResponse(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: json["result"],
        products: List<DeliveryMethod>.from(
            json["delivery_methods"].map((x) => DeliveryMethod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result,
        "delivery_methods":
            List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 51)
class DeliveryMethod {
  DeliveryMethod(
      {this.id,
      this.description,
      this.name,
      this.deliveryEx,
      this.deliveryInc,
      this.deliveryTax,
      this.pickup,
      this.isSelected});

  @HiveField(0)
  int? id;
  @HiveField(1)
  String? description;
  @HiveField(2)
  String? name;
  @HiveField(3)
  dynamic deliveryEx;
  @HiveField(4)
  dynamic deliveryInc;
  @HiveField(5)
  dynamic deliveryTax;
  @HiveField(6)
  bool? pickup;
  @HiveField(7)
  bool? isSelected = false;

  factory DeliveryMethod.fromJson(Map<String, dynamic> json) => DeliveryMethod(
        id: json["id"],
        description: json["description"],
        name: json["name"],
        deliveryEx: json["delivery_ex"],
        deliveryInc: json["delivery_inc"],
        deliveryTax: json["delivery_tax"],
        pickup: json["pickup"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "name": name,
        "delivery_ex": deliveryEx,
        "delivery_inc": deliveryInc,
        "delivery_tax": deliveryTax,
        "pickup": pickup,
      };
}
