// To parse this JSON data, do
//
//     final warehousesResponse = warehousesResponseFromJson(jsonString);

import 'dart:convert';

WarehousesResponse warehousesResponseFromJson(String str) => WarehousesResponse.fromJson(json.decode(str));

String warehousesResponseToJson(WarehousesResponse data) => json.encode(data.toJson());

class WarehousesResponse {
    List<Warehouse>? warehouses;
    int? statusCode;
    String? error;


    WarehousesResponse({
        this.warehouses,
        this.statusCode,
        this.error
    });

    factory WarehousesResponse.fromJson(Map<String, dynamic> json) => WarehousesResponse(
        warehouses: json["warehouses"] == null ? [] : List<Warehouse>.from(json["warehouses"]!.map((x) => Warehouse.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "warehouses": warehouses == null ? [] : List<dynamic>.from(warehouses!.map((x) => x.toJson())),
    };
}

class Warehouse {
    int? id;
    String? name;

    Warehouse({
        this.id,
        this.name,
    });

    factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
