// To parse this JSON data, do
//
//     final getOrderTotalsResponse = getOrderTotalsResponseFromJson(jsonString);

import 'dart:convert';

GetOrderTotalsResponse getOrderTotalsResponseFromJson(String str) =>
    GetOrderTotalsResponse.fromJson(json.decode(str));

String getOrderTotalsResponseToJson(GetOrderTotalsResponse data) =>
    json.encode(data.toJson());

class GetOrderTotalsResponse {
  String? result;
  int? statusCode;
  String? error;
  double? itemTotalEx;
  double? itemTotalInc;
  double? itemTotalTax;
  double? deliveryEx;
  double? deliveryInc;
  double? deliveryTax;
  double? totalEx;
  double? totalInc;
  double? totalTax;

  GetOrderTotalsResponse({
    this.result,
    this.statusCode,
    this.error,
    this.itemTotalEx,
    this.itemTotalInc,
    this.itemTotalTax,
    this.deliveryEx,
    this.deliveryInc,
    this.deliveryTax,
    this.totalEx,
    this.totalInc,
    this.totalTax,
  });

  factory GetOrderTotalsResponse.fromJson(Map<String, dynamic> json) =>
      GetOrderTotalsResponse(
        itemTotalEx: json["item_total_ex"]?.toDouble(),
        itemTotalInc: json["item_total_inc"]?.toDouble(),
        itemTotalTax: json["item_total_tax"]?.toDouble(),
        deliveryEx: json["delivery_ex"]?.toDouble(),
        deliveryInc: json["delivery_inc"]?.toDouble(),
        deliveryTax: json["delivery_tax"]?.toDouble(),
        totalEx: json["total_ex"]?.toDouble(),
        totalInc: json["total_inc"]?.toDouble(),
        totalTax: json["total_tax"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "item_total_ex": itemTotalEx,
        "item_total_inc": itemTotalInc,
        "item_total_tax": itemTotalTax,
        "delivery_ex": deliveryEx,
        "delivery_inc": deliveryInc,
        "delivery_tax": deliveryTax,
        "total_ex": totalEx,
        "total_inc": totalInc,
        "total_tax": totalTax,
      };
}
