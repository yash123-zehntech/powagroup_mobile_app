import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/helper_widget/debouncer.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/cart_module/cart_view.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/delivery_view_model.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_methods_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/get_order_totals_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/hive_model.dart/cart_selected_qty.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_page_module/home_page_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/user_module/profile/response_model.dart/user_profile_model.dart';
import 'package:powagroup/util/app_data.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/shared_preference.dart';
import 'package:powagroup/util/util.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../../app/locator.dart';
import '../../../../../services/hive_db_services.dart';
import '../model/cartItemList.dart';

class ReviewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final debouncer = Debouncer(milliseconds: 1000);
  String _value = "Review Order";
  String _dropDownAccount = '';
  String _choosevalue = '';
  String get index => _value;
  //double itemTotalPrice = 0;
  double totalPriceOfItem = 0;

  double untaxtedAmount = 0;
  //double taxAmount = 0;

  double totalTaxAmount = 0;
  int _itemCount = 0;

  HiveDbServices<UserObject> _localDb = HiveDbServices(Constants.user_data);
  Api apiCall = locator<Api>();
  UserObject? userDetails;

  // List<ProductData> _cartProductList = List.empty(growable: true);

  List<ProductData> _cartProductList = [];
  //  List<ProductData> get cartProductList => _cartProductList;
  //  set cartProductList(List<ProductData> list) {
  // _cartProductList = list;
  // notifyListeners(); // Notify listeners when cartProductList changes
  // }
  static HiveDbServices<ProductData> _cartLocalDB =
      HiveDbServices(Constants.cart_product);
  static HiveDbServices<CartItemList> _localDbForCartItemList =
      HiveDbServices(Constants.cart_item);

  // static HiveDbServices<CartSelectedValue> _selectedCartQTYLocalDB =
  //     HiveDbServices(Constants.selected_cart_details);

  static List<CartSelectedValue> cartSelectedQTYList =
      List.empty(growable: true);

  set value(String value) {
    _value = value;
    notifyListeners();
  }

  int get itemCount => _itemCount;
  set itemCount(int itemCount) {
    _itemCount = itemCount;
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

  double _deliveryCharge = 0.0;
  double get deliveryCharge => _deliveryCharge;
  set deliveryCharge(double value) {
    _deliveryCharge = value;
    notifyListeners();
  }

  GetOrderTotalsResponse? _getOrderTotalsResponse;
  GetOrderTotalsResponse? get getOrderTotalsResponse => _getOrderTotalsResponse;
  set getOrderTotalsResponse(GetOrderTotalsResponse? value) {
    _getOrderTotalsResponse = value;
    notifyListeners();
  }

  String get dropDownAccount => _dropDownAccount;
  set dropDownAccount(String dropDownAccount) {
    _dropDownAccount = dropDownAccount;
    notifyListeners();
  }

  List<ProductData> get cartProductList => _cartProductList;
  set cartProductList(List<ProductData> cartProductList) {
    _cartProductList = cartProductList;
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

  String get choosevalue => _choosevalue;
  set choosevalue(String choosevalue) {
    _choosevalue = choosevalue;
    notifyListeners();
  }

  bool _showPricing = false;
  bool get showPricing => _showPricing;
  set showPricing(bool value) {
    _showPricing = value;
    notifyListeners();
  }

  bool _showLoaderForOrderTotal = true;
  bool get showLoaderForOrderTotal => _showLoaderForOrderTotal;
  set showLoaderForOrderTotal(bool value) {
    _showLoaderForOrderTotal = value;
    notifyListeners();
  }

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      _isInitialized = true;
      _showPricing = await AppUtil.getShowPricing();
      List<ProductData> cartProductList = await AppUtil.getCartList();
      if (cartProductList != null && cartProductList.isNotEmpty) {
        _cartProductList = cartProductList;

        notifyListeners();
      }
    }
  }

  setPickup(String value) async {
    await SharedPre.setStringValue(SharedPre.ISPICKUP, value);
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
    List<DeliveryMethod>? localdbData =
        await _localDbForDeliveryMethods.getData();

    if (localdbData.isEmpty) {
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

  onNextButtonClick(BuildContext context) {
    // navigationService.navigateTo(Routes.homePageView,
    //     arguments: HomePageViewArguments(
    //       number: 3,
    //       numberforCart: 1,
    //     ));
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: CartView(
          index: 1,
        ));
  }

  // Update or add controller value by index
  updateControllerValue(index, value, price, productId) async {
    try {
      if (cartProductList[index].controllerForCart == null) {
        cartProductList[index].controllerForCart = TextEditingController();

        cartProductList[index].yashValue = value.toString();
        cartProductList[index].controllerForCart!.text =
            value.replaceAll(".0", "").toString();

        cartProductList[index].priceTotal = price;
      } else {
        cartProductList[index].yashValue = value.toString();
        cartProductList[index].controllerForCart!.text =
            value.replaceAll(".0", "").toString();

        cartProductList[index].priceTotal = price;
      }
      cartProductList[index].priceByQty = price.toString();

      _cartLocalDB.clear();

      _cartLocalDB.putListData(cartProductList);
    } catch (e) {}

    notifyListeners();
  }

  // Delete Product from list and local database
  deleteProduct(ProductData productData, ReviewModel viewModel, context) async {
    AppUtil.onAddToTruckClick(productData, true, viewModel);
    List<ProductData> cartProductList = await AppUtil.getCartList();
    viewModel.cartProductList = cartProductList;
    notifyListeners();
  }

  // get User Data from local db
  void getUserData() async {
    UserObject? _userData = await _localDb.get();
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
          await _localDb.clear();
          if (userProfileData != null && userProfileData.user != null) {
            userDetails = userProfileData.user;
            _localDb.putData(Constants.user_data, userDetails);
          }

          _userData = await _localDb.get();

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
      //setBusy(false);
    } else {
      AppUtil.showLoginMessageDialog(AppUtil.getContext(),
          'Please Sign In/Register to view your personal details');
    }
  }

  // double getTotalProductAmount() {
  //   double totalProductAmount =
  //       totalPriceOfItem + deliveryCharge + totalTaxAmount;

  //   return totalProductAmount;
  // }
  // double getTotalProductAmount() {
  //   double totalProductAmount = 0;
  //   try {
  //     totalProductAmount =
  //         getItemTotalPrice() + getItemDeliveryCharges() + getTaxAmount();
  //   } catch (e) {}

  //   return totalProductAmount;
  // }

  getBedgeCount() async {
    itemCount = await AppUtil.getCartProductLength();
    notifyListeners();
  }

  // get QTY value
  TextEditingController getQTYValue(
      TextEditingController? dropDownControllerValue) {
    TextEditingController qtyValue = TextEditingController();
    if (dropDownControllerValue!.text.contains(".0")) {
      qtyValue.text = dropDownControllerValue.text.replaceAll(".0", "");
    } else {
      qtyValue.text = dropDownControllerValue.text;
    }

    return qtyValue;
  }

  // Get Setup value
  getPickUpType() async {
    getPickupValue = await SharedPre.getStringValue(SharedPre.ISPICKUP);
  }
}
