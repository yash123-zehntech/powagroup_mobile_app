import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/cart_module/cart_view.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/delivery_view_model.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_methods_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/get_order_totals_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/extra_info_module/response_model/extra_info_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/extra_info_module/response_model/site_contact.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/shared_preference.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../../helper_widget/end_card_widget.dart';
import '../../site_address_module/site_address.dart';
import '../../user_module/profile/response_model.dart/user_profile_model.dart';
import 'response_model/warehouses_response_model.dart';

class ExtraViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  TextEditingController refernceController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController acnController = TextEditingController();
  TextEditingController businessAddController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _refrence = '';
  String _notes = '';
  String _code = '';
  String _country = '';
  String _bussinessadd = '';
  String _postcode = '';
  String value = '';
  bool value1 = false;
  String _siteContect = '  Select Site Contact';
  String dropDownValue = '';
  String? _imageFile;
  bool isInformaionSaved = false;
  String? _deliveryAddressId;
  String _siteContectId = '';

  int chooseFile = 0;
  double totalPriceOfItem = 0;
  Api apiCall = locator<Api>();
  List<DeliveryInfo> _addressList = [];
  ExtraInfoData _information = new ExtraInfoData();
  String? _siteContactInfo;
  Warehouse? _warehouseInfo;
  SiteContactResponse siteContactInforsponse = SiteContactResponse();
  List<String> _sitecontactList = List.empty(growable: true);
  List<String> get sitecontactList => _sitecontactList;
  HiveDbServices<UserObject> _localDbForUser =
      HiveDbServices(Constants.user_data);

  set sitecontactList(List<String> sitecontactList) {
    _sitecontactList = sitecontactList;

    notifyListeners();
  }

  List<Warehouse> _warehousetList = List.empty(growable: true);
  List<Warehouse> get warehousetList => _warehousetList;

  set warehousetList(List<Warehouse> warehousetList) {
    _warehousetList = warehousetList;

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

  bool _checkforSiteContact = false;
  bool get checkforSiteContacts => _checkforSiteContact;
  set checkforSiteContacts(bool checkforSiteContacts) {
    _checkforSiteContact = checkforSiteContacts;
    notifyListeners();
  }

  List<DeliveryMethod> _deliveryMethodsList = List.empty(growable: true);

  List<DeliveryMethod> get deliveryMethodsList => _deliveryMethodsList;

  set deliveryMethodsList(List<DeliveryMethod> deliveryMethodsList) {
    _deliveryMethodsList = deliveryMethodsList;
    notifyListeners();
  }

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

  List<ProductData> _cartProductList = [];
  List<ProductData> get cartProductList => _cartProductList;
  set cartProductList(List<ProductData> cartProductList) {
    _cartProductList = cartProductList;
    notifyListeners();
  }

  bool _isDeliveryMethods = false;
  bool get isDeliveryMethods => _isDeliveryMethods;
  set isDeliveryMethods(bool isDeliveryMethods) {
    _isDeliveryMethods = isDeliveryMethods;
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

  bool _checkforWarehouse = false;
  bool get checkforWarehouse => _checkforWarehouse;
  set checkforWarehouse(bool checkforWarehouse) {
    _checkforWarehouse = checkforWarehouse;
    notifyListeners();
  }

  double _deliveryCharge = 0.0;
  double get deliveryCharge => _deliveryCharge;
  set deliveryCharge(double value) {
    _deliveryCharge = value;
    notifyListeners();
  }

  UserObject? userDetails;
  getSiteContect(List<DeliveryInfo> addressLists) async {
    UserObject? _userData = await _localDbForUser.get();

    userDetails = _userData;
    if (userDetails != null && userDetails!.name != null ||
        userDetails!.name!.isNotEmpty) {
      sitecontactList.clear();
      sitecontactList.add(
        userDetails!.name.toString(),
      );
      siteContactInfo = userDetails!.name.toString();
      userName = userDetails!.name;
      if (userDetails!.partnerId != null) {
        partnerId = userDetails!.partnerId;
      }
    }

    notifyListeners();
  }

  String? _userName;

  String? get userName => _userName;
  set userName(String? userName) {
    _userName = userName;
    notifyListeners();
  }

  int? _partnerId;

  int? get partnerId => _partnerId;
  set partnerId(int? partnerId) {
    _partnerId = partnerId;
    notifyListeners();
  }

  getWarehousesListItems() async {
    checkforWarehouse = true;

    WarehousesResponse warehousesResponse =
        await apiCall.getWarehouseListItems();

    switch (warehousesResponse.statusCode) {
      case Constants.sucessCode:
        warehousetList.clear();
        warehousesResponse.warehouses!.forEach((Warehouse element) {
          warehousetList.add(Warehouse(id: element.id, name: element.name));

          if (warehousetList != null && warehousetList.isNotEmpty) {
            warehousetList.forEach((element) {
              if (element.id.toString() == information!.warehouseId) {
                warehouseInfo = element;
                notifyListeners();
              }
              // if (warehousetList[0].name != null &&
              //     warehousetList[0].name!.isNotEmpty) {
              //   wareHouseName = warehousetList[0].name;
              // }
            });
          }
        });

        break;
      case Constants.wrongError:
        //isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            warehousesResponse.error ?? 'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        //isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            warehousesResponse.error ?? 'Oops Something went wrong');
        break;
      default:
        {
          if (warehousesResponse.error != null &&
              warehousesResponse.error!.isNotEmpty) {
            //isAPIError = true;
            AppUtil.showDialogbox(AppUtil.getContext(),
                warehousesResponse.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    checkforWarehouse = false;
  }

  String? _wareHouseName;

  String? get wareHouseName => _wareHouseName;
  set wareHouseName(String? wareHouseName) {
    _wareHouseName = wareHouseName;
    notifyListeners();
  }

  bool _showAddNewcontact = false;
  bool get showAddNewcontact => _showAddNewcontact;
  set showAddNewcontact(bool showAddNewcontact) {
    _showAddNewcontact = showAddNewcontact;
    notifyListeners();
  }

  isPickupValue() async {
    var value = await SharedPre.getStringValue(SharedPre.ISPICKUP);
    if (value == '0') {
      showAddNewcontact = true;
    }
  }

  // call the API to get order total
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

  // getDeliveyMethodsItems(bool calledFromOnModelReady) async {
  //   if (!calledFromOnModelReady) {
  //     isAlreadyCalled = true;
  //   } else {
  //     isAlreadyCalled = false;
  //   }

  //   List<ProductModelData> productModelData = List.empty(growable: true);

  //   List<ProductData> cartProductList = await AppUtil.getCartList();

  //   if (cartProductList != null && cartProductList.isNotEmpty) {
  //     cartProductList.asMap().forEach((index, element) {
  //       int quantity = double.parse(element.yashValue!).toInt();
  //       productModelData
  //           .add(ProductModelData(id: element.id, quantity: quantity));
  //     });
  //   }

  //   Map<String, dynamic> requestBody = {"product_list": productModelData};
  //   HiveDbServices<DeliveryMethod> _localDbForDeliveryMethods =
  //       HiveDbServices(Constants.delivery_methods);
  //   List<DeliveryMethod>? localdbData =
  //       await _localDbForDeliveryMethods.getData();

  //   if (localdbData.isEmpty) {
  //     isDeliveryMethods = true;
  //     setPickup("0");
  //   } else {
  //     deliveryMethodsList = localdbData;
  //   }

  //   DeliveryMethodsResponse deliveryMethodsResponse =
  //       await apiCall.getDeliveryMethods(requestBody);

  //   switch (deliveryMethodsResponse.statusCode) {
  //     case Constants.sucessCode:
  //       deliveryMethodsList.clear();

  //       deliveryMethodsList
  //           .addAll(deliveryMethodsResponse.deliveryMethodsResult!.products!);

  //       _localDbForDeliveryMethods.clear();

  //       var value = await SharedPre.getStringValue(SharedPre.ISPICKUP);

  //       if (deliveryMethodsList != null && deliveryMethodsList.isNotEmpty) {
  //         for (int i = 0; i < deliveryMethodsList.length; i++) {
  //           if (value == '0' && i == 0) {
  //             deliveryMethodsList[i].isSelected = true;
  //             break;
  //           } else if (value == '1' && i == 1) {
  //             deliveryMethodsList[i].isSelected = true;
  //             break;
  //           }
  //         }
  //       }

  //       _localDbForDeliveryMethods.putListData(deliveryMethodsList);
  //       deliveryMethodsList = await _localDbForDeliveryMethods.getData();

  //       break;
  //     case Constants.wrongError:
  //       AppUtil.showDialogbox(AppUtil.getContext(),
  //           deliveryMethodsResponse.error ?? 'Oops Something went wrong');

  //       break;
  //     case Constants.networkErroCode:
  //       AppUtil.showDialogbox(AppUtil.getContext(),
  //           deliveryMethodsResponse.error ?? 'Oops Something went wrong');
  //       break;
  //     default:
  //       {
  //         if (deliveryMethodsResponse.error != null &&
  //             deliveryMethodsResponse.error!.isNotEmpty) {
  //           AppUtil.showDialogbox(AppUtil.getContext(),
  //               deliveryMethodsResponse.error ?? 'Oops Something went wrong');
  //         }
  //       }
  //       break;
  //   }
  //   isDeliveryMethods = false;
  // }

  HiveDbServices<ExtraInfoData> _localDb = HiveDbServices(Constants.extra_info);

  bool _extraInfo = false;

  String? get deliveryAddressId => _deliveryAddressId;
  set deliveryAddressId(String? deliveryAddressId) {
    _deliveryAddressId = deliveryAddressId;
    notifyListeners();
  }

  bool get extraInfo => _extraInfo;
  set extraInfo(bool extraInfo) {
    _extraInfo = extraInfo;
    notifyListeners();
  }

  saveExtraInformation(BuildContext context) {
    _localDb.putData(Constants.extra_info, getExtraInformationObject());
    isInformaionSaved = true;

    notifyListeners();

    if (isInformaionSaved == true) {
      onNextButtonClick(context);
    }
  }

  getSavedExtraInformation() async {
    extraInfo = true;
    information = await _localDb.get();
    userDetails = await _localDbForUser.get();

    if (information != null && userDetails != null) {
      notesController.text =
          information!.deliveryNotes != null ? information!.deliveryNotes! : '';
      refernceController.text = information!.refernceNumber != null
          ? information!.refernceNumber!
          : '';
      // siteContactInfo =
      //     SiteContactInfo(selected: true, name: userDetails!.name);
      siteContactInfo =
          information!.siteContect != null ? information!.siteContect : '';

      imageFile = information!.imagePath != null ? information!.imagePath! : '';
    }
    notifyListeners();
  }

  List<DeliveryInfo> get addressList => _addressList;
  set addressList(List<DeliveryInfo> addressList) {
    _addressList = addressList;
    notifyListeners();
  }

  ExtraInfoData? get information => _information;
  set information(ExtraInfoData? information) {
    if (information != null) {
      _information = information;
    }

    notifyListeners();
  }

  String? get siteContactInfo => _siteContactInfo;
  set siteContactInfo(String? siteContactInfo) {
    if (siteContactInfo != null) {
      _siteContactInfo = siteContactInfo;
    }

    notifyListeners();
  }

  Warehouse? get warehouseInfo => _warehouseInfo;
  set warehouseInfo(Warehouse? warehouseInfo) {
    if (warehouseInfo != null) {
      _warehouseInfo = warehouseInfo;
    }

    notifyListeners();
  }

  String get refrence => _refrence;
  set refrence(String refrence) {
    _refrence = refrence;
    notifyListeners();
  }

  String? get imageFile => _imageFile;
  set imageFile(String? imageFile) {
    _imageFile = imageFile;
    notifyListeners();
  }

  String get siteContect => _siteContect;
  set siteContect(String siteContect) {
    _siteContect = siteContect;
    notifyListeners();
  }

  String get siteContectId => _siteContectId;
  set siteContectId(String siteContectId) {
    _siteContectId = siteContectId;
    notifyListeners();
  }

  String get notes => _notes;
  set notes(String notes) {
    _notes = notes;
    notifyListeners();
  }

  String get code => _code;
  set code(String code) {
    _code = code;
    notifyListeners();
  }

  String get country => _country;
  set country(String country) {
    _country = country;
    notifyListeners();
  }

  String get bussinessAdd => _bussinessadd;
  set bussinessAdd(String bussinessAdd) {
    _bussinessadd = bussinessAdd;
    notifyListeners();
  }

  String get postCode => _postcode;
  set postCode(String postCode) {
    _postcode = postCode;
    notifyListeners();
  }

  set dropdown(var value) {
    this.value = value;
    notifyListeners();
  }

  onNextButtonClick(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: CartView(
          index: 3,
        ));
    // PersistentNavBarNavigator.pushNewScreen(context,
    //     screen: HomePageView(
    //       number: 3,
    //       numberforCart: 1,
    //     ));
  }

  onSubmitButtonClick(BuildContext context) async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        saveExtraInformation(context);
      } else {}
    } catch (e) {}
  }

  // get Address object to store data in local db

  ExtraInfoData getExtraInformationObject() {
    String? siteContactId;

    if (partnerId != null) {
      siteContactId = partnerId.toString();
    }

    return ExtraInfoData(
        id: siteContactId,
        siteContect: siteContactInfo,
        refernceNumber: refernceController.text,
        deliveryNotes: notesController.text,
        imagePath: imageFile,
        warehouseId: warehouseInfo!.id.toString(),
        warehouseName: warehouseInfo!.name);
  }

  commentSectionPriceWidget1(sale_uom, viewModel, title, screenName,
      productTotalAmount, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sale_uom == null && sale_uom.isEmpty
              ? Text(
                  sale_uom == null || sale_uom.isEmpty ? "" : "per $sale_uom",
                  style: TextStyle(
                      fontFamily: 'Inter-Medium',
                      fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.33,
                      color: const Color(0xff000000)),
                )
              : Container(
                  height: 0,
                  width: 0,
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              priceColumnWidget('Total Amounts', productTotalAmount, viewModel),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: InkWell(
                  onTap: () {
                    try {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        saveExtraInformation(context);
                        viewModel.onCheckoutButtonClick();
                      }
                    } catch (e) {}
                  },
                  child: ButtonWidget(
                    isBusy: viewModel.isBusy,
                    buttonTitle: title,
                    containerWidth: 130.0.w,
                    containerHeigth: 48.h,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  onAddNewSiteContactAddressClick(BuildContext context) async {
    bool result = await PersistentNavBarNavigator.pushNewScreen(context,
        screen: SiteAddressView(
          deliveryAddressId: deliveryAddressId,
        ));
  }

  getPickUpType() async {
    getPickupValue = await SharedPre.getStringValue(SharedPre.ISPICKUP);
  }
}
