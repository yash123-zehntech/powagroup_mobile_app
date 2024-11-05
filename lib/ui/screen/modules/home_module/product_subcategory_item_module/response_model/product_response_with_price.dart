// To parse this JSON data, do
//
//     final productResponseWithPrice = productResponseWithPriceFromJson(jsonString);

import 'dart:convert';

ProductResponseWithPrice productResponseWithPriceFromJson(String str) => ProductResponseWithPrice.fromJson(json.decode(str));

String productResponseWithPriceToJson(ProductResponseWithPrice data) => json.encode(data.toJson());

class ProductResponseWithPrice {
    String? jsonrpc;
    dynamic id;
    String? result;
    int? statusCode;
    String? error;

    ProductResponseWithPrice({
        this.jsonrpc,
        this.id,
        this.result,
        this.statusCode,
        this.error
    });

    factory ProductResponseWithPrice.fromJson(Map<String, dynamic> json) => ProductResponseWithPrice(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: json["result"],
    );

    Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result,
    };
}
