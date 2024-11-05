import 'package:hive/hive.dart';
part 'delivery_model.g.dart';

@HiveType(typeId: 30)

class Delivery {
  Delivery({
    this.deliveryId,
    this.deliveryNumber,
    this.status,
    this.pdfUrl,
  });
@HiveField(0)
  int? deliveryId;
  @HiveField(1)
  String? deliveryNumber;
   @HiveField(2)
  String? status;
   @HiveField(3)
  String? pdfUrl;

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        deliveryId: json["delivery_id"],
        deliveryNumber: json["delivery_number"],
        status: json["status"],
        pdfUrl: json["pdf_url"],
      );

  Map<String, dynamic> toJson() => {
        "delivery_id": deliveryId,
        "delivery_number": deliveryNumber,
        "status": status,
        "pdf_url": pdfUrl,
      };
}
