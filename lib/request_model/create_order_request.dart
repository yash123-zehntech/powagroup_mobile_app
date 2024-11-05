import 'package:flutter/material.dart';

class CreateOrderRequest {
  String? deliveryCharges;
  String? shippingAddressId;
  String? billingAddressId;
  String? siteContactId;
  String? deliveryNotes;
  String? referenceNumber;
  List<CartProduct>? list = List.empty(growable: true);
  int? deliveryMethod;
  bool? payOnAccount;
  int? warehouseId;

  CreateOrderRequest(
      {this.deliveryCharges,
      this.shippingAddressId,
      this.billingAddressId,
      this.siteContactId,
      this.deliveryNotes,
      this.list,
      this.deliveryMethod,
      this.payOnAccount,
      this.warehouseId});

  Map<String, dynamic> toJson() => {
        "delivery_charges": deliveryCharges == null ? null : deliveryCharges,
        "shipping_address":
            shippingAddressId == null ? null : shippingAddressId,
        "billing_contact": billingAddressId == null ? null : billingAddressId,
        "site_contact": siteContactId == null ? null : siteContactId,
        "deliveryNotes": deliveryNotes == null ? null : deliveryNotes,
        "referenceNumber": referenceNumber == null ? null : referenceNumber,
        "product_list": list == null ? null : list,
        "delivery_method": deliveryMethod == null ? null : deliveryMethod,
        "pay_on_account": payOnAccount == null ? false : payOnAccount,
        "warehouse_id": warehouseId == null ? null : warehouseId
      };
}

class CartProduct {
  int? id;
  int? quantity;

  CartProduct({this.id, this.quantity});

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "qty": quantity == null ? null : quantity,
      };
}
