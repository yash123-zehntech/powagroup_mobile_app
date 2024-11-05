import 'package:hive/hive.dart';
import 'package:powagroup/ui/screen/modules/sales_order_detail_module/response_model.dart/unitprice_model.dart';
part 'line_model.g.dart';

@HiveType(typeId: 27)
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
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? description;
  @HiveField(2)
  dynamic qty;
  @HiveField(3)
  String? uom;
  @HiveField(4)
  UnitPriceEx? unitPriceEx;
  @HiveField(5)
  double? subtotal;
  @HiveField(6)
  double? total;

  factory Line.fromJson(Map<String, dynamic> json) => Line(
        id: json["id"],
        description: json["description"],
        qty: json["qty"],
        uom: json["uom"],
        unitPriceEx: UnitPriceEx.fromJson(json["unit_price_ex"]),
        subtotal: json["subtotal"].toDouble(),
        total: json["total"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "qty": qty,
        "uom": uom,
        "unit_price_ex": unitPriceEx!.toJson(),
        "subtotal": subtotal,
        "total": total,
      };
}
