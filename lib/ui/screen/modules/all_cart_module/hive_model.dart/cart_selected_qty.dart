import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'cart_selected_qty.dart';
part 'cart_selected_qty.g.dart';

@HiveType(typeId: 40)
class CartSelectedValue {
  @HiveField(0)
  int? productId;

  @HiveField(1)
  String? qty;

  CartSelectedValue({this.productId, this.qty});
}
