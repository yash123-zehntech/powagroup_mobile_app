import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/helper_widget/debouncer.dart';
import 'package:powagroup/provider/payment_provider.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/address_module/response_model/address_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/delivery_view_model.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/contact_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/get_order_totals_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/invoice_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/model/dropdownlist.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/user_module/profile/response_model.dart/user_profile_model.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../../util/shared_preference.dart';
import '../../home_module/product_subcategory_item_module/response_model/sort_list_item_model.dart';
import '../cart_module/cart_view.dart';
import '../delivery_module/response_model/delivery_methods_response.dart';

class ConfirmOrderModal extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final debouncer = Debouncer(milliseconds: 1000);
  final HiveDbServices<AddressData> _localDb =
      HiveDbServices(Constants.address);
  PaymentProvider provider = PaymentProvider();
  List<ProductData> _cartProductList = List.empty(growable: true);
  List<DeliveryInfo> _shippingAddressList = List.empty(growable: true);
  List<InvoiceInfo> _billingAddressList = List.empty(growable: true);
  List<ContactInfo> _contactAddressList = List.empty(growable: true);
  String _value = "Review Order";
  String _dropDownAccount = '';
  String _choosevalue = '';
  String get index => _value;
  String _getIndexOFlist = '';
  String _getPickupMethodValue =
      'FREE DELIVERY ORDERS OVER \$150 EX GST OR ONLY \$10.00';
  int _itemCount = 0;

  double totalPriceOfItem = 0;

  HiveDbServices<UserObject> _localDbForUserData =
      HiveDbServices(Constants.user_data);
  Api apiCall = locator<Api>();
  UserObject? userDetails;

  set value(String value) {
    _value = value;
    notifyListeners();
  }

  int get itemCount => _itemCount;
  set itemCount(int itemCount) {
    _itemCount = itemCount;
    notifyListeners();
  }

  double _deliveryCharge = 0.0;
  double get deliveryCharge => _deliveryCharge;
  set deliveryCharge(double value) {
    _deliveryCharge = value;
    notifyListeners();
  }

  double _totalAmount = 0.0;
  double get totalAmount => _totalAmount;
  set totalAmount(double totalAmount) {
    _totalAmount = totalAmount;
    notifyListeners();
  }

  static List<DropDownList> act = [
    DropDownList(1, '2'),
    DropDownList(2, '4'),
    DropDownList(3, '6'),
    DropDownList(4, '8')
  ];

  List<ListItemforOrder> dropdownItemsForPaymentSelection = [
    ListItemforOrder(
        1,
        "Credit Card Payment Accepts Visa, Mastercard & American Express",
        false),
    ListItemforOrder(2, "Pay by Account", false),
  ];

  List<ListItemforOrder> deliveryMethodList = [
    ListItemforOrder(
        1, "FREE DELIVERY ORDERS OVER \$150 EX GST OR ONLY \$10.00", false),
    ListItemforOrder(2, "Pickup", false),
  ];

  // List<String> act = [
  //   '2',
  //   '4',
  //   '6',
  //   '8',
  //   '10',
  // ];

  String get getIndexOFlist => _getIndexOFlist;
  set getIndexOFlist(String getIndexOFlist) {
    _getIndexOFlist = getIndexOFlist;
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

  List<DeliveryMethod> _deliveryMethodsList = List.empty(growable: true);

  List<DeliveryMethod> get deliveryMethodsList => _deliveryMethodsList;

  set deliveryMethodsList(List<DeliveryMethod> deliveryMethodsList) {
    _deliveryMethodsList = deliveryMethodsList;
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

  String? _paymentType = '';
  String? get paymentType => _paymentType;
  set paymentType(String? paymentType) {
    _paymentType = paymentType;
    notifyListeners();
  }

  int? _paymentMethodId = 0;
  int? get paymentMethodId => _paymentMethodId;
  set paymentMethodId(int? paymentMethodId) {
    _paymentMethodId = paymentMethodId;
    notifyListeners();
  }

  String get getPickupMethodValue => _getPickupMethodValue;
  set getPickupMethodValue(String getPickupMethodValue) {
    _getPickupMethodValue = getPickupMethodValue;
    notifyListeners();
  }

  String get dropDownAccount => _dropDownAccount;
  set dropDownAccount(String dropDownAccount) {
    _dropDownAccount = dropDownAccount;
    notifyListeners();
  }

  String get choosevalue => _choosevalue;
  set choosevalue(String choosevalue) {
    _choosevalue = choosevalue;
    notifyListeners();
  }

  List<ProductData> get cartProductList => _cartProductList;
  set cartProductList(List<ProductData> cartProductList) {
    _cartProductList = cartProductList;
    notifyListeners();
  }

  List<DeliveryInfo> get shippingAddressList => _shippingAddressList;
  set shippingAddressList(List<DeliveryInfo> shippingAddressList) {
    _shippingAddressList = shippingAddressList;
    notifyListeners();
  }

  List<InvoiceInfo> get billingAddressList => _billingAddressList;

  set billingAddressList(List<InvoiceInfo> billingAddressList) {
    _billingAddressList = billingAddressList;
    notifyListeners();
  }

  List<ContactInfo> get contactAddressList => _contactAddressList;

  set contactAddressList(List<ContactInfo> contactAddressList) {
    _contactAddressList = contactAddressList;
    notifyListeners();
  }

  // Update or add controller value by index
  updateControllerValue(index, value, price) {
    HiveDbServices<ProductData> _cartLocalDB =
        HiveDbServices(Constants.cart_product);

    try {
      if (cartProductList[index].controllerForCart == null) {
        cartProductList[index].controllerForCart = TextEditingController();

        cartProductList[index].yashValue = value.toString();
        cartProductList[index].controllerForCart!.text =
            value.replaceAll(".0", "").toString();

        cartProductList[index].priceUntaxed = price;
      } else {
        cartProductList[index].yashValue = value.toString();
        cartProductList[index].controllerForCart!.text =
            value.replaceAll(".0", "").toString();

        cartProductList[index].priceUntaxed = price;
      }
      cartProductList[index].priceByQty = price.toString();

      _cartLocalDB.clear();

      _cartLocalDB.putListData(cartProductList);
    } catch (e) {}

    notifyListeners();
  }

  // Delete Product from list and local database
  deleteProduct(ProductData productData, ConfirmOrderModal viewModel, context) {
    cartProductList.removeWhere(
        (element) => element.id.toString() == productData.id.toString());

    AppUtil.onAddToTruckClick(productData, true, viewModel);

    notifyListeners();
  }

  getBedgeCount() async {
    itemCount = await AppUtil.getCartProductLength();
    notifyListeners();
  }

  onNextButtonClick() {
    PersistentNavBarNavigator.pushNewScreen(AppUtil.getContext(),
        screen: CartView(
          index: 4,
        ));
  }

  onEditAddressClick(BuildContext context, DeliveryInfo info) async {
    RegExp regExp = RegExp(r'\d+');
    String? extractedNumber = regExp.stringMatch(info.street1!);
    bool result = await PersistentNavBarNavigator.pushNewScreen(context,
        screen: CartView(
          index: 1,
        ));
  }

  getDeliveryList() async {
    shippingAddressList.clear();
    HiveDbServices<DeliveryInfo> _localDbForDeliveryAddress =
        HiveDbServices(Constants.delivery_address);
    List<DeliveryInfo>? _deliveryAddList =
        await _localDbForDeliveryAddress.getData();

    var value = await SharedPre.getStringValue(SharedPre.ISPICKUP);

    _deliveryAddList.forEach((element) {
      if (element.selected == true) {
        if (value == "0") {
          shippingAddressList.add(element);
        }
      } else {}
    });
    return shippingAddressList;
  }

  getDeliveyMethodsItems(bool calledFromOnModelReady) async {
    isAlreadyCalled = true;

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
    isAlreadyCalled = false;
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

  getInvoiceList() async {
    HiveDbServices<InvoiceInfo> _localDbForInvoiceAddress =
        HiveDbServices(Constants.invoice_address);

    List<InvoiceInfo>? _invoiceAddressList =
        await _localDbForInvoiceAddress.getData();
    _invoiceAddressList.forEach((element) {
      if (element.selectedForBilling == true) {
        billingAddressList = _invoiceAddressList;
      }
    });
    return billingAddressList;
  }

  bool _isPickup = true;
  bool get isPickup => _isPickup;
  set isPickup(bool isPickup) {
    _isPickup = isPickup;
    notifyListeners();
  }

  getPicup() async {
    var value = await SharedPre.getBoolValue(SharedPre.ISPICKUP);
    isPickup = value;
  }

  getContactList() async {
    HiveDbServices<ContactInfo> _localDbForContactAddress =
        HiveDbServices(Constants.contact_address);

    List<ContactInfo>? _contactAddressList =
        await _localDbForContactAddress.getData();
    _contactAddressList.forEach((element) {
      if (element.selected == true) {
        contactAddressList = _contactAddressList;
      }
    });
    return contactAddressList;
  }

  // get User Data from local db
  void getUserData() async {
    UserObject? _userData = await _localDbForUserData.get();
    String loginToken = await AppUtil.getLoginToken();

    if (loginToken != null && loginToken.isNotEmpty) {
      if (_userData == null) {
        //setBusy(true);
      } else {
        userDetails = _userData;
      }

      UserProfile? userProfileData = await apiCall.getUserObject();

      switch (userProfileData.statusCode) {
        case Constants.sucessCode:
          await _localDbForUserData.clear();
          if (userProfileData != null && userProfileData.user != null) {
            userDetails = userProfileData.user;
            _localDbForUserData.putData(Constants.user_data, userDetails);
          }

          _userData = await _localDbForUserData.get();

          userDetails = _userData;

          break;
        case Constants.wrongError:
          AppUtil.showDialogbox(AppUtil.getContext(),
              userProfileData.error ?? 'Oops Something went wrong');

          break;
        case Constants.networkErroCode:
          AppUtil.showDialogbox(AppUtil.getContext(),
              userProfileData.error ?? 'Oops Something went wrong');
          break;
        default:
          {
            if (userProfileData.error != null &&
                userProfileData.error!.isNotEmpty) {
              //isAPIError = true;
              AppUtil.showDialogbox(AppUtil.getContext(),
                  userProfileData.error ?? 'Oops Something went wrong');
            }
          }
          break;
      }
    } else {
      AppUtil.showLoginMessageDialog(AppUtil.getContext(),
          'Please Sign In/Register to view your personal details');
    }
  }

  // Get Setup value
  getPickUpType() async {
    getPickupValue = await SharedPre.getStringValue(SharedPre.ISPICKUP);
  }
}
