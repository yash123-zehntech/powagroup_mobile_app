// To parse this JSON data, do
//
//     final createOrderResponse = createOrderResponseFromJson(jsonString);

import 'dart:convert';

CreateOrderResponse createOrderResponseFromJson(String str) =>
    CreateOrderResponse.fromJson(json.decode(str));

String createOrderResponseToJson(CreateOrderResponse data) =>
    json.encode(data.toJson());

class CreateOrderResponse {
  CreateOrderResponse(
      {this.jsonrpc, this.id, this.result, this.error, this.statusCode});

  String? jsonrpc;
  dynamic id;
  Result? result;
  String? error;
  dynamic statusCode;

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) =>
      CreateOrderResponse(
        jsonrpc: json["jsonrpc"] == null ? null : json["jsonrpc"],
        id: json["id"] == null ? null : json["id"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc == null ? null : jsonrpc,
        "id": id == null ? null : id,
        "result": result == null ? null : result!.toJson(),
      };
}

class Result {
  Result(
      {this.id,
      this.name,
      this.customerId,
      this.customerName,
      this.customer,
      this.paymentTermId,
      this.paymentTermName,
      this.invoiceAddress,
      this.shippingAddress,
      this.siteContact,
      this.orderDate,
      this.expiryDate,
      this.paymentStatus,
      this.shippingStatus,
      this.state,
      this.invoices,
      this.deliveries,
      this.deliveryEx,
      this.subtotalExDelivery,
      this.tax,
      this.subtotal,
      this.total,
      this.pdfUrl,
      this.lines,
      this.warehouseId,
      this.warehouseName,
      this.paymentMethods});

  dynamic id;
  String? name;
  dynamic customerId;
  String? customerName;
  Customer? customer;
  int? paymentTermId;
  String? paymentTermName;
  Address? invoiceAddress;
  Address? shippingAddress;

