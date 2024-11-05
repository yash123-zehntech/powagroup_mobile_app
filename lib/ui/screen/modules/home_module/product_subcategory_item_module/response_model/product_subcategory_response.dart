// /// To parse this JSON data, do
// //
// //     final ProductSubCategoriesItemsResponse = ProductSubCategoriesItemsResponseFromJson(jsondynamic);

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// part 'product_subcategory_response.g.dart';

// ProductSubCategoriesItemsResponse ProductSubCategoriesItemsResponseFromJson(
//         dynamic str) =>
//     ProductSubCategoriesItemsResponse.fromJson(json.decode(str));

// dynamic ProductSubCategoriesItemsResponseToJson(
//         ProductSubCategoriesItemsResponse data) =>
//     json.encode(data.toJson());

// class ProductSubCategoriesItemsResponse {
//   ProductSubCategoriesItemsResponse(
//       {this.products, this.user, this.error, this.statusCode});

//   List<Product>? products;
//   User? user;
//   dynamic error;
//   dynamic statusCode;

//   factory ProductSubCategoriesItemsResponse.fromJson(
//           Map<dynamic, dynamic> json) =>
//       ProductSubCategoriesItemsResponse(
//         products: json["products"] == null
//             ? null
//             : List<Product>.from(
//                 json["products"].map((x) => Product.fromJson(x))),
//         user: json["user"] == null ? null : User.fromJson(json["user"]),
//       );

//   Map<dynamic, dynamic> toJson() => {
//         "products": products == null
//             ? null
//             : List<dynamic>.from(products.map((x) => x.toJson())),
//         "user": user == null ? null : user.toJson(),
//       };
// }

// @HiveType(typeId: 12)
// class Product {
//   Product(
//       {this.id,
//       this.name,
//       this.sku,
//       this.saleUom,
//       this.priceUntaxed,
//       this.priceTax,
//       this.priceTotal,
//       this.priceDelivery,
//       this.qtyBreaks,
//       this.mainImageUrl,
//       this.extraImages,
//       this.description,
//       // this.dropDownController,
//       this.priceByQty,
//       this.price,
//       this.isFav});

//   @HiveField(0)
//   dynamic id;
//   @HiveField(1)
//   dynamic name;
//   @HiveField(2)
//   dynamic sku;
//   @HiveField(3)
//   dynamic saleUom;
//   @HiveField(4)
//   double? priceUntaxed;
//   @HiveField(5)
//   double? priceTax;
//   @HiveField(6)
//   double? priceTotal;
//   @HiveField(7)
//   dynamic priceDelivery;
//   @HiveField(8)
//   List<QtyBreak>? qtyBreaks;
//   @HiveField(9)
//   dynamic mainImageUrl;
//   @HiveField(10)
//   List<dynamic>? extraImages;
//   @HiveField(11)
//   dynamic description;
//   // @HiveField(12)
//   // TextEditingController? dropDownController = TextEditingController(text: '');

//   @HiveField(13)
//   dynamic priceByQty;
//   @HiveField(14)
//   dynamic price;
//   @HiveField(15)
//   dynamic isFav;

//   factory Product.fromJson(Map<dynamic, dynamic> json) => Product(
//         id: json["id"],
//         name: json["name"],
//         sku: json["sku"],
//         saleUom: json["sale_uom"],
//         priceUntaxed: json["price_untaxed"].toDouble(),
//         priceTax: json["price_tax"].toDouble(),
//         priceTotal: json["price_total"].toDouble(),
//         priceDelivery: json["price_delivery"],
//         qtyBreaks: List<QtyBreak>.from(
//             json["qty_breaks"].map((x) => QtyBreak.fromJson(x))),
//         mainImageUrl: json["main_image_url"],
//         extraImages: List<dynamic>.from(json["extra_images"].map((x) => x)),
//         description: json["description"],
//         // dropDownController: TextEditingController(text: ''),
//         priceByQty: "0",
//         price: json["price"] == null ? null : json["price"],
//         isFav: json["is_fav"] == null ? null : json["is_fav"],
//       );

//   Map<dynamic, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "sku": sku,
//         "sale_uom": saleUom,
//         "price_untaxed": priceUntaxed,
//         "price_tax": priceTax,
//         "price_total": priceTotal,
//         "price_delivery": priceDelivery,
//         "qty_breaks": List<dynamic>.from(qtyBreaks.map((x) => x.toJson())),
//         "main_image_url": mainImageUrl,
//         "extra_images": List<dynamic>.from(extraImages.map((x) => x)),
//         "description": description,
//         "price": price == null ? null : price,
//         "is_fav": isFav == null ? null : isFav,
//       };
// }

// @HiveType(typeId: 2)
// class QtyBreak {
//   QtyBreak({
//     this.qty,
//     this.price,
//     this.initialValue,
//   });

//   @HiveField(0)
//   dynamic qty;

//   @HiveField(1)
//   double? price;

//   @HiveField(2)
//   dynamic initialValue;

