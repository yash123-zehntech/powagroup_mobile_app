import 'package:flutter/material.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/helper_widget/network_error%20widget.dart';
import 'package:powagroup/services/globals.dart';
import 'package:powagroup/ui/screen/modules/address_module/response_model/address_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/confirm_order_module/confirm_order_view.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/delivery_view.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/contact_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/invoice_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/invoice_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/extra_info_module/extra_info_view.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/extra_info_module/response_model/extra_info_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/extra_info_module/response_model/sitecontact_info_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/review_module/review_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/site_contact_model.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../../util/shared_preference.dart';
import '../../home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import '../../../../../services/hive_db_services.dart';
import '../../../../../util/constant.dart';
import '../delivery_module/response_model/delivery_view_response.dart';

class CartViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  bool _isEnabled = false;
  bool _extraInfo = false;
  List<ProductData> _checkCardboardList = [];
  List<DeliveryInfo> _checkDeliveryList = [];
  List<InvoiceInfo> _checkInvoiceList = [];
  List<ContactInfo> _checkContactList = [];

  List<AddressData> _shippingAddressList = List.empty(growable: true);
  List<AddressData> _billingAddressList = List.empty(growable: true);
  bool get isEnabled => _isEnabled;

  get viewModel => null;
  set isEnabled(bool isEnabled) {
    _isEnabled = isEnabled;
    notifyListeners();
  }

  bool get extraInfo => _extraInfo;
  set extraInfo(bool extraInfo) {
    _extraInfo = extraInfo;
    notifyListeners();
  }

  List<ProductData> get checkCardboardList => _checkCardboardList;

  set checkCardboardList(List<ProductData> checkCardboardList) {
    _checkCardboardList = checkCardboardList;
    notifyListeners();
  }

  List<DeliveryInfo> get checkDeliveryList => _checkDeliveryList;

  set checkDeliveryList(List<DeliveryInfo> checkDeliveryList) {
    _checkDeliveryList = checkDeliveryList;
    notifyListeners();
  }

  List<InvoiceInfo> get checkInvoiceList => _checkInvoiceList;

  set checkInvoiceList(List<InvoiceInfo> checkInvoiceList) {
    _checkInvoiceList = checkInvoiceList;
    notifyListeners();
  }

  List<ContactInfo> get checkContactList => _checkContactList;

  set checkContactList(List<ContactInfo> checkContactList) {
    _checkContactList = checkContactList;
    notifyListeners();
  }

  int _index = 0;

  int get index => _index;

  set index(int index) {
    _index = index;
    notifyListeners();
  }

  List<ProductData> _cartProductList = List.empty(growable: true);

  List<ProductData> get cartProductList => _cartProductList;
  set cartProductList(List<ProductData> cartProductList) {
    _cartProductList = cartProductList;
    notifyListeners();
  }

  List<AddressData> _addressList = List.empty(growable: true);

  List<AddressData> get addressList => _addressList;
  set addressList(List<AddressData> addressList) {
    _addressList = addressList;
    notifyListeners();
  }

  ExtraInfoData? _information = new ExtraInfoData();

  ExtraInfoData? get information => _information;
  set information(ExtraInfoData? information) {
    _information = information;
    notifyListeners();
  }

  List<AddressData> get shippingAddressList => _shippingAddressList;

  set shippingAddressList(List<AddressData> shippingAddressList) {
    _shippingAddressList = shippingAddressList;
    notifyListeners();
  }

  List<AddressData> get billingAddressList => _billingAddressList;

  set billingAddressList(List<AddressData> billingAddressList) {
    _billingAddressList = billingAddressList;
    notifyListeners();
  }

  bool _setShippandBill = false;
  bool get setShippandBill => _setShippandBill;
  set setShippandBill(bool setShippandBill) {
    _setShippandBill = setShippandBill;
    notifyListeners();
  }

  Widget? getBody(
    int index,
    List<ProductData> cartProductList,

  ) {
    switch (index) {
      case 0:
        return ReviewPage(
          value: Globals.value,
        );
      case 1:
        return DeliveryPage();
      case 2:
        return ExtraInfoView(
          deliveryAddressId: Globals.id,
        );

      case 3:
        return const ConfirmOrderPage();

      default:
        return ReviewPage(
          value: Globals.value,
        );
    }
  }

  getAddressList(List<AddressData> addressListss) async {
    if (addressListss != null && addressListss.isNotEmpty) {
      shippingAddressList = addressListss
          .where((element) => element.addressType == "Shipping Address")
          .toList();

      billingAddressList = addressListss
          .where((element) => element.addressType == "Billing Address")
          .toList();
    }
    notifyListeners();
  }

  // on login buttion clik
  onItemClick(String value) {}
  bool _isPickup = false;

  bool get isPickup => _isPickup;
  set isPickup(bool isPickup) {
    _isPickup = isPickup;
    notifyListeners();
  }

  checkpickupValue() async {
    var value = await SharedPre.getStringValue(SharedPre.ISPICKUP);

    if (value == '0') {
      isPickup = true;
    } else {
      isPickup = false;
    }
  }
}
