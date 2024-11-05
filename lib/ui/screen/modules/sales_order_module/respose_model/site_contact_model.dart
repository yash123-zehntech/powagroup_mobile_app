import 'package:hive/hive.dart';
part 'site_contact_model.g.dart';
@HiveType(typeId: 33)
class SiteContact {
  SiteContact({
    this.id,
    this.name,
    this.email,
    this.type,
  });
@HiveField(0)
  dynamic id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? type;

  factory SiteContact.fromJson(Map<String, dynamic> json) => SiteContact(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "type": type,
      };
}