  Customer? siteContact;
  String? orderDate;
  String? expiryDate;
  String? paymentStatus;
  String? shippingStatus;
  String? state;
  List<dynamic>? invoices;
  List<dynamic>? deliveries;
  dynamic deliveryEx;
  double? subtotalExDelivery;
  double? tax;
  double? subtotal;
  double? total;
  String? pdfUrl;
  List<Line>? lines;
  int? warehouseId;
  String? warehouseName;
  List<PaymentMethod>? paymentMethods;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        customerId: json["customer_id"] == null ? null : json["customer_id"],
        customerName:
            json["customer_name"] == null ? null : json["customer_name"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        paymentTermId:
            json["payment_term_id"] == null ? null : json["payment_term_id"],
        paymentTermName: json["payment_term_name"] == null
            ? null
            : json["payment_term_name"],
        invoiceAddress: json["invoice_address"] == null
            ? null
            : Address.fromJson(json["invoice_address"]),
        shippingAddress: json["shipping_address"] == null
            ? null
            : Address.fromJson(json["shipping_address"]),
        siteContact: json["site_contact"] == null
            ? null
            : Customer.fromJson(json["site_contact"]),
        orderDate: json["order_date"] == null ? null : json["order_date"],
        expiryDate: json["expiry_date"] == null ? null : json["expiry_date"],
        paymentStatus:
            json["payment_status"] == null ? null : json["payment_status"],
        shippingStatus:
            json["shipping_status"] == null ? null : json["shipping_status"],
        state: json["state"] == null ? null : json["state"],
        invoices: json["invoices"] == null
            ? null
            : List<dynamic>.from(json["invoices"].map((x) => x)),
        deliveries: json["deliveries"] == null
            ? null
            : List<dynamic>.from(json["deliveries"].map((x) => x)),
        deliveryEx: json["delivery_ex"] == null ? null : json["delivery_ex"],
        subtotalExDelivery: json["subtotal_ex_delivery"] == null
            ? null
            : json["subtotal_ex_delivery"].toDouble(),
        tax: json["tax"] == null ? null : json["tax"].toDouble(),
        subtotal: json["subtotal"] == null ? null : json["subtotal"].toDouble(),
        total: json["total"] == null ? null : json["total"].toDouble(),
        pdfUrl: json["pdf_url"] == null ? null : json["pdf_url"],
        lines: json["lines"] == null
            ? null
            : List<Line>.from(json["lines"].map((x) => Line.fromJson(x))),
        warehouseId: json["warehouse_id"],
        warehouseName: json["warehouse_name"],
        paymentMethods: json["payment_methods"] == null
            ? []
            : List<PaymentMethod>.from(
                json["payment_methods"]!.map((x) => PaymentMethod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "customer_id": customerId == null ? null : customerId,
        "customer_name": customerName == null ? null : customerName,
        "customer": customer == null ? null : customer!.toJson(),
        "payment_term_id": paymentTermId == null ? null : paymentTermId,
        "payment_term_name": paymentTermName == null ? null : paymentTermName,
        "invoice_address":
            invoiceAddress == null ? null : invoiceAddress!.toJson(),
        "shipping_address":
            shippingAddress == null ? null : shippingAddress!.toJson(),
        "site_contact": siteContact == null ? null : siteContact!.toJson(),
        "order_date": orderDate == null ? null : orderDate,
        "expiry_date": expiryDate == null ? null : expiryDate,
        "payment_status": paymentStatus == null ? null : paymentStatus,
        "shipping_status": shippingStatus == null ? null : shippingStatus,
        "state": state == null ? null : state,
        "invoices": invoices == null
            ? null
            : List<dynamic>.from(invoices!.map((x) => x)),
        "deliveries": deliveries == null
            ? null
            : List<dynamic>.from(deliveries!.map((x) => x)),
        "delivery_ex": deliveryEx == null ? null : deliveryEx,
        "subtotal_ex_delivery":
            subtotalExDelivery == null ? null : subtotalExDelivery,
        "tax": tax == null ? null : tax,
        "subtotal": subtotal == null ? null : subtotal,
        "total": total == null ? null : total,
        "pdf_url": pdfUrl == null ? null : pdfUrl,
        "lines": lines == null
            ? null
            : List<dynamic>.from(lines!.map((x) => x.toJson())),
        "warehouse_id": warehouseId,
        "warehouse_name": warehouseName,
        "payment_methods": paymentMethods == null
            ? []
            : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
      };
}

class Customer {
  Customer({
    this.id,
    this.name,
    this.email,
    this.type,
  });

  dynamic? id;
  String? name;
  String? email;
  String? type;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "type": type == null ? null : type,
      };
}

class Address {
  Address({
    this.id,
    this.name,
    this.email,
    this.type,
    this.street1,
    this.street2,
    this.city,
    this.state,
    this.country,
  });

  dynamic? id;
  String? name;
  String? email;
  String? type;
  String? street1;
  String? street2;
  String? city;
  String? state;
  String? country;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        type: json["type"] == null ? null : json["type"],
        street1: json["street1"] == null ? null : json["street1"],
        street2: json["street2"] == null ? null : json["street2"],
        city: json["city"] == null ? null : json["city"],
        state: json["state"] == null ? null : json["state"],
        country: json["country"] == null ? null : json["country"],
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
      };
}

class Line {
  Line({
    this.id,
    this.description,
    this.qty,
    this.uom,
    this.unitPriceEx,
    this.subtotal,
    this.total,
  });

  dynamic? id;
  String? description;
  dynamic? qty;
  String? uom;
  UnitPriceEx? unitPriceEx;
  double? subtotal;
  double? total;

  factory Line.fromJson(Map<String, dynamic> json) => Line(
        id: json["id"] == null ? null : json["id"],
        description: json["description"] == null ? null : json["description"],
        qty: json["qty"] == null ? null : json["qty"],
        uom: json["uom"] == null ? null : json["uom"],
        unitPriceEx: json["unit_price_ex"] == null
            ? null
            : UnitPriceEx.fromJson(json["unit_price_ex"]),
        subtotal: json["subtotal"] == null ? null : json["subtotal"].toDouble(),
        total: json["total"] == null ? null : json["total"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "description": description == null ? null : description,
        "qty": qty == null ? null : qty,
        "uom": uom == null ? null : uom,
        "unit_price_ex": unitPriceEx == null ? null : unitPriceEx!.toJson(),
        "subtotal": subtotal == null ? null : subtotal,
        "total": total == null ? null : total,
      };
}

class UnitPriceEx {
  UnitPriceEx({
    this.baseTags,
    this.taxes,
    this.totalExcluded,
    this.totalIncluded,
    this.totalVoid,
  });

