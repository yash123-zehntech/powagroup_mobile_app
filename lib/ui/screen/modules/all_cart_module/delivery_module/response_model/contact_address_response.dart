import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/contact_info.dart';

class ContactAddressResponse {
  ContactAddressResponse(
      {this.contactAddressInfo, this.error, this.statusCode});

  List<ContactInfo>? contactAddressInfo;

  String? error;
  int? statusCode;
}