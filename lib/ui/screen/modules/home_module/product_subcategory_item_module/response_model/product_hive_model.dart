import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_subcategory_response.dart';
part 'product_hive_model.g.dart';

@HiveType(typeId: 3)
class SubCategoryData {
  @HiveField(0)
  String? subCategoryId;

  @HiveField(1)
  List<ProductData>? productsList;

  SubCategoryData({this.subCategoryId, this.productsList});

  factory SubCategoryData.fromJson(Map<String, dynamic> json) =>
      SubCategoryData(
        subCategoryId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": subCategoryId,
      };
}

@HiveType(typeId: 1)
class ProductData {
  ProductData(
      {this.id,
      this.name,
      this.sku,
      this.saleUom,
      this.priceUntaxed,
      this.priceTax,
      this.priceTotal,
      this.priceDelivery,
      this.qtyBreaks,
      this.mainImageUrl,
      this.extraImages,
      this.description,
      this.yashValue,
      this.priceByQty,
      this.price,
      this.isFav,
      this.controllerForCart,
      this.deliveryEx,
      this.deliveryInc,
      this.deliveryTax,
      this.userId});

  @HiveField(0)
  int? id = 0;
  @HiveField(1)
  String? name = "";
  @HiveField(2)
  String? sku = "";
  @HiveField(3)
  String? saleUom = "";
  @HiveField(4)
  double? priceUntaxed = 0.0;
  @HiveField(5)
  double? priceTax = 0.0;
  @HiveField(6)
  double? priceTotal = 0.0;
  @HiveField(7)
  double? priceDelivery = 0.0;
  @HiveField(8)
  List<QtyBreak>? qtyBreaks = [];
  @HiveField(9)
  String? mainImageUrl = "";
  @HiveField(10)
  List<dynamic>? extraImages = [];
  @HiveField(11)
  String? description = "";
  @HiveField(12)
  bool? isFav = false;

  @HiveField(13)
  String? yashValue = "";

  @HiveField(15)
  String? priceByQty = "";
  @HiveField(16)
  String? price = "";
  @HiveField(17)
  dynamic deliveryEx;
  @HiveField(18)
  dynamic deliveryInc;
  @HiveField(19)
  dynamic deliveryTax;
  @HiveField(20)
  int? userId;

  @HiveType(typeId: 44)
  TextEditingController? controllerForCart = TextEditingController(text: '');

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
      id: json["id"],
      name: json["name"].toString(),
      sku: json["sku"].toString(),
      saleUom: json["sale_uom"].toString(),
      priceUntaxed: json["price_untaxed"] != null
          ? json["price_untaxed"].toDouble()
          : 0.0,
      priceTax: json["price_tax"] != null ? json["price_tax"].toDouble() : 0.0,
      priceTotal:
          json["price_total"] != null ? json["price_total"].toDouble() : 0.0,
      priceDelivery: json["price_delivery"],
      qtyBreaks: json["qty_breaks"] != null
          ? List<QtyBreak>.from(
              json["qty_breaks"].map((x) => QtyBreak.fromJson(x)))
          : [],
      mainImageUrl: json["main_image_url"].toString(),
      extraImages: List<dynamic>.from(json["extra_images"].map((x) => x)),
      description: json["description"].toString(),
      priceByQty: "0",
      price: json["price"] == null ? "" : json["price"],
      isFav: json["is_fav"] ?? false,
      deliveryEx: json["delivery_ex"],
      deliveryInc: json["delivery_inc"],
      deliveryTax: json["delivery_tax"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name.toString(),
        "sku": sku.toString(),
        "sale_uom": saleUom.toString(),
        "price_untaxed": priceUntaxed,
        "price_tax": priceTax,
        "price_total": priceTotal,
        "price_delivery": priceDelivery,
        "qty_breaks": List<dynamic>.from(qtyBreaks!.map((x) => x.toJson())),
        "main_image_url": mainImageUrl.toString(),
        "extra_images": List<dynamic>.from(extraImages!.map((x) => x)),
        "description": description.toString(),
        "price": price == null ? "" : price,
        "is_fav": isFav == null ? false : isFav,
        "delivery_ex": deliveryEx,
        "delivery_inc": deliveryInc,
        "delivery_tax": deliveryTax
      };
}
