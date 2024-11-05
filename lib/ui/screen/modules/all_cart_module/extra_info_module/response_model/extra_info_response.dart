import 'dart:convert';

import 'package:hive/hive.dart';
part 'extra_info_response.g.dart';

ExtraInfoDataResponse ExtraInfoDataResponseFromJson(String str) =>
    ExtraInfoDataResponse.fromJson(json.decode(str));

String ExtraInfoDataResponseToJson(ExtraInfoDataResponse data) =>
    json.encode(data.toJson());

class ExtraInfoDataResponse {
  ExtraInfoDataResponse({this.error, this.statusCode});

  String? error;
  int? statusCode;

  factory ExtraInfoDataResponse.fromJson(Map<String, dynamic> json) =>
      ExtraInfoDataResponse();

  Map<String, dynamic> toJson() => {};
}

@HiveType(typeId: 15)
class ExtraInfoData {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? siteContect;

  @HiveField(2)
  String? refernceNumber;

  @HiveField(3)
  String? deliveryNotes;

  @HiveField(4)
  String? officialPurchesOrder;

  @HiveField(5)
  String? zipCode;

  @HiveField(6)
  String? country;

  @HiveField(7)
  String? stateProvice;

  @HiveField(8)
  String? imagePath;

  @HiveField(9)
  String? warehouseId;

  @HiveField(10)
  String? warehouseName;

  ExtraInfoData(
      {this.id,
      this.siteContect,
      this.refernceNumber,
      this.deliveryNotes,
      this.officialPurchesOrder,
      this.zipCode,
      this.country,
      this.stateProvice,
      this.imagePath,
      this.warehouseId,
      this.warehouseName});
}
