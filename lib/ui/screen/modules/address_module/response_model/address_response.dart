import 'package:hive/hive.dart';
part 'address_response.g.dart';

@HiveType(typeId: 5)
class AddressData {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? addressName;

  @HiveField(2)
  String? emailAddress;

  @HiveField(3)
  String? mobileNumber;

  @HiveField(4)
  String? streetNameNumber;

  @HiveField(5)
  String? streetNameOther;

  @HiveField(6)
  String? code;

  @HiveField(7)
  String? country;

  @HiveField(8)
  String? state;

  @HiveField(9)
  String? city;

  @HiveField(10)
  String? siteContactPhoneNumber;

  @HiveField(11)
  String? addressType;

  @HiveField(12)
  String? completeAddress;

  @HiveField(13)
  bool isSelect = false;

  AddressData(
      {this.id,
      this.addressName,
      this.emailAddress,
      this.mobileNumber,
      this.streetNameNumber,
      this.streetNameOther,
      this.code,
      this.country,
      this.state,
      this.city,
      this.siteContactPhoneNumber,
      this.addressType,
      this.completeAddress,
      required this.isSelect});

  Map<String, dynamic> toJson() => {
        "name": addressName == null ? null : addressName,
        "email": emailAddress == null ? null : emailAddress,
        "phone": mobileNumber == null ? null : mobileNumber,
        "mobile": mobileNumber == null ? null : mobileNumber,
        "type": addressType == null ? null : addressType,
        "street": streetNameNumber == null ? null : streetNameNumber,
        "street2": streetNameOther == null ? null : streetNameOther,
        "city": city == null ? null : city,
        "state": state == null ? false : state,
        "country": country == null ? false : country
      };
}
