import 'package:hive/hive.dart';

import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/address_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/customer_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/delivery_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/invoice_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/site_contact_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/shipping_details_model.dart';

import '../../sales_order_detail_module/response_model.dart/line_model.dart';
part 'orderlist.model.g.dart';

@HiveType(typeId: 13)
// class Order {
//   Order(
//       {this.id,
//       this.name,
//       this.orderDate,
//       this.expiryDate,
//       this.customerId,
//       this.customerName,
//       this.amountTotal,
//       this.state,
//       this.isExpand});
//   @HiveField(0)
//   int? id;
//   @HiveField(1)
//   String? name;
//   @HiveField(2)
//   String? orderDate;
//   @HiveField(3)
//   dynamic expiryDate;
//   @HiveField(4)
//   int? customerId;
//   @HiveField(5)
//   String? customerName;
//   @HiveField(6)
//   double? amountTotal;
//   @HiveField(7)
//   String? state;
//   @HiveField(8)
//   bool? isExpand = false;

//   factory Order.fromJson(Map<String, dynamic> json) => Order(
//         id: json["id"],
//         name: json["name"],
//         orderDate: json["order_date"],
//         expiryDate: json["expiry_date"],
//         customerId: json["customer_id"],
//         customerName: json["customer_name"],
//         amountTotal: json["amount_total"].toDouble(),
//         state: json["state"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "order_date": orderDate,
//         "expiry_date": expiryDate,
//         "customer_id": customerId,
//         "customer_name": customerName,
//         "amount_total": amountTotal,
//         "state": state,
//       };
// }

class Order {
  Order(
      {this.id,
      this.name,
      this.customerId,
      this.customerName,
      this.customer,
      this.invoiceAddress,
      this.shippingAddress,
      this.siteContact,
      this.orderDate,
      this.expiryDate,
      this.paymentStatus,
      this.shippingStatus,
      this.shippingDetails,
      this.state,
      this.invoices,
      this.deliveries,
      this.deliveryEx,
      this.subtotalExDelivery,
      this.tax,
      this.subtotal,
      this.total,
      this.isExpand,
      this.lines});
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  int? customerId;
  @HiveField(3)
  String? customerName;
  @HiveField(4)
  Customer? customer;
  @HiveField(5)
  Address? invoiceAddress;
  @HiveField(6)
  Address? shippingAddress;
  @HiveField(7)
  SiteContact? siteContact;
  @HiveField(8)
  String? orderDate;
  @HiveField(9)
  String? expiryDate;
  @HiveField(10)
  String? paymentStatus;
  @HiveField(11)
  String? shippingStatus;
  @HiveField(12)
  ShippingDetails? shippingDetails;
  @HiveField(13)
  String? state;
  @HiveField(14)
  List<Invoice>? invoices;
  @HiveField(15)
  List<Delivery>? deliveries;
  @HiveField(16)
  double? deliveryEx;
  @HiveField(17)
  double? subtotalExDelivery;
  @HiveField(18)
  double? tax;
  @HiveField(19)
  double? subtotal;
  @HiveField(20)
  double? total;
  @HiveField(21)
  bool? isExpand = false;
  @HiveField(22)
  List<Line>? lines;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        name: json["name"],
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        customer: Customer.fromJson(json["customer"]),
        invoiceAddress: Address.fromJson(json["invoice_address"]),
        shippingAddress: Address.fromJson(json["shipping_address"]),
        siteContact: SiteContact.fromJson(json["site_contact"]),
        orderDate: json["order_date"],
        expiryDate: json["expiry_date"],
        paymentStatus: json["payment_status"],
        shippingStatus: json["shipping_status"],
        shippingDetails: ShippingDetails.fromJson(json['shipping_details']),
        state: json["state"],
        invoices: List<Invoice>.from(
            json["invoices"].map((x) => Invoice.fromJson(x))),
        deliveries: List<Delivery>.from(
            json["deliveries"].map((x) => Delivery.fromJson(x))),
        deliveryEx: json["delivery_ex"].toDouble() ?? '',
        subtotalExDelivery: json["subtotal_ex_delivery"].toDouble() ?? '',
        tax: json["tax"].toDouble() ?? '',
        subtotal: json["subtotal"].toDouble() ?? '',
        total: json["total"].toDouble() ?? '',
        // lines: List<Line>.from(
        //   json["lines"].map((x) => Line.fromJson(x)),
        // ),
        lines: json["lines"] == null
            ? []
            : List<Line>.from(json["lines"]!.map((x) => Line.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "customer_id": customerId,
        "customer_name": customerName,
        "customer": customer!.toJson(),
        "invoice_address": invoiceAddress!.toJson(),
        "shipping_address": shippingAddress!.toJson(),
        "site_contact": siteContact!.toJson(),
        "order_date": orderDate,
        "expiry_date": expiryDate,
        "payment_status": paymentStatus,
        "shipping_status": shippingStatus,
        "shipping_details": shippingDetails,
        "state": state,
        "invoices": List<dynamic>.from(invoices!.map((x) => x.toJson())),
        "deliveries": List<dynamic>.from(deliveries!.map((x) => x.toJson())),
        "delivery_ex": deliveryEx,
        "subtotal_ex_delivery": subtotalExDelivery,
        "tax": tax,
        "subtotal": subtotal,
        "total": total,
        "lines": lines == null
            ? []
            : List<dynamic>.from(lines!.map((x) => x.toJson())),
      };
}
