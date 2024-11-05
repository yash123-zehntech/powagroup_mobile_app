import 'package:hive/hive.dart';
part 'address_model.g.dart';
@HiveType(typeId: 32)
class Address {
  Address({
    this.id,
    this.name,
    this.email,
    this.type,
    this.street1,
    this.street2,
    this.city,
    this.state,
    this.country,
  });
@HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
    @HiveField(2)
  String? email;
      @HiveField(3)
  String? type;
    @HiveField(4)
  String? street1;
    @HiveField(5)
  String? street2;
    @HiveField(6)
  String? city;
    @HiveField(7)
  String? state;
   @HiveField(8)
  String? country;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        type: json["type"],
        street1: json["street1"],
        street2: json["street2"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "type": type,
        "street1": street1,
        "street2": street2,
        "city": city,
        "state": state,
        "country": country,
      };
}
