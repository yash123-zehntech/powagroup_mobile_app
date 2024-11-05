import 'package:hive/hive.dart';
part 'tax_model.g.dart';

@HiveType(typeId: 34)
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
  @HiveField(0)
  int? id;
    @HiveField(1)
  String? name;
     @HiveField(2)
  double? amount;
     @HiveField(3)
  double? base;
     @HiveField(4)
  int? sequence;
     @HiveField(5)
  int? accountId;
     @HiveField(6)
  bool? analytic;
     @HiveField(7)
  bool? priceInclude;
    @HiveField(8)
  String? taxExigibility;
   @HiveField(9)
  int? taxRepartitionLineId;
   @HiveField(10)
  dynamic group;
  @HiveField(11)
  List<int>? tagIds;
  @HiveField(12)
  List<dynamic>? taxIds;

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        id: json["id"],
        name: json["name"],
        amount: json["amount"].toDouble(),
        base: json["base"].toDouble(),
        sequence: json["sequence"],
        accountId: json["account_id"],
        analytic: json["analytic"],
        priceInclude: json["price_include"],
        taxExigibility: json["tax_exigibility"],
        taxRepartitionLineId: json["tax_repartition_line_id"],
        group: json["group"],
        tagIds: List<int>.from(json["tag_ids"].map((x) => x)),
        taxIds: List<dynamic>.from(json["tax_ids"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "amount": amount,
        "base": base,
        "sequence": sequence,
        "account_id": accountId,
        "analytic": analytic,
        "price_include": priceInclude,
        "tax_exigibility": taxExigibility,
        "tax_repartition_line_id": taxRepartitionLineId,
        "group": group,
        "tag_ids": List<dynamic>.from(tagIds!.map((x) => x)),
        "tax_ids": List<dynamic>.from(taxIds!.map((x) => x)),
      };
}