//   factory QtyBreak.fromJson(Map<dynamic, dynamic> json) => QtyBreak(
//         qty: json["qty"] == null ? null : json["qty"],
//         price: json["price"] == null ? null : json["price"],
//       );

//   Map<dynamic, dynamic> toJson() => {
//         "qty": qty == null ? null : qty,
//         "price": price == null ? null : price,
//       };
// }

// class User {
//   User({
//     this.userId,
//     this.partnerId,
//     this.name,
//     this.email,
//     this.isLoggedIn,
//   });

//   dynamic userId;
//   dynamic partnerId;
//   dynamic name;
//   dynamic email;
//   dynamic isLoggedIn;

//   factory User.fromJson(Map<dynamic, dynamic> json) => User(
//         userId: json["user_id"] == null ? null : json["user_id"],
//         partnerId: json["partner_id"] == null ? null : json["partner_id"],
//         name: json["name"] == null ? null : json["name"],
//         email: json["email"] == null ? null : json["email"],
//         isLoggedIn: json["is_logged_in"] == null ? null : json["is_logged_in"],
//       );

//   Map<dynamic, dynamic> toJson() => {
//         "user_id": userId == null ? null : userId,
//         "partner_id": partnerId == null ? null : partnerId,
//         "name": name == null ? null : name,
//         "email": email == null ? null : email,
//         "is_logged_in": isLoggedIn == null ? null : isLoggedIn,
//       };
// }

import 'dart:convert';

import 'package:hive/hive.dart';
part 'product_subcategory_response.g.dart';

class ProductSubCategoriesItemsResponse {
  List<Product>? products;
  User? user;
  int? statusCode;
  dynamic error;
  ProductSubCategoriesItemsResponse? productResult;
  dynamic delivery_ex;
  dynamic delivery_inc;
  dynamic delivery_tax;
  dynamic id;

  ProductSubCategoriesItemsResponse(
      {this.products,
      this.user,
      this.statusCode,
      this.error,
      this.productResult,
      this.delivery_ex,
      this.delivery_inc,
      this.delivery_tax,
      this.id});

  factory ProductSubCategoriesItemsResponse.fromRawJson(dynamic str) =>
      ProductSubCategoriesItemsResponse.fromJson(json.decode(str));

  dynamic toRawJson() => json.encode(toJson());

  factory ProductSubCategoriesItemsResponse.fromJson(
          Map<String, dynamic> json) =>
      ProductSubCategoriesItemsResponse(
        // products: json["products"] == null
        //     ? []
        //     : List<Product>.from(
        //         json["products"].map((x) => Product.fromJson(x))),
        products: json["products"] == null
            ? []
            : List<Product>.from(
                (json["products"] as List<dynamic>)
                    .map((x) => Product.fromJson(x)),
              ),

        user: json["user"] == null ? null : User.fromJson(json["user"]),
        delivery_ex: json["delivery_ex"],
        delivery_inc: json["delivery_inc"],
        delivery_tax: json["delivery_tax"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
        "user": user?.toJson(),
        "delivery_ex": delivery_ex,
        "delivery_inc": delivery_inc,
        "delivery_tax": delivery_tax,
        "id": id,
      };
}

@HiveType(typeId: 12)
class Product {
  @HiveField(0)
  dynamic id;
  @HiveField(1)
  dynamic name;
  @HiveField(2)
  dynamic sku;
  @HiveField(3)
  dynamic saleUom;
  @HiveField(4)
  double? priceUntaxed;
  @HiveField(5)
  double? priceTax;
  @HiveField(6)
  double? priceTotal;
  @HiveField(7)
  dynamic priceDelivery;
  @HiveField(8)
  List<QtyBreak>? qtyBreaks;
  @HiveField(9)
  dynamic mainImageUrl;
  @HiveField(10)
  List<dynamic>? extraImages;
  @HiveField(11)
  dynamic description;
  @HiveField(12)
  List<dynamic>? alternativeProducts;
  @HiveField(13)
  List<dynamic>? accessoryProducts;
  @HiveField(14)
  dynamic isFav;
  @HiveField(15)
  double? reviewAvg;
  @HiveField(16)
  dynamic totalReviewCount;
  @HiveField(17)
  dynamic deliveryEx;
  @HiveField(18)
  dynamic deliveryInc;
  @HiveField(19)
  dynamic deliveryTax;

  Product(
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
      this.isFav,
      this.reviewAvg,
      this.totalReviewCount,
      this.deliveryEx,
      this.deliveryInc,
      this.deliveryTax});

  factory Product.fromRawJson(dynamic str) =>
      Product.fromJson(json.decode(str));