  List<dynamic>? baseTags;
  List<Tax>? taxes;
  double? totalExcluded;
  double? totalIncluded;
  double? totalVoid;

  factory UnitPriceEx.fromJson(Map<String, dynamic> json) => UnitPriceEx(
        baseTags: json["base_tags"] == null
            ? null
            : List<dynamic>.from(json["base_tags"].map((x) => x)),
        taxes: json["taxes"] == null
            ? null
            : List<Tax>.from(json["taxes"].map((x) => Tax.fromJson(x))),
        totalExcluded: json["total_excluded"] == null
            ? null
            : json["total_excluded"].toDouble(),
        totalIncluded: json["total_included"] == null
            ? null
            : json["total_included"].toDouble(),
        totalVoid:
            json["total_void"] == null ? null : json["total_void"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "base_tags": baseTags == null
            ? null
            : List<dynamic>.from(baseTags!.map((x) => x)),
        "taxes": taxes == null
            ? null
            : List<dynamic>.from(taxes!.map((x) => x.toJson())),
        "total_excluded": totalExcluded == null ? null : totalExcluded,
        "total_included": totalIncluded == null ? null : totalIncluded,
        "total_void": totalVoid == null ? null : totalVoid,
      };
}

class Tax {
  Tax({
    this.id,
    this.name,
    this.amount,
    this.base,
    this.sequence,
    this.accountId,
    this.analytic,
    this.priceInclude,
    this.taxExigibility,
    this.taxRepartitionLineId,
    this.group,
    this.tagIds,
    this.taxIds,
  });

  dynamic? id;
  String? name;
  double? amount;
  double? base;
  dynamic? sequence;
  dynamic? accountId;
  bool? analytic;
  bool? priceInclude;
  String? taxExigibility;
  dynamic? taxRepartitionLineId;
  dynamic group;
  List<dynamic>? tagIds;
  List<dynamic>? taxIds;

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        amount: json["amount"] == null ? null : json["amount"].toDouble(),
        base: json["base"] == null ? null : json["base"].toDouble(),
        sequence: json["sequence"] == null ? null : json["sequence"],
        accountId: json["account_id"] == null ? null : json["account_id"],
        analytic: json["analytic"] == null ? null : json["analytic"],
        priceInclude:
            json["price_include"] == null ? null : json["price_include"],
        taxExigibility:
            json["tax_exigibility"] == null ? null : json["tax_exigibility"],
        taxRepartitionLineId: json["tax_repartition_line_id"] == null
            ? null
            : json["tax_repartition_line_id"],
        group: json["group"],
        tagIds: json["tag_ids"] == null
            ? null
            : List<dynamic>.from(json["tag_ids"].map((x) => x)),
        taxIds: json["tax_ids"] == null
            ? null
            : List<dynamic>.from(json["tax_ids"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "amount": amount == null ? null : amount,
        "base": base == null ? null : base,
        "sequence": sequence == null ? null : sequence,
        "account_id": accountId == null ? null : accountId,
        "analytic": analytic == null ? null : analytic,
        "price_include": priceInclude == null ? null : priceInclude,
        "tax_exigibility": taxExigibility == null ? null : taxExigibility,
        "tax_repartition_line_id":
            taxRepartitionLineId == null ? null : taxRepartitionLineId,
        "group": group,
        "tag_ids":
            tagIds == null ? null : List<dynamic>.from(tagIds!.map((x) => x)),
        "tax_ids":
            taxIds == null ? null : List<dynamic>.from(taxIds!.map((x) => x)),
      };
}

class PaymentMethod {
  int? id;
  String? type;
  String? name;

  PaymentMethod({
    this.id,
    this.type,
    this.name,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["id"],
        type: json["type"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
      };
}
