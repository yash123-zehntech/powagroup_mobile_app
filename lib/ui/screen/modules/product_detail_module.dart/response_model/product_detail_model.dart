// To parse this JSON data, do
//
//     final productSubDetailModel = productSubDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_subcategory_response.dart';
part 'product_detail_model.g.dart';

ProductSubDetailModel productSubDetailModelFromJson(String str) =>
    ProductSubDetailModel.fromJson(json.decode(str));

String productSubDetailModelToJson(ProductSubDetailModel data) =>
    json.encode(data.toJson());

class ProductSubDetailModel {
  ProductSubDetailModel(
      {this.product,
      this.error,
      this.statusCode,
      this.productResult,
      this.delivery_ex,
      this.delivery_inc,
      this.delivery_tax});

  ProductDetailsData? product;

  String? error;
  int? statusCode;
  ProductSubDetailModel? productResult;
  dynamic delivery_ex;
  dynamic delivery_inc;
  dynamic delivery_tax;

  factory ProductSubDetailModel.fromJson(Map<String, dynamic> json) =>
      ProductSubDetailModel(
        product: json["product"] == null
            ? null
            : ProductDetailsData.fromJson(json["product"]),
        delivery_ex: json["delivery_ex"],
        delivery_inc: json["delivery_inc"],
        delivery_tax: json["delivery_tax"],
      );

  Map<String, dynamic> toJson() => {
        "product": product!.toJson(),
        "delivery_ex": delivery_ex,
        "delivery_inc": delivery_inc,
        "delivery_tax": delivery_tax,
      };
}

@HiveType(typeId: 6)
class ProductDetailsData {
  ProductDetailsData(
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
      this.alternativeProducts,
      this.accessoryProducts,
      //this.dropDownController,
      this.yashValue,
      this.priceByQty,
      this.price,
      this.isFav,
      //this.selectedQtyValueInProductDetails,
      this.reviewAvg,
      this.totalReviewCount,
      this.deliveryEx,
      this.deliveryInc,
      this.deliveryTax});
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
  int? priceDelivery;
  @HiveField(8)
  List<QtyBreak>? qtyBreaks;
  @HiveField(9)
  String? mainImageUrl;
  @HiveField(10)
  List<dynamic>? extraImages;
  @HiveField(11)
  String? description;
  @HiveField(12)
  List<AlternativeProduct>? alternativeProducts;
  @HiveField(13)
  List<AccessoryProduct>? accessoryProducts;

  // @HiveType(typeId: 29)
  // TextEditingController? dropDownController = TextEditingController(text: "");

  @HiveField(14)
  String? yashValue;

  @HiveField(15)
  double? priceByQty;
  @HiveField(16)
  int? price;

  @HiveField(17)
  bool? isFav;

  // @HiveField(18)
  // String? selectedQtyValueInProductDetails;

  // is_fav
  double? reviewAvg;
  @HiveField(19)
  int? totalReviewCount;
  @HiveField(20)
  dynamic deliveryEx;
  @HiveField(21)
  dynamic deliveryInc;
  @HiveField(22)
  dynamic deliveryTax;

  // factory ProductDetailsData.fromJson(Map<String, dynamic> json) =>
  //     ProductDetailsData(
  //       id: json["id"],
  //       name: json["name"],
  //       sku: json["sku"],
  //       saleUom: json["sale_uom"],
  //       priceUntaxed: json["price_untaxed"].toDouble(),
  //       priceTax: json["price_tax"].toDouble(),
  //       priceTotal: json["price_total"].toDouble(),
  //       priceDelivery: json["price_delivery"],
  //       qtyBreaks: List<QtyBreak>.from(
  //           json["qty_breaks"].map((x) => QtyBreak.fromJson(x))),
  //       mainImageUrl: json["main_image_url"],
  //       extraImages: List<dynamic>.from(json["extra_images"].map((x) => x)),
  //       description: json["description"],
  //       alternativeProducts: List<AlternativeProduct>.from(
  //           json["alternative_products"]
  //               .map((x) => AlternativeProduct.fromJson(x))),
  //       accessoryProducts: List<AccessoryProduct>.from(
  //           json["accessory_products"]
  //               .map((x) => AccessoryProduct.fromJson(x))),
  //       //dropDownController: TextEditingController(text: ''),
  //       // priceByQty: 0,
  //       priceByQty:
  //           json["priceByQty"] == null ? null : json["priceByQty"].toDouble(),
  //       price: json["price"] == null ? null : json["price"],
  //       isFav: json["is_fav"] == null ? null : json["is_fav"],
  //       reviewAvg: json["review_avg"].toDouble(),
  //       totalReviewCount: json["total_review_count"],
  //       deliveryEx: json["delivery_ex"],
  //       deliveryInc: json["delivery_inc"],
  //       deliveryTax: json["delivery_tax"],
  //     );
  factory ProductDetailsData.fromJson(Map<String, dynamic> json) =>
      ProductDetailsData(
        id: json["id"],
        name: json["name"],
        sku: json["sku"],
        saleUom: json["sale_uom"].runtimeType == bool ? "" : json["sale_uom"],
        priceUntaxed: json["price_untaxed"] != null
            ? json["price_untaxed"].toDouble()
            : null,
        priceTax:
            json["price_tax"] != null ? json["price_tax"].toDouble() : null,
        priceTotal:
            json["price_total"] != null ? json["price_total"].toDouble() : null,
        priceDelivery: json["price_delivery"],
        qtyBreaks: json["qty_breaks"] != null
            ? List<QtyBreak>.from(
                json["qty_breaks"].map((x) => QtyBreak.fromJson(x)))
            : null,
        mainImageUrl: json["main_image_url"],
        extraImages: json["extra_images"] != null
            ? List<dynamic>.from(json["extra_images"].map((x) => x))
            : null,
        description: json["description"],
        alternativeProducts: json["alternative_products"] != null
            ? List<AlternativeProduct>.from(json["alternative_products"]
                .map((x) => AlternativeProduct.fromJson(x)))
            : null,
        accessoryProducts: json["accessory_products"] != null
            ? List<AccessoryProduct>.from(json["accessory_products"]
                .map((x) => AccessoryProduct.fromJson(x)))
            : null,
        priceByQty:
            json["priceByQty"] != null ? json["priceByQty"].toDouble() : null,
        price: json["price"],
        isFav: json["is_fav"],
        reviewAvg:
            json["review_avg"] != null ? json["review_avg"].toDouble() : null,
        totalReviewCount: json["total_review_count"],
        deliveryEx: json["delivery_ex"],
        deliveryInc: json["delivery_inc"],
        deliveryTax: json["delivery_tax"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sku": sku,
        "sale_uom": saleUom,
        "price_untaxed": priceUntaxed,
        "price_tax": priceTax,
        "price_total": priceTotal,
        "price_delivery": priceDelivery,
        "qty_breaks": List<dynamic>.from(qtyBreaks!.map((x) => x.toJson())),
        "main_image_url": mainImageUrl,
        "extra_images": List<dynamic>.from(extraImages!.map((x) => x)),
        "description": description,
        "alternative_products": List<AlternativeProduct>.from(
            alternativeProducts!.map((x) => x.toJson())),
        // List<AlternativeProduct>.from(alternativeProducts!.map((x) => x)),
        "accessory_products": List<AccessoryProduct>.from(
            accessoryProducts!.map((x) => x.toJson())),
        "priceByQty": priceByQty == null ? null : priceByQty,
        "price": price == null ? null : price,
        "is_fav": isFav == null ? null : isFav,
        "review_avg": reviewAvg,
        "total_review_count": totalReviewCount,
        "delivery_ex": deliveryEx,
        "delivery_inc": deliveryInc,
        "delivery_tax": deliveryTax
      };
}