  dynamic toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<dynamic, dynamic> json) => Product(
        id: json["id"],
        name: json["name"] ?? "",
        sku: json["sku"],
        saleUom: json["sale_uom"],
        priceUntaxed: json["price_untaxed"]?.toDouble(),
        priceTax: json["price_tax"]?.toDouble(),
        priceTotal: json["price_total"]?.toDouble(),
        priceDelivery: json["price_delivery"],
        qtyBreaks: json["qty_breaks"] == null
            ? []
            : List<QtyBreak>.from(
                json["qty_breaks"].map((x) => QtyBreak.fromJson(x))),
        mainImageUrl: json["main_image_url"],
        extraImages: json["extra_images"] == null
            ? []
            : List<dynamic>.from(json["extra_images"].map((x) => x)),
        description: json["description"],
        alternativeProducts: json["alternative_products"] == null
            ? []
            : List<dynamic>.from(json["alternative_products"].map((x) => x)),
        accessoryProducts: json["accessory_products"] == null
            ? []
            : List<dynamic>.from(json["accessory_products"].map((x) => x)),
        isFav: json["is_fav"],
        reviewAvg: json["review_avg"],
        totalReviewCount: json["total_review_count"],
        deliveryEx: json["delivery_ex"],
        deliveryInc: json["delivery_inc"],
        deliveryTax: json["delivery_tax"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sku": sku,
        "sale_uom": saleUom,
        "price_untaxed": priceUntaxed,
        "price_tax": priceTax,
        "price_total": priceTotal,
        "price_delivery": priceDelivery,
        "qty_breaks": qtyBreaks == null
            ? []
            : List<dynamic>.from(qtyBreaks!.map((x) => x.toJson())),
        "main_image_url": mainImageUrl,
        "extra_images": extraImages == null
            ? []
            : List<dynamic>.from(extraImages!.map((x) => x)),
        "description": description,
        "alternative_products": alternativeProducts == null
            ? []
            : List<dynamic>.from(alternativeProducts!.map((x) => x)),
        "accessory_products": accessoryProducts == null
            ? []
            : List<dynamic>.from(accessoryProducts!.map((x) => x)),
        "is_fav": isFav,
        "review_avg": reviewAvg,
        "total_review_count": totalReviewCount,
        "delivery_ex": deliveryEx,
        "delivery_inc": deliveryInc,
        "delivery_tax": deliveryTax
      };
}

@HiveType(typeId: 2)
class QtyBreak {
  @HiveField(0)
  dynamic qty;
  @HiveField(1)
  double? price;

  QtyBreak({
    this.qty,
    this.price,
  });

  factory QtyBreak.fromRawJson(dynamic str) =>
      QtyBreak.fromJson(json.decode(str));

  dynamic toRawJson() => json.encode(toJson());

  factory QtyBreak.fromJson(Map<dynamic, dynamic> json) => QtyBreak(
        qty: json["qty"],
        price: json["price"]?.toDouble(),
      );

  Map<dynamic, dynamic> toJson() => {
        "qty": qty,
        "price": price,
      };
}

class User {
  dynamic userId;
  dynamic partnerId;
  dynamic isLoggedIn;
  dynamic priceListId;
  dynamic priceListName;
  dynamic paymentTermId;
  dynamic paymentTermName;
  dynamic preferredDeliveryMethodId;
  dynamic preferredDeliveryMethodName;
  dynamic id;
  dynamic name;
  dynamic email;
  dynamic phone;
  dynamic mobile;
  dynamic type;
  dynamic street1;
  dynamic street2;
  dynamic city;
  dynamic state;
  dynamic country;

  User({
    this.userId,
    this.partnerId,
    this.isLoggedIn,
    this.priceListId,
    this.priceListName,
    this.paymentTermId,
    this.paymentTermName,
    this.preferredDeliveryMethodId,
    this.preferredDeliveryMethodName,
    this.id,
    this.name,
    this.email,
    this.phone,
    this.mobile,
    this.type,
    this.street1,
    this.street2,
    this.city,
    this.state,
    this.country,
  });

  factory User.fromRawJson(dynamic str) => User.fromJson(json.decode(str));

  dynamic toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<dynamic, dynamic> json) => User(
        userId: json["user_id"],
        partnerId: json["partner_id"],
        isLoggedIn: json["is_logged_in"],
        priceListId: json["price_list_id"],
        priceListName: json["price_list_name"],
        paymentTermId: json["payment_term_id"],
        paymentTermName: json["payment_term_name"],
        preferredDeliveryMethodId: json["preferred_delivery_method_id"],
        preferredDeliveryMethodName: json["preferred_delivery_method_name"],
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        mobile: json["mobile"],
        type: json["type"],
        street1: json["street1"],
        street2: json["street2"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
      );

  Map<dynamic, dynamic> toJson() => {
        "user_id": userId,
        "partner_id": partnerId,
        "is_logged_in": isLoggedIn,
        "price_list_id": priceListId,
        "price_list_name": priceListName,
        "payment_term_id": paymentTermId,
        "payment_term_name": paymentTermName,
        "preferred_delivery_method_id": preferredDeliveryMethodId,
        "preferred_delivery_method_name": preferredDeliveryMethodName,
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "mobile": mobile,
        "type": type,
        "street1": street1,
        "street2": street2,
        "city": city,
        "state": state,
        "country": country,
      };
}
