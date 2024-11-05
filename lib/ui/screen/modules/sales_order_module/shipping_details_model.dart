import 'package:hive/hive.dart';
part 'shipping_details_model.g.dart';

@HiveType(typeId: 50)
class ShippingDetails {
  ShippingDetails(
      {this.name,
      this.driverName,
      this.arrivalTimePlanned,
      this.arrivalTimeCompleted,
      this.status,
      this.failReason,
      this.failComment,
      this.currentPosition,
      this.longitude,
      this.latitude});
  @HiveField(0)
  dynamic name;
  @HiveField(1)
  String? driverName;
  @HiveField(2)
  String? arrivalTimePlanned;
  @HiveField(3)
  String? arrivalTimeCompleted;
  @HiveField(4)
  String? status;
  @HiveField(5)
  String? failReason;
  @HiveField(6)
  String? failComment;
  @HiveField(7)
  String? currentPosition;
  @HiveField(8)
  dynamic longitude;
  @HiveField(9)
  dynamic latitude;

  factory ShippingDetails.fromJson(Map<String, dynamic> json) =>
      ShippingDetails(
          name: json["name"],
          driverName: json["driver_name"],
          arrivalTimePlanned: json["arrival_time_planned"],
          arrivalTimeCompleted: json["arrival_time_completed"],
          status: json["status"],
          failReason: json["fail_reason"],
          failComment: json["fail_comment"],
          currentPosition: json["current_position"],
          longitude: json["longitude"],
          latitude: json["latitude"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "driver_name": driverName,
        "arrival_time_planned": arrivalTimePlanned,
        "arrival_time_completed": arrivalTimeCompleted,
        "status": status,
        "fail_reason": failReason,
        "fail_comment": failComment,
        "current_position": currentPosition,
        "longitude": longitude,
        "latitude": latitude
      };
}
