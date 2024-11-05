import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/address_module/address_view.dart';
import 'package:powagroup/ui/screen/modules/address_module/response_model/address_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/cart_module/cart_view.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/contact_address_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/contact_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delete_address_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_view_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/get_order_totals_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/invoice_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/invoice_response.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_page_module/home_page_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../../helper_widget/button_widget.dart';
import '../../../../../helper_widget/end_card_widget.dart';
import '../../../../../util/globleData.dart';
import '../../../../../util/shared_preference.dart';
import 'response_model/delivery_methods_response.dart';

class DeliveryModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  Api apiCall = locator<Api>();
  bool _isAPIError = false;
  double totalPriceOfItem = 0;

  bool get isAPIError => _isAPIError;
  set isAPIError(bool isAPIError) {
    _isAPIError = isAPIError;
    notifyListeners();
  }

  bool _isAlreadyCalled = false;
  bool get isAlreadyCalled => _isAlreadyCalled;

  set isAlreadyCalled(bool isAlreadyCalled) {
    _isAlreadyCalled = isAlreadyCalled;

    try {
      Future.delayed(const Duration(seconds: 4), () {
        notifyListeners();
      });
    } catch (error) {}
  }

  double _deliveryCharge = 0.0;
  double get deliveryCharge => _deliveryCharge;
  set deliveryCharge(double value) {
    _deliveryCharge = value;
    notifyListeners();
  }

  final List<String> cartBoardList = [
    "Review Order",
    "Address",
    "Extra Info",
    "Confirm Order",
  ];

  String _getPickupValue = '';
  String get getPickupValue => _getPickupValue;
  set getPickupValue(String getPickupValue) {
    _getPickupValue = getPickupValue;
    notifyListeners();
  }

  double _productTotalGSTAmount = 0.0;
  double get productTotalGSTAmount => _productTotalGSTAmount;
  set productTotalGSTAmount(double productTotalGSTAmount) {
    _productTotalGSTAmount = productTotalGSTAmount;
    notifyListeners();
  }

  double _totalAmount = 0.0;
  double get totalAmount => _totalAmount;
  set totalAmount(double totalAmount) {
    _totalAmount = totalAmount;
    notifyListeners();
  }

  List<DeliveryMethod> _deliveryMethodsList = List.empty(growable: true);

  List<DeliveryMethod> get deliveryMethodsList => _deliveryMethodsList;

  set deliveryMethodsList(List<DeliveryMethod> deliveryMethodsList) {
    _deliveryMethodsList = deliveryMethodsList;
    notifyListeners();
  }

  List<DeliveryMethod> _deliveryMethodsList1 = List.empty(growable: true);

  List<DeliveryMethod> get deliveryMethodsList1 => _deliveryMethodsList1;

  set deliveryMethodsList1(List<DeliveryMethod> deliveryMethodsList) {
    _deliveryMethodsList1 = deliveryMethodsList1;
    notifyListeners();
  }

  List<DeliveryInfo> _deliveryAddList = List.empty(growable: true);

  List<DeliveryInfo> get deliveryAddList => _deliveryAddList;

  set deliveryAddList(List<DeliveryInfo> deliveryAddList) {
    _deliveryAddList = deliveryAddList;
    notifyListeners();
  }

  List<InvoiceInfo> _invoiceAddList = List.empty(growable: true);

  List<InvoiceInfo> get invoiceAddList => _invoiceAddList;

  set invoiceAddList(List<InvoiceInfo> invoiceAddList) {
    _invoiceAddList = invoiceAddList;
    notifyListeners();
  }

  List<ContactInfo> _contactAddList = List.empty(growable: true);

  List<ContactInfo> get contactAddList => _contactAddList;

  set contactAddList(List<ContactInfo> contactAddList) {
    _contactAddList = contactAddList;
    notifyListeners();
  }

  bool _isCheckbox = false;
  bool get isCheckbox => _isCheckbox;
  set isCheckbox(bool isCheckbox) {
    _isCheckbox = isCheckbox;
    notifyListeners();
  }

  bool _isPickup = false;
  bool get isPickup => _isPickup;
  set isPickup(bool isPickup) {
    _isPickup = isPickup;
    notifyListeners();
  }

  bool _showLoaderForOrderTotal = true;
  bool get showLoaderForOrderTotal => _showLoaderForOrderTotal;
  set showLoaderForOrderTotal(bool value) {
    _showLoaderForOrderTotal = value;
    notifyListeners();
  }

  GetOrderTotalsResponse? _getOrderTotalsResponse;
  GetOrderTotalsResponse? get getOrderTotalsResponse => _getOrderTotalsResponse;
  set getOrderTotalsResponse(GetOrderTotalsResponse? value) {
    _getOrderTotalsResponse = value;
    notifyListeners();
  }

  int _addressId = 0;
  int get addressId => _addressId;
  set addressId(int addressId) {
    _addressId = addressId;
    notifyListeners();
  }

  bool _isDeliveryMethods = false;
  bool get isDeliveryMethods => _isDeliveryMethods;
  set isDeliveryMethods(bool isDeliveryMethods) {
    _isDeliveryMethods = isDeliveryMethods;
    notifyListeners();
  }

  bool _isCheckboxBilling = false;
  bool get isCheckboxBilling => _isCheckboxBilling;
  set isCheckboxBilling(bool isCheckboxBilling) {
    _isCheckboxBilling = isCheckboxBilling;
    notifyListeners();
  }

  bool _isShippingAPICall = false;
  bool get isShippingAPICall => _isShippingAPICall;
  set isShippingAPICall(bool isShippingAPICall) {
    _isShippingAPICall = isShippingAPICall;
    notifyListeners();
  }

  bool _isMethodAPICall = false;
  bool get isMethodAPICall => _isMethodAPICall;
  set isMethodAPICall(bool isMethodAPICall) {
    _isMethodAPICall = isMethodAPICall;
    notifyListeners();
  }

  bool _isInvoiceAPICall = false;
  bool get isInvoiceAPICall => _isInvoiceAPICall;
  set isInvoiceAPICall(bool isInvoiceAPICall) {
    _isInvoiceAPICall = isInvoiceAPICall;
    notifyListeners();
  }

  bool _isContactAPICall = false;
  bool get isContactAPICall => _isContactAPICall;
  set isContactAPICall(bool isContactAPICall) {
    _isContactAPICall = isContactAPICall;
    notifyListeners();
  }

  bool _isLocalDBAlreadyCalled = false;
  bool get isLocalDBAlreadyCalled => _isLocalDBAlreadyCalled;

  set isLocalDBAlreadyCalled(bool isLocalDBAlreadyCalled) {
    _isLocalDBAlreadyCalled = isLocalDBAlreadyCalled;
    notifyListeners();
  }

  bool _isLocalDBAlreadyCalledForMethods = false;
  bool get isLocalDBAlreadyCalledForMethods =>
      _isLocalDBAlreadyCalledForMethods;

  set isLocalDBAlreadyCalledForMethods(bool isLocalDBAlreadyCalledForMethods) {
    _isLocalDBAlreadyCalledForMethods = isLocalDBAlreadyCalledForMethods;
    notifyListeners();
  }

  bool _isLocalforInvoiceAlreadyCalled = false;
  bool get isLocalforInvoiceAlreadyCalled => _isLocalforInvoiceAlreadyCalled;

  set isLocalforInvoiceAlreadyCalled(bool isLocalforInvoiceAlreadyCalled) {
    _isLocalforInvoiceAlreadyCalled = isLocalforInvoiceAlreadyCalled;
    notifyListeners();
  }

  bool _isLocalforContactAlreadyCalled = false;
  bool get isLocalforContactAlreadyCalled => _isLocalforContactAlreadyCalled;

  set isLocalforContactAlreadyCalled(bool isLocalforContactAlreadyCalled) {
    _isLocalforContactAlreadyCalled = isLocalforContactAlreadyCalled;
    notifyListeners();
  }

  List<ProductData> _cartProductList = [];
  List<ProductData> get cartProductList => _cartProductList;
  set cartProductList(List<ProductData> cartProductList) {
    _cartProductList = cartProductList;
    notifyListeners();
  }

  onNextButtonClick(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: CartView(
          index: 2,
        ));
  }

  setPickup(String value) async {
    await SharedPre.setStringValue(SharedPre.ISPICKUP, value);
    HiveDbServices<DeliveryMethod> _localDbForDeliveryMethods =
        HiveDbServices(Constants.delivery_methods);

    var value1 = await SharedPre.getStringValue(SharedPre.ISPICKUP);

    if (deliveryMethodsList != null && deliveryMethodsList.isNotEmpty) {
      deliveryMethodsList.forEach((element) {
        element.isSelected = false;
      });
      for (int i = 0; i < deliveryMethodsList.length; i++) {
        if (value1 == '0' && i == 0) {
          deliveryMethodsList[i].isSelected = true;
          break;
        } else if (value1 == '1' && i == 1) {
          deliveryMethodsList[i].isSelected = true;
          break;
        }
      }
    }

    _localDbForDeliveryMethods.clear();
    _localDbForDeliveryMethods.putListData(deliveryMethodsList);
    deliveryMethodsList = await _localDbForDeliveryMethods.getData();

    //await getItemDeliveryCharges();
  }

  getOrderTotal() async {
    showLoaderForOrderTotal = true;

    HiveDbServices<DeliveryMethod> _localDbForDeliveryMethods =
        HiveDbServices(Constants.delivery_methods);
    int deliveryMethodId = 0;

    deliveryMethodsList = await _localDbForDeliveryMethods.getData();

    if (deliveryMethodsList != null && deliveryMethodsList.isNotEmpty) {
      for (int i = 0; i < deliveryMethodsList.length; i++) {
        if (deliveryMethodsList[i].isSelected != null &&
            deliveryMethodsList[i].isSelected!) {
          deliveryMethodId = deliveryMethodsList[i].id!;
        }
      }
    }

    List<ProductModelData> productModelData = List.empty(growable: true);

    List<ProductData> cartProductList = await AppUtil.getCartList();

    if (cartProductList != null && cartProductList.isNotEmpty) {
      cartProductList.asMap().forEach((index, element) {
        int quantity = double.parse(element.yashValue!).toInt();
        productModelData
            .add(ProductModelData(id: element.id, quantity: quantity));
      });
    }

    Map<String, dynamic> requestBody = {
      "product_list": productModelData,
      "delivery_method_id": deliveryMethodId
    };

    getOrderTotalsResponse = await apiCall.getOrderTotal(requestBody);

    switch (getOrderTotalsResponse!.statusCode) {
      case Constants.sucessCode:
        getOrderTotalsResponse = getOrderTotalsResponse;
        break;
      case Constants.wrongError:
        AppUtil.showDialogbox(AppUtil.getContext(),
            getOrderTotalsResponse!.error ?? 'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        AppUtil.showDialogbox(AppUtil.getContext(),
            getOrderTotalsResponse!.error ?? 'Oops Something went wrong');
        break;
      default:
        {
          if (getOrderTotalsResponse!.error != null &&
              getOrderTotalsResponse!.error!.isNotEmpty) {
            AppUtil.showDialogbox(AppUtil.getContext(),
                getOrderTotalsResponse!.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    showLoaderForOrderTotal = false;
  }

  onEditAddressClick(BuildContext context, DeliveryInfo info) async {
    RegExp regExp = RegExp(r'\d+');
    String? extractedNumber = regExp.stringMatch(info.street1!);
    bool result = await PersistentNavBarNavigator.pushNewScreen(context,
        screen: AddressView(
          addressData: AddressData(
            id: info.id.toString(),
            isSelect: false,
            addressName: info.name,
            addressType: info.type,
            city: extractedNumber,
            country: info.country,
            emailAddress: info.email,
            mobileNumber: info.phone,
            state: info.state,
            streetNameNumber: info.street1,
            streetNameOther: info.street2,
          ),
        ));
    if (result != null && result) {
      getAddressListForShipping(false);
      getAddressListForBilling(false);
      getAddressListForContact(false);
    }
  }

  onEditAddressInvoiceClick(BuildContext context, InvoiceInfo info) async {
    bool result = await PersistentNavBarNavigator.pushNewScreen(context,
        screen: AddressView(
          addressData: AddressData(
              id: info.id.toString(),
              isSelect: false,
              addressName: info.name,
              addressType: info.type,
              city: info.city,
              country: info.country,
              emailAddress: info.email,
              mobileNumber: info.phone,
              state: info.state,
              streetNameNumber: info.street1,
              streetNameOther: info.street2),
        ));
    if (result != null && result) {
      getAddressListForShipping(false);
      getAddressListForBilling(false);
      getAddressListForContact(false);
    }
  }

  // getItemDeliveryCharges() async {
  //   HiveDbServices<DeliveryMethod> _localDbForDeliveryMethods =
  //       HiveDbServices(Constants.delivery_methods);

  //   List<DeliveryMethod>? localdbData =
  //       await _localDbForDeliveryMethods.getData();

  //   if (localdbData != null && localdbData.isNotEmpty) {
  //     localdbData.forEach((element) {
  //       if (element.isSelected != null && element.isSelected!) {
  //         deliveryCharge = double.parse(element.priceEx.toString());
  //       }
  //     });
  //   }
  // }

  onEditAddressContactClick(BuildContext context, ContactInfo info) async {
    bool result = await PersistentNavBarNavigator.pushNewScreen(context,
        screen: AddressView(
          addressData: AddressData(
              id: info.id.toString(),
              isSelect: false,
              addressName: info.name,
              addressType: info.type,
              city: info.city,
              country: info.country,
              emailAddress: info.email,
              mobileNumber: info.phone,
              state: info.state,
              streetNameNumber: info.street1,
              streetNameOther: info.street2),
        ));
    if (result != null && result) {
      getAddressListForShipping(false);
      getAddressListForBilling(false);
      getAddressListForContact(false);
    }
  }

  onAddNewAddressClick(BuildContext context) async {
    bool result = await PersistentNavBarNavigator.pushNewScreen(context,
        screen: AddressView());
    if (result != null && result) {
      getAddressListForShipping(false);
      getAddressListForBilling(false);
      getAddressListForContact(false);
    }
  }

  // // delete Address
  deleteAddress(DeliveryInfo data) async {
    deliveryAddList.removeWhere((element) => element.id == data.id);

    notifyListeners();

    DeleteContactResponse deleteContactResponse =
        await apiCall.deleteContact({"contact_id": data.id}, data.id);

    switch (deleteContactResponse.statusCode) {
      case Constants.sucessCode:

        // Restore data for Shipping Address List
        restoreShippingList();

        AppUtil.showSnackBar("Address deleted successfully");

        break;
      case Constants.wrongError:
        AppUtil.showDialogbox(AppUtil.getContext(),
            deleteContactResponse.error ?? "Something Went Wrong");

        notifyListeners();

        break;
      case Constants.networkErroCode:
        AppUtil.showDialogbox(AppUtil.getContext(),
            deleteContactResponse.error ?? "Something Went Wrong");
        // AppUtil.showToast(loginResp.error ?? '');
        break;
      default:
        {
          if (deleteContactResponse.error != null &&
              deleteContactResponse.error!.isNotEmpty) {}
        }
        break;
    }
  }

  // Restore Invoice List
  restoreInvoiceList() async {
    HiveDbServices<InvoiceInfo> _localDbForInvoiceAddress =
        HiveDbServices(Constants.invoice_address);

    List<InvoiceInfo>? _invoiceAddressList =
        await _localDbForInvoiceAddress.getData();

    _localDbForInvoiceAddress.clear();

    _localDbForInvoiceAddress.putListData(invoiceAddList);

    _invoiceAddList = await _localDbForInvoiceAddress.getData();

    invoiceAddList = _invoiceAddList;
  }

  // Restore Shipping List
  restoreShippingList() async {
    HiveDbServices<DeliveryInfo> _localDbForDeliveryAddress =
        HiveDbServices(Constants.delivery_address);

    List<DeliveryInfo>? _deliveryAddList =
        await _localDbForDeliveryAddress.getData();

    _localDbForDeliveryAddress.clear();

    _localDbForDeliveryAddress.putListData(deliveryAddList);

    _deliveryAddList = await _localDbForDeliveryAddress.getData();

    deliveryAddList = _deliveryAddList;
  }

  // Restore Invoice List
  restoreContactList() async {
    HiveDbServices<ContactInfo> _localDbForContactAddress =
        HiveDbServices(Constants.contact_address);

    List<ContactInfo>? _contactAddList =
        await _localDbForContactAddress.getData();

    _localDbForContactAddress.clear();

    _localDbForContactAddress.putListData(contactAddList);

    _contactAddList = await _localDbForContactAddress.getData();

    contactAddList = _contactAddList;
  }

  // // delete Address
  deleteAddressforBilling(InvoiceInfo data) async {
    invoiceAddList.removeWhere((element) => element.id == data.id);

    notifyListeners();

    DeleteContactResponse deleteContactResponse =
        await apiCall.deleteContact({"contact_id": data.id}, data.id);

    switch (deleteContactResponse.statusCode) {
      case Constants.sucessCode:

        // Restore data for Invoice Address List
        restoreInvoiceList();

        AppUtil.showSnackBar("Address deleted successfully");

        break;
      case Constants.wrongError:
        AppUtil.showDialogbox(AppUtil.getContext(),
            deleteContactResponse.error ?? "Something Went Wrong");

        notifyListeners();

        break;
      case Constants.networkErroCode:
        AppUtil.showDialogbox(AppUtil.getContext(),
            deleteContactResponse.error ?? "Something Went Wrong");
        // AppUtil.showToast(loginResp.error ?? '');
        break;
      default:
        {
          if (deleteContactResponse.error != null &&
              deleteContactResponse.error!.isNotEmpty) {}
        }
        break;
    }
  }

  // // delete Address
  deleteAddressforContact(ContactInfo data) async {
    contactAddList.removeWhere((element) => element.id == data.id);

    notifyListeners();

    DeleteContactResponse deleteContactResponse =
        await apiCall.deleteContact({"contact_id": data.id}, data.id);

    switch (deleteContactResponse.statusCode) {
      case Constants.sucessCode:

        // Restore data for Invoice Address List
        restoreContactList();

        AppUtil.showSnackBar("Address deleted successfully");

        break;
      case Constants.wrongError:
        AppUtil.showDialogbox(AppUtil.getContext(),
            deleteContactResponse.error ?? "Something Went Wrong");

        notifyListeners();

        break;
      case Constants.networkErroCode:
        AppUtil.showDialogbox(AppUtil.getContext(),
            deleteContactResponse.error ?? "Something Went Wrong");
        // AppUtil.showToast(loginResp.error ?? '');
        break;
      default:
        {
          if (deleteContactResponse.error != null &&
              deleteContactResponse.error!.isNotEmpty) {}
        }
        break;
    }
  }

  getAddressListForShipping(bool calledFromOnModelReady) async {
    if (!calledFromOnModelReady) {
      isAlreadyCalled = true;
    } else {
      isAlreadyCalled = false;
    }

    HiveDbServices<DeliveryInfo> _localDbForDeliveryAddress =
        HiveDbServices(Constants.delivery_address);
    List<DeliveryInfo>? _deliveryAddList =
        await _localDbForDeliveryAddress.getData();

    if (_deliveryAddList.isEmpty) {
      isShippingAPICall = true;
    } else {
      deliveryAddList = _deliveryAddList;
    }

    int addressId = 0;

    DeliveryAddressResponse deliveryAddressResponse =
        await apiCall.getDeliveryAddress();

    switch (deliveryAddressResponse.statusCode) {
      case Constants.sucessCode:
        deliveryAddList.forEach((element) {
          if (element.selected!) {
            addressId = element.id!;
          }
        });
        deliveryAddList.clear();

        if (deliveryAddressResponse.deliveryAddressInfo != null &&
            deliveryAddressResponse.deliveryAddressInfo!.length > 0) {
          deliveryAddressResponse.deliveryAddressInfo!
              .asMap()
              .forEach((index, element) {
            deliveryAddList.add(DeliveryInfo(
                id: element.id,
                city: element.city,
                country: element.country,
                phone: element.phone,
                email: element.email,
                name: element.name,
                selected: addressId == element.id
                    ? true
                    : index == 0 && addressId == 0
                        ? true
                        : false,
                state: element.state,
                street1: element.street1,
                street2: element.street2,
                type: element.type,
                completeAddress:
                    '${element.street1} ${element.city} ${element.state} ${element.country}'));
          });
        }

        _localDbForDeliveryAddress.clear();

        _localDbForDeliveryAddress.putListData(deliveryAddList);

        _deliveryAddList = await _localDbForDeliveryAddress.getData();

        deliveryAddList = _deliveryAddList;

        break;
      case Constants.wrongError:
        isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            deliveryAddressResponse.error ?? 'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            deliveryAddressResponse.error ?? 'Oops Something went wrong');
        break;
      default:
        {
          if (deliveryAddressResponse.error != null &&
              deliveryAddressResponse.error!.isNotEmpty) {
            //isAPIError = true;
            AppUtil.showDialogbox(AppUtil.getContext(),
                deliveryAddressResponse.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    isShippingAPICall = false;
  }

  getAddressListForBilling(bool calledFromOnModelReady) async {
    if (!calledFromOnModelReady) {
      isAlreadyCalled = true;
    } else {
      isAlreadyCalled = false;
    }
    int addressId = 0;

    HiveDbServices<InvoiceInfo> _localDbForInvoiceAddress =
        HiveDbServices(Constants.invoice_address);
    List<InvoiceInfo>? _invoiceAddList =
        await _localDbForInvoiceAddress.getData();

    if (_invoiceAddList.isEmpty) {
      isInvoiceAPICall = true;
      InvoiceAddressResponse invoiceAddressResponse =
          await apiCall.getInvoiceAddress();

      switch (invoiceAddressResponse.statusCode) {
        case Constants.sucessCode:
          invoiceAddList.forEach((element) {
            if (element.selectedForBilling!) {
              addressId = element.id!;
            }
          });
          invoiceAddList.clear();
          if (invoiceAddressResponse.invoiceAddressInfo != null &&
              invoiceAddressResponse.invoiceAddressInfo!.length > 0) {
            invoiceAddressResponse.invoiceAddressInfo!
                .asMap()
                .forEach((index, element) {
              invoiceAddList.add(InvoiceInfo(
                  id: element.id,
                  city: element.city,
                  country: element.country,
                  phone: element.phone,
                  email: element.email,
                  name: element.name,
                  selectedForBilling: addressId == element.id
                      ? true
                      : index == 0
                          ? true
                          : false,
                  state: element.state,
                  street1: element.street1,
                  street2: element.street2,
                  type: element.type,
                  completeAddress:
                      '${element.street1} ${element.city} ${element.state} ${element.country}'));
            });
          }

          _localDbForInvoiceAddress.clear();

          _localDbForInvoiceAddress.putListData(invoiceAddList);

          _invoiceAddList = await _localDbForInvoiceAddress.getData();

          invoiceAddList = _invoiceAddList;

          break;
        case Constants.wrongError:
          isAPIError = true;
          AppUtil.showDialogbox(AppUtil.getContext(),
              invoiceAddressResponse.error ?? 'Oops Something went wrong');

          break;
        case Constants.networkErroCode:
          isAPIError = true;
          AppUtil.showDialogbox(AppUtil.getContext(),
              invoiceAddressResponse.error ?? 'Oops Something went wrong');
          break;
        default:
          {
            if (invoiceAddressResponse.error != null &&
                invoiceAddressResponse.error!.isNotEmpty) {
              //isAPIError = true;
              AppUtil.showDialogbox(AppUtil.getContext(),
                  invoiceAddressResponse.error ?? 'Oops Something went wrong');
            }
          }
          break;
      }
      isInvoiceAPICall = false;
    } else {
      invoiceAddList = _invoiceAddList;
    }
  }

  getAddressListForContact(bool calledFromOnModelReady) async {
    if (!calledFromOnModelReady) {
      isAlreadyCalled = true;
    } else {
      isAlreadyCalled = false;
    }
    int addressId = 0;

    HiveDbServices<ContactInfo> _localDbForContactAddress =
        HiveDbServices(Constants.contact_address);
    List<ContactInfo>? _contactAddList =
        await _localDbForContactAddress.getData();

    if (_contactAddList.isEmpty) {
      isContactAPICall = true;
    } else {
      contactAddList = _contactAddList;
    }

    ContactAddressResponse contactAddressResponse =
        await apiCall.getContactAddress();

    switch (contactAddressResponse.statusCode) {
      case Constants.sucessCode:
        contactAddList.forEach((element) {
          if (element.selected!) {
            addressId = element.id!;
          }
        });
        contactAddList.clear();
        if (contactAddressResponse.contactAddressInfo != null &&
            contactAddressResponse.contactAddressInfo!.length > 0) {
          contactAddressResponse.contactAddressInfo!
              .asMap()
              .forEach((index, element) {
            contactAddList.add(ContactInfo(
                id: element.id,
                city: element.city,
                country: element.country,
                phone: element.phone,
                email: element.email,
                name: element.name,
                selected: addressId == element.id
                    ? true
                    : index == 0
                        ? true
                        : false,
                state: element.state,
                street1: element.street1,
                street2: element.street2,
                type: element.type,
                completeAddress:
                    '${element.street1} ${element.city} ${element.state} ${element.country}'));
          });
        }

        _localDbForContactAddress.clear();

        _localDbForContactAddress.putListData(contactAddList);

        _contactAddList = await _localDbForContactAddress.getData();

        contactAddList = _contactAddList;

        break;
      case Constants.wrongError:
        isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            contactAddressResponse.error ?? 'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            contactAddressResponse.error ?? 'Oops Something went wrong');
        break;
      default:
        {
          if (contactAddressResponse.error != null &&
              contactAddressResponse.error!.isNotEmpty) {
            //isAPIError = true;
            AppUtil.showDialogbox(AppUtil.getContext(),
                contactAddressResponse.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    isContactAPICall = false;
  }

  updateLocalDatabase(DeliveryInfo obj) async {
    HiveDbServices<DeliveryInfo> _localDbForDeliveryAddress =
        HiveDbServices(Constants.delivery_address);
    _deliveryAddList = await _localDbForDeliveryAddress.getData();

    _deliveryAddList.forEach((element) {
      if (element.id == obj.id) {
        element.selected = !element.selected!;
      } else {
        element.selected = false;
      }
    });

    _localDbForDeliveryAddress.clear();

    _localDbForDeliveryAddress.putListData(_deliveryAddList);

    deliveryAddList = await _localDbForDeliveryAddress.getData();

    notifyListeners();
  }

  updateLocalDatabaseForMethods(List<DeliveryMethod> obj, bool value) async {
    HiveDbServices<DeliveryMethod> _localDbForDeliveryMethods =
        HiveDbServices(Constants.delivery_methods);
    deliveryMethodsList = await _localDbForDeliveryMethods.getData();

    deliveryMethodsList.asMap().forEach((index, element) {
      if (element.id == obj[index].id) {
        element.pickup = value;
        element.isSelected = value;
      } else {
        element.pickup = false;
        element.isSelected = false;
      }
    });

    _localDbForDeliveryMethods.clear();

    _localDbForDeliveryMethods.putListData(deliveryMethodsList);

    deliveryMethodsList = await _localDbForDeliveryMethods.getData();

    notifyListeners();
  }

  updateLocalDatabaseforBilling(InvoiceInfo obj) {
    invoiceAddList.forEach((element) {
      if (element.id == obj.id) {
        element.selectedForBilling = !element.selectedForBilling!;
      } else {
        element.selectedForBilling = false;
      }
    });
    notifyListeners();
  }

  updateLocalDatabaseforContact(ContactInfo obj) {
    contactAddList.forEach((element) {
      if (element.id == obj.id) {
        element.selected = !element.selected!;
      } else {
        element.selected = false;
      }
    });
    notifyListeners();
  }

  getLocalDataForDelivery() async {
    isLocalDBAlreadyCalled = true;
    notifyListeners();
    deliveryAddList.clear();
    HiveDbServices<DeliveryInfo> _localDbForDeliveryAddress =
        HiveDbServices(Constants.delivery_address);
    List<DeliveryInfo>? _deliveryAddList =
        await _localDbForDeliveryAddress.getData();
    deliveryAddList = _deliveryAddList;
    return deliveryAddList;
  }

  getLoacalDataForInvoice() async {
    isLocalforInvoiceAlreadyCalled = true;
    notifyListeners();
    invoiceAddList.clear();
    HiveDbServices<InvoiceInfo> _localDbForInvoiceAddress =
        HiveDbServices(Constants.invoice_address);

    List<InvoiceInfo>? _invoiceAddressList =
        await _localDbForInvoiceAddress.getData();
    invoiceAddList = _invoiceAddressList;
    return invoiceAddList;
  }

  getLoacalDataForContact() async {
    isLocalforContactAlreadyCalled = true;
    notifyListeners();
    contactAddList.clear();
    HiveDbServices<ContactInfo> _localDbForContactAddress =
        HiveDbServices(Constants.contact_address);

    List<ContactInfo>? _contactAddressList =
        await _localDbForContactAddress.getData();
    contactAddList = _contactAddressList;
    return contactAddList;
  }

  getDeliveyMethodsItems(bool calledFromOnModelReady) async {
    if (!calledFromOnModelReady) {
      isAlreadyCalled = true;
    } else {
      isAlreadyCalled = false;
    }

    List<ProductModelData> productModelData = List.empty(growable: true);

    List<ProductData> cartProductList = await AppUtil.getCartList();

    if (cartProductList != null && cartProductList.isNotEmpty) {
      cartProductList.asMap().forEach((index, element) {
        int quantity = double.parse(element.yashValue!).toInt();
        productModelData
            .add(ProductModelData(id: element.id, quantity: quantity));
      });
    }

    Map<String, dynamic> requestBody = {"product_list": productModelData};
    HiveDbServices<DeliveryMethod> _localDbForDeliveryMethods =
        HiveDbServices(Constants.delivery_methods);
    List<DeliveryMethod>? localdbData =
        await _localDbForDeliveryMethods.getData();

    if (localdbData.isEmpty) {
      isDeliveryMethods = true;
      setPickup("0");
    } else {
      deliveryMethodsList = localdbData;
    }

    DeliveryMethodsResponse deliveryMethodsResponse =
        await apiCall.getDeliveryMethods(requestBody);

    switch (deliveryMethodsResponse.statusCode) {
      case Constants.sucessCode:
        deliveryMethodsList.clear();

        deliveryMethodsList
            .addAll(deliveryMethodsResponse.deliveryMethodsResult!.products!);

        _localDbForDeliveryMethods.clear();

        var value = await SharedPre.getStringValue(SharedPre.ISPICKUP);

        if (deliveryMethodsList != null && deliveryMethodsList.isNotEmpty) {
          for (int i = 0; i < deliveryMethodsList.length; i++) {
            if (value == '0' && i == 0) {
              deliveryMethodsList[i].isSelected = true;
              break;
            } else if (value == '1' && i == 1) {
              deliveryMethodsList[i].isSelected = true;
              break;
            }
          }
        }

        _localDbForDeliveryMethods.putListData(deliveryMethodsList);
        deliveryMethodsList = await _localDbForDeliveryMethods.getData();

        notifyListeners();

        break;
      case Constants.wrongError:
        AppUtil.showDialogbox(AppUtil.getContext(),
            deliveryMethodsResponse.error ?? 'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        AppUtil.showDialogbox(AppUtil.getContext(),
            deliveryMethodsResponse.error ?? 'Oops Something went wrong');
        break;
      default:
        {
          if (deliveryMethodsResponse.error != null &&
              deliveryMethodsResponse.error!.isNotEmpty) {
            AppUtil.showDialogbox(AppUtil.getContext(),
                deliveryMethodsResponse.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    isDeliveryMethods = false;
  }
}

class ProductModelData {
  int? id = 0;
  int? quantity = 0;

  ProductModelData({this.id, this.quantity});

  Map<String, dynamic> toJson() => {"id": id, "quantity": quantity};
}
