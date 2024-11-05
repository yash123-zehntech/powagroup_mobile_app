// To parse this JSON data, do
//
//     final productResponseWithPrice = productResponseWithPriceFromJson(jsonString);

import 'dart:convert';

ProductResponseWithPrice productResponseWithPriceFromJson(String str) =>
    ProductResponseWithPrice.fromJson(json.decode(str));

String productResponseWithPriceToJson(ProductResponseWithPrice data) =>
    json.encode(data.toJson());

class ProductResponseWithPrice {
  String? jsonrpc;
  dynamic id;
  Result? result;
  int? stateCode;
  String? error;

  ProductResponseWithPrice(
      {this.jsonrpc, this.id, this.result, this.stateCode, this.error});

  factory ProductResponseWithPrice.fromJson(Map<String, dynamic> json) =>
      ProductResponseWithPrice(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result?.toJson(),
      };
}

class Result {
  List<Product>? products;
  User? user;

  Result({
    this.products,
    this.user,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x))),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
        "user": user?.toJson(),
      };
}

class Product {
  int? id;
  double? priceUntaxed;
  double? priceTax;
  double? priceTotal;
  List<QtyBreak>? qtyBreaks;
  String? saleUom;

  Product({
    this.id,
    this.priceUntaxed,
    this.priceTax,
    this.priceTotal,
    this.qtyBreaks,
    this.saleUom,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        priceUntaxed: json["price_untaxed"]?.toDouble(),
        priceTax: json["price_tax"]?.toDouble(),
        priceTotal: json["price_total"]?.toDouble(),
        qtyBreaks: json["qty_breaks"] == null
            ? []
            : List<QtyBreak>.from(
                json["qty_breaks"]!.map((x) => QtyBreak.fromJson(x))),
        saleUom: json["sale_uom"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price_untaxed": priceUntaxed,
        "price_tax": priceTax,
        "price_total": priceTotal,
        "qty_breaks": qtyBreaks == null
            ? []
            : List<dynamic>.from(qtyBreaks!.map((x) => x.toJson())),
        "sale_uom": saleUom,
      };
}

class QtyBreak {
  String? qty;
  double? price;

  QtyBreak({
    this.qty,
    this.price,
  });

  factory QtyBreak.fromJson(Map<String, dynamic> json) => QtyBreak(
        qty: json["qty"],
        price: json["price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "qty": qty,
        "price": price,
      };
}

class User {
  int? userId;
  int? partnerId;
  bool? isLoggedIn;
  int? priceListId;
  String? priceListName;
  int? paymentTermId;
  String? paymentTermName;
  bool? preferredDeliveryMethodId;
  bool? preferredDeliveryMethodName;
  int? id;
  String? name;
  String? email;
  String? phone;
  String? mobile;
  String? type;
  String? street1;
  String? street2;
  String? city;
  String? state;
  String? country;

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

  factory User.fromJson(Map<String, dynamic> json) => User(
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

  Map<String, dynamic> toJson() => {
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