// @HiveType(typeId: 6)
// class ProductDetailsData {
//   ProductDetailsData({
//     this.id,
//     this.name,
//     this.sku,
//     this.description,
//     this.alternativeProducts,
//     this.accessoryProducts,
//   });

//   @HiveField(0)
//   int? id;

//   @HiveField(1)
//   String? name;

//   @HiveField(2)
//   String? sku;

//   @HiveField(3)
//   String? description;

//   @HiveField(4)
//   List<AlternativeProduct>? alternativeProducts;

//   @HiveField(5)
//   List<AccessoryProduct>? accessoryProducts;

//   factory ProductDetailsData.fromJson(Map<String, dynamic> json) => ProductDetailsData(
//         id: json["id"],
//         name: json["name"].toString(),
//         sku: json["sku"].toString(),
//         description: json["description"].toString(),
// alternativeProducts: List<AlternativeProduct>.from(
//     json["alternative_products"].map((x) => x)),
// accessoryProducts: List<AccessoryProduct>.from(
//     json["accessory_products"]
//         .map((x) => AccessoryProduct.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "sku": sku,
//         "description": description,
//         "alternative_products":
//             List<dynamic>.from(alternativeProducts!.map((x) => x)),
//         "accessory_products":
//             List<dynamic>.from(accessoryProducts!.map((x) => x.toJson())),
//       };
// }

@HiveType(typeId: 7)
class AccessoryProduct {
  AccessoryProduct({
    this.id,
    this.name,
    this.defaultCode,
    this.mainImageUrl,
  });

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? defaultCode;

  @HiveField(3)
  String? mainImageUrl;

  factory AccessoryProduct.fromJson(Map<String, dynamic> json) =>
      AccessoryProduct(
        id: json["id"],
        name: json["name"],
        defaultCode: json["default_code"],
        mainImageUrl: json["main_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "default_code": defaultCode,
        "main_image_url": mainImageUrl,
      };
}

@HiveType(typeId: 8)
class AlternativeProduct {
  AlternativeProduct({
    this.id,
    this.name,
    this.defaultCode,
    this.mainImageUrl,
  });

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? defaultCode;

  @HiveField(3)
  String? mainImageUrl;

  factory AlternativeProduct.fromJson(Map<String, dynamic> json) =>
      AlternativeProduct(
        id: json["id"],
        name: json["name"].toString(),
        defaultCode: json["default_code"],
        mainImageUrl: json["main_image_url"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name.toString(),
        "default_code": defaultCode,
        "main_image_url": mainImageUrl.toString(),
      };
}
