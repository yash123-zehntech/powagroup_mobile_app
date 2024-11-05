import 'package:hive/hive.dart';
part 'customer_model.g.dart';
// customer_model.dart

@HiveType(typeId: 29)
class Customer {
    Customer({
        this.id,
        this.name,
        this.email,
        this.type,
    });
@HiveField(0)
    int? id;
    @HiveField(1)
    String? name;
    @HiveField(2)
    String? email;
    @HiveField(3)
    String? type;

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
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
