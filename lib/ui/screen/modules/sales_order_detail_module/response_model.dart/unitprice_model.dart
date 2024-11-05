import 'package:hive/hive.dart';
import 'package:powagroup/ui/screen/modules/sales_order_detail_module/response_model.dart/tax_model.dart';
part 'unitprice_model.g.dart';

@HiveType(typeId: 35)
class UnitPriceEx {
  UnitPriceEx({
    this.baseTags,
    this.taxes,
    this.totalExcluded,
    this.totalIncluded,
    this.totalVoid,
  });
  @HiveField(0)
  List<int>? baseTags;
  @HiveField(1)
  List<Tax>? taxes;
  @HiveField(2)
  double? totalExcluded;
  @HiveField(3)
  double? totalIncluded;
  @HiveField(4)
  double? totalVoid;

  factory UnitPriceEx.fromJson(Map<String, dynamic> json) => UnitPriceEx(
        baseTags: List<int>.from(json["base_tags"].map((x) => x)),
        taxes: List<Tax>.from(json["taxes"].map((x) => Tax.fromJson(x))),
        totalExcluded: json["total_excluded"].toDouble(),
        totalIncluded: json["total_included"].toDouble(),
        totalVoid: json["total_void"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "base_tags": List<dynamic>.from(baseTags!.map((x) => x)),
        "taxes": List<dynamic>.from(taxes!.map((x) => x.toJson())),
        "total_excluded": totalExcluded,
        "total_included": totalIncluded,
        "total_void": totalVoid,
      };
}
