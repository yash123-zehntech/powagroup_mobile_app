import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/invoice_info.dart';

class InvoiceAddressResponse {
  InvoiceAddressResponse(
      {this.invoiceAddressInfo, this.error, this.statusCode});

  List<InvoiceInfo>? invoiceAddressInfo;

  String? error;
  int? statusCode;
}

// @HiveType(typeId: 20)
// class InvoiceInfo {
//   InvoiceInfo(
//       {this.id,
//       this.name,
//       this.email,
//       this.type,
//       this.street1,
//       this.street2,
//       this.city,
//       this.state,
//       this.country,
//       required this.selectedForBilling,
//       this.completeAddress});

//   @HiveField(0)
//   int? id;

//   @HiveField(1)
//   String? name;

//   @HiveField(2)
//   String? email;

//   @HiveField(3)
//   String? type;

//   @HiveField(4)
//   String? street1;

//   @HiveField(5)
//   bool? street2;

//   @HiveField(6)
//   String? city;

//   @HiveField(7)
//   String? state;

//   @HiveField(8)
//   String? country;

//   @HiveField(9)
//   bool selectedForBilling = false;

//   @HiveField(10)
//   String? completeAddress;

//   factory InvoiceInfo.fromJson(Map<String, dynamic> json) =>
//       InvoiceInfo(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         type: json["type"],
//         street1: json["street1"],
//         street2: json["street2"],
//         city: json["city"],
//         state: json["state"],
//         country: json["country"],
//         selectedForBilling: false,
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "type": type,
//         "street1": street1,
//         "street2": street2,
//         "city": city,
//         "state": state,
//         "country": country,
//       };
// }
