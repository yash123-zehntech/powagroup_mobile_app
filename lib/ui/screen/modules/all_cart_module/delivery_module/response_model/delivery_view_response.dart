import 'package:hive/hive.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_info.dart';
// part 'delivery_view_response.g.dart';

class DeliveryAddressResponse {
  DeliveryAddressResponse(
      {this.deliveryAddressInfo, this.error, this.statusCode});

  List<DeliveryInfo>? deliveryAddressInfo;

  String? error;
  int? statusCode;
}

// @HiveType(typeId: 19)
// class DeliveryInfo {
//   DeliveryInfo(
//       {this.id,
//       this.name,
//       this.email,
//       this.type,
//       this.street1,
//       this.street2,
//       this.city,
//       this.state,
//       this.country,
//       required this.selected,
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
//   bool selected = false;

//   @HiveField(10)
//   String? completeAddress;

//   factory DeliveryInfo.fromJson(Map<String, dynamic> json) =>
//       DeliveryInfo(
//           id: json["id"] == null ? null : json["id"],
//           name: json["name"] == null ? null : json["name"],
//           email: json["email"] == null ? null : json["email"],
//           type: json["type"] == null ? null : json["type"],
//           street1: json["street1"] == null ? null : json["street1"],
//           street2: json["street2"] == null ? null : json["street2"],
//           city: json["city"] == null ? null : json["city"],
//           state: json["state"] == null ? null : json["state"],
//           country: json["country"] == null ? null : json["country"],
//           selected: false);

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "name": name == null ? null : name,
//         "email": email == null ? null : email,
//         "type": type == null ? null : type,
//         "street1": street1 == null ? null : street1,
//         "street2": street2 == null ? null : street2,
//         "city": city == null ? null : city,
//         "state": state == null ? null : state,
//         "country": country == null ? null : country,
//       };
// }
