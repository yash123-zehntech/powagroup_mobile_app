import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_subcategory_response.dart';
import 'dart:convert';

import '../../../home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import '../../../quotation_module/response_model/quotation_response.dart';

part 'joblist_hive_model.g.dart';

@HiveType(typeId: 4)
class JobListData {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? jobName;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? jobDate;

  @HiveField(4)
  List<JobListProduct>? productsList;
  @HiveField(5)
  dynamic deliveryEx;
  @HiveField(6)
  dynamic deliveryInc;
  @HiveField(7)
  dynamic deliveryTax;

  JobListData(
      {this.id,
      this.jobName,
      this.description,
      this.jobDate,
      this.productsList,
      this.deliveryEx,
      this.deliveryInc,
      this.deliveryTax});
}

@HiveType(typeId: 43)
class JobListProduct {
  JobListProduct(
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
      // this.dropDownControllerValueForJobList,
      this.yashValue,
      this.priceByQty,
      this.price,
      this.isFav,
      this.controllerForJobList,
      this.deliveryEx,
      this.deliveryInc,
      this.deliveryTax
      // this.selectedQtyValueForJobList
      });

  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? sku;
  @HiveField(3)
  String? saleUom;
  @HiveField(4)
  double? priceUntaxed;
  @HiveField(5)
  double? priceTax;
  @HiveField(6)
  double? priceTotal;
  @HiveField(7)
  double? priceDelivery;
  @HiveField(8)
  List<QtyBreak>? qtyBreaks;
  @HiveField(9)
  String? mainImageUrl;
  @HiveField(10)
  List<dynamic>? extraImages;
  @HiveField(11)
  String? description;
  @HiveField(12)
  bool? isFav;

  @HiveField(13)
  String? yashValue;

  @HiveField(15)
  String? priceByQty;
  @HiveField(16)
  String? price;
  @HiveField(17)
  dynamic deliveryEx;
  @HiveField(18)
  dynamic deliveryInc;
  @HiveField(19)
  dynamic deliveryTax;

  @HiveType(typeId: 45)
  TextEditingController? controllerForJobList = TextEditingController();

  factory JobListProduct.fromJson(Map<String, dynamic> json) => JobListProduct(
        id: json["id"],
        name: json["name"].toString(),
        sku: json["sku"].toString(),
        saleUom: json["sale_uom"].toString(),
        priceUntaxed: json["price_untaxed"].toDouble(),
        priceTax: json["price_tax"].toDouble(),
        priceTotal: json["price_total"].toDouble(),
        priceDelivery: json["price_delivery"],
        qtyBreaks: List<QtyBreak>.from(
            json["qty_breaks"].map((x) => QtyBreak.fromJson(x))),
        mainImageUrl: json["main_image_url"].toString(),
        extraImages: List<dynamic>.from(json["extra_images"].map((x) => x)),
        description: json["description"].toString(),
        // dropDownControllerValueForJobList: TextEditingController(text: ''),
        priceByQty: "0",
        price: json["price"] == null ? null : json["price"],
        isFav: json["is_fav"] == null ? null : json["is_fav"],
        deliveryEx: json["delivery_ex"],
        deliveryInc: json["delivery_inc"],
        deliveryTax: json["delivery_tax"],
        // selectedQtyValueForJobList:
        //     json["selectedQtyValueForJobList"].toString()
      );

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
        "price": price == null ? null : price,
        "is_fav": isFav == null ? null : isFav,
        "delivery_ex": deliveryEx,
        "delivery_inc": deliveryInc,
        "delivery_tax": deliveryTax
        // "selectedQtyValueForJobList": selectedQtyValueForJobList.toString()
      };
}
