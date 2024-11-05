import 'package:hive/hive.dart';
part 'invoice_model.g.dart';
@HiveType(typeId: 31)
class Invoice {
  Invoice({
    this.invoiceId,
    this.invoiceNumber,
    this.status,
    this.pdfUrl,
  });

  int? invoiceId;
  String? invoiceNumber;
  String? status;
  String? pdfUrl;

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        invoiceId: json["invoice_id"],
        invoiceNumber: json["invoice_number"],
        status: json["status"],
        pdfUrl: json["pdf_url"],
      );

  Map<String, dynamic> toJson() => {
        "invoice_id": invoiceId,
        "invoice_number": invoiceNumber,
        "status": status,
        "pdf_url": pdfUrl,
      };
}
