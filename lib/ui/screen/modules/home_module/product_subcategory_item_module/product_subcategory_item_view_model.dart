import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/connectivity.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_methods_response.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_response_with_price.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_subcategory_response.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/product_detail_view.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_model.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'response_model/sort_list_item_model.dart';

class ProductSubCategoryItemViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  Map sourceMap = {ConnectivityResult.none: false};
  final MyConnectivity connectivity = MyConnectivity.instance;
  bool? isNetworkConnected;
  String _subCategoryId = '';
  bool _isAlreadyCalled = false;
  bool _isAlreadyCalledOnlyPrice = false;
  bool _isLocalDBAlreadyCalled = false;
  bool _isAPIError = false;
  int _itemCount = 0;
  String _priceUntaxed = "";
  int priceValue = 0;

  ProductSubCategoriesItemsResponse? productSubCategoriesItemsResponse;
  Api apiCall = locator<Api>();
  String getIndexOFlist = "select value";
  List<SubCategoryData> _subCategoryList = [];
  List<SubCategoryData> _subCategoryListWithPrice = [];
  HiveDbServices<SubCategoryData> _localDb = HiveDbServices(Constants.products);

  List<ProductData> _productList = List.empty(growable: true);

  List<ProductData> get productList => _productList;

  set productList(List<ProductData> productList) {
    _productList = productList;
    notifyListeners();
  }

  List<ProductData> _productListWithPrice = List.empty(growable: true);

  List<ProductData> get productListWithPrice => _productListWithPrice;

  set productListWithPrice(List<ProductData> productListWithPrice) {
    _productListWithPrice = productListWithPrice;
    notifyListeners();
  }

  List<DeliveryMethod> _deliveryMethodsList = List.empty(growable: true);

  List<DeliveryMethod> get deliveryMethodsList => _deliveryMethodsList;

  set deliveryMethodsList(List<DeliveryMethod> deliveryMethodsList) {
    _deliveryMethodsList = deliveryMethodsList;
    notifyListeners();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  List<ProductData> _productListWithOutPrice = List.empty(growable: true);
  List<ProductData> get productListWithOutPrice => _productListWithOutPrice;

  set productListWithOutPrice(List<ProductData> productListWithOutPrice) {
    _productListWithOutPrice = productListWithOutPrice;
    notifyListeners();
  }

  int get itemCount => _itemCount;
  set itemCount(int itemCount) {
    _itemCount = itemCount;
    notifyListeners();
  }

  bool _showPricing = false;
  bool get showPricing => _showPricing;
  set showPricing(bool value) {
    _showPricing = value;
    notifyListeners();
  }

  bool _isLoader = false;
  bool get isLoader => _isLoader;
  set isLoader(bool value) {
    _isLoader = value;
    notifyListeners();
  }

  String get priceUntaxed => _priceUntaxed;
  set priceUntaxed(String priceUntaxed) {
    _priceUntaxed = priceUntaxed;
    notifyListeners();
  }

  String get subCategoryId => _subCategoryId;
  set subCategoryId(String subCategoryId) {
    _subCategoryId = subCategoryId;
    notifyListeners();
  }

  bool get isAPIError => _isAPIError;
  set isAPIError(bool isAPIError) {
    _isAPIError = isAPIError;
    notifyListeners();
  }

  bool get isAlreadyCalled => _isAlreadyCalled;

  set isAlreadyCalled(bool isAlreadyCalled) {
    _isAlreadyCalled = isAlreadyCalled;

    try {
      Future.delayed(const Duration(seconds: 1), () {
        notifyListeners();
      });
    } catch (error) {}
  }

  bool get isAlreadyCalledOnlyPrice => _isAlreadyCalledOnlyPrice;

  set isAlreadyCalledOnlyPrice(bool isAlreadyCalledOnlyPrice) {
    _isAlreadyCalledOnlyPrice = isAlreadyCalledOnlyPrice;

    try {
      Future.delayed(const Duration(seconds: 1), () {
        notifyListeners();
      });
    } catch (error) {}
  }

  bool get isLocalDBAlreadyCalled => _isLocalDBAlreadyCalled;

  set isLocalDBAlreadyCalled(bool isLocalDBAlreadyCalled) {
    _isLocalDBAlreadyCalled = isLocalDBAlreadyCalled;
    notifyListeners();
  }

  // get Local Data List
  Future<List<ProductData>> getLocalDataList(String subCategoryId) async {
    isLocalDBAlreadyCalled = true;
    _subCategoryList = await _localDb.getData();

    if (_subCategoryList.isNotEmpty) {
      _subCategoryList.forEach((element) {
        if (element.subCategoryId == subCategoryId.toString()) {
          productList = element.productsList!;
        }
      });
    }

    return productList;
  }

  // on login button click
  onProductSubCategoryItemClick(
      ProductData product, BuildContext context) async {
    dynamic subCategoryId =
        await PersistentNavBarNavigator.pushNewScreen(context,
            screen: ProductDetialView(
              productObj: product,
            ));

    if (subCategoryId != null) {
      getLocalDataList(subCategoryId.toString());
    }
  }

  final List<ListItem> dropdownItems = [
    ListItem(1, "Price: High to Low"),
    ListItem(2, "Price: Low to High"),
    ListItem(3, "Name: A to Z"),
    ListItem(4, "Name: Z to A"),
  ];
  // Call API for product sub category
  getProductSubCategoriesItemsWithoutPrice(
      var subCategoryId, bool calledFromOnModelReady) async {
    if (subCategoryId != null) {
      subCategoryId = subCategoryId;
    }
    _subCategoryList = await _localDb.getData();

    if (_subCategoryList.isEmpty) {
      isLoading = true;
    } else {
      _subCategoryList.forEach((element) {
        if (element.subCategoryId == subCategoryId.toString()) {
          productList = element.productsList!;
        } else {
          productList.clear();
        }
      });
    }

    Map<String, dynamic> requestBody = {
      // "product_list": [
      //   {"id": subCategoryId, "quantity": 1}
      // ]
    };
    productSubCategoriesItemsResponse =
        await apiCall.getProductSubCategoryItem1(
            subCategoryId.toString(), jsonEncode(requestBody));

    if (productSubCategoriesItemsResponse != null) {
      switch (productSubCategoriesItemsResponse!.statusCode) {
        case Constants.sucessCode:
          await _localDb.clear();

          if (productSubCategoriesItemsResponse != null &&
              productSubCategoriesItemsResponse!.productResult != null &&
              productSubCategoriesItemsResponse!.productResult!.products !=
                  null) {
            productSubCategoriesItemsResponse!.productResult!.products!
                .forEach((Product element) {
              productListWithOutPrice.add(
                ProductData(
                    sku: element.sku.runtimeType == bool ? '' : element.sku,
                    extraImages: element.extraImages,
                    id: element.id,
                    mainImageUrl: element.mainImageUrl.runtimeType == bool
                        ? ''
                        : element.mainImageUrl,
                    name: element.name,
                    price: priceValue.toString(),
                    qtyBreaks: element.qtyBreaks,
                    description: element.description.runtimeType == bool
                        ? ''
                        : element.description,
                    priceDelivery: element.priceDelivery,
                    priceTax: element.priceTax,
                    priceTotal:
                        element.qtyBreaks == null || element.qtyBreaks!.isEmpty
                            ? element.priceTotal
                            : element.qtyBreaks![0].price,
                    priceUntaxed: element.qtyBreaks != null &&
                            element.qtyBreaks!.isNotEmpty
                        ? element.qtyBreaks![0].price
                        : element.priceUntaxed,
                    saleUom: element.saleUom.runtimeType == bool
                        ? ''
                        : element.saleUom,
                    isFav: element.isFav,
                    controllerForCart: TextEditingController(),
                    deliveryEx: productSubCategoriesItemsResponse!
                        .productResult!.delivery_ex,
                    deliveryInc: productSubCategoriesItemsResponse!
                        .productResult!.delivery_inc,
                    deliveryTax: productSubCategoriesItemsResponse!
                        .productResult!.delivery_tax,
                    yashValue: element.qtyBreaks != null &&
                            element.qtyBreaks!.isNotEmpty
                        ? element.qtyBreaks![0].qty!.replaceAll(".0", "")
                        : ""),
              );
            });
            //getProductSubCategoriesItemsOnlyPrice(subCategoryId, true);
            //setBusy(false);
          }

          break;
        case Constants.wrongError:
          isAPIError = true;
          AppUtil.showDialogbox(
              AppUtil.getContext(),
              productSubCategoriesItemsResponse!.error ??
                  'Oops Something went wrong');
          //setBusy(false);
          isLoading = false;
          break;
        case Constants.networkErroCode:
          isAPIError = true;
          AppUtil.showDialogbox(
              AppUtil.getContext(),
              productSubCategoriesItemsResponse!.error ??
                  'Oops Something went wrong');
          isLoading = false;
          break;
        default:
          {
            if (productSubCategoriesItemsResponse!.error != null &&
                productSubCategoriesItemsResponse!.error!.isNotEmpty) {
              isAPIError = true;
              AppUtil.showDialogbox(
                  AppUtil.getContext(),
                  productSubCategoriesItemsResponse!.error ??
                      'Oops Something went wrong');
            }
            isLoading = false;
          }
          break;
      }
    }
  }

  getProductSubCategoriesItemsOnlyPrice(
      var subCategoryId, bool calledFromOnModelReady) async {
    if (subCategoryId != null) {
      subCategoryId = subCategoryId;
    }

    if (!calledFromOnModelReady) {
      isAlreadyCalledOnlyPrice = true;
    } else {
      isAlreadyCalledOnlyPrice = false;
    }

    _subCategoryListWithPrice = await _localDb.getData();

    if (_subCategoryListWithPrice.isEmpty) {
    } else {
      _subCategoryListWithPrice.forEach((element) {
        if (element.subCategoryId == subCategoryId.toString()) {
          if (element.productsList != null) {
            productList = element.productsList!;
          }
        }
      });
    }

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

    Future.delayed(Duration(seconds: 2));
    Map<String, dynamic> requestBody = {
      //"delivery_method_id": deliveryMethodId,
      "only_pricing": 1,
    };

    productSubCategoriesItemsResponse =
        await apiCall.getProductSubCategoryItem1(
            subCategoryId.toString(), jsonEncode(requestBody));

    if (productSubCategoriesItemsResponse != null) {
      switch (productSubCategoriesItemsResponse!.statusCode) {
        case Constants.sucessCode:
          productListWithPrice.clear();
          if (productSubCategoriesItemsResponse != null &&
              productSubCategoriesItemsResponse!.productResult != null &&
              productSubCategoriesItemsResponse!.productResult!.products !=
                  null) {
            productSubCategoriesItemsResponse!.productResult!.products!
                .forEach((Product element) {
              productListWithPrice.add(
                ProductData(
                    saleUom: element.saleUom.toString(),
                    description: element.description,
                    id: element.id,
                    extraImages: element.extraImages,
                    mainImageUrl: element.mainImageUrl,
                    name: element.name,
                    priceDelivery: element.priceDelivery,
                    priceTax: element.priceTax,
                    priceTotal:
                        element.qtyBreaks == null || element.qtyBreaks!.isEmpty
                            ? element.priceTotal
                            : element.qtyBreaks![0].price,
                    priceUntaxed: element.priceUntaxed,
                    qtyBreaks: element.qtyBreaks,
                    isFav: element.isFav,
                    sku: element.sku,
                    deliveryEx: element.deliveryEx,
                    deliveryInc: element.deliveryInc,
                    deliveryTax: element.deliveryTax,
                    yashValue: element.qtyBreaks != null &&
                            element.qtyBreaks!.isNotEmpty
                        ? element.qtyBreaks![0].qty!.replaceAll(".0", "")
                        : ""),
              );
            });
          }
          // if (productListWithOutPrice.isEmpty) {
          //   productListWithOutPrice.clear();
          //   await getProductSubCategoriesItemsWithoutPrice(subCategoryId, true);
          // }
          mergeProductLists(productListWithOutPrice, productListWithPrice);

          break;
        case Constants.wrongError:
          isAPIError = true;
          AppUtil.showDialogbox(
              AppUtil.getContext(),
              productSubCategoriesItemsResponse!.error ??
                  'Oops Something went wrong');
          break;
        case Constants.networkErroCode:
          isAPIError = true;
          AppUtil.showDialogbox(
              AppUtil.getContext(),
              productSubCategoriesItemsResponse!.error ??
                  'Oops Something went wrong');
          break;
        default:
          {
            if (productSubCategoriesItemsResponse!.error != null &&
                productSubCategoriesItemsResponse!.error!.isNotEmpty) {
              isAPIError = true;
              AppUtil.showDialogbox(
                  AppUtil.getContext(),
                  productSubCategoriesItemsResponse!.error ??
                      'Oops Something went wrong');
            }
          }
          break;
      }
    }
    isLoading = false;
  }

  List<ProductData> mergeProductLists(
      List<ProductData> list1, List<ProductData> list2) {
    List<ProductData> mergedList = [];
    for (ProductData item1 in list1) {
      for (ProductData item2 in list2) {
        if (item1.id == item2.id) {
          // If IDs match, create a new ProductData object with data from both lists
          ProductData mergedItem = ProductData(
              id: item1.id ?? item2.id,
              name: item1.name ?? item2.name,
              yashValue: item2.yashValue,
              price: item1.price ?? item2.price,
              priceUntaxed: item2.priceUntaxed,
              mainImageUrl: item1.mainImageUrl ?? item1.mainImageUrl,
              deliveryEx: item1.deliveryEx,
              deliveryInc: item1.deliveryInc,
              deliveryTax: item2.deliveryTax,
              description: item1.description,
              extraImages: item1.extraImages,
              isFav: item1.isFav,
              priceByQty: item1.priceByQty,
              priceDelivery: item2.priceDelivery,
              priceTax: item2.priceTax,
              priceTotal: item2.qtyBreaks == null || item2.qtyBreaks!.isEmpty
                  ? item2.priceTotal
                  : item2.qtyBreaks![0].price,
              qtyBreaks: item1.qtyBreaks,
              saleUom: item1.saleUom,
              sku: item1.sku,
              controllerForCart: item1.controllerForCart
              // Add more properties here...
              );
          mergedList.add(mergedItem);
          break; // Stop iterating through list2 once a match is found
        }
      }
    }

    productList = mergedList;

    _subCategoryList.removeWhere((element) =>
        element.subCategoryId.toString() == subCategoryId.toString());

    SubCategoryData subCategoryData = SubCategoryData(
        subCategoryId: subCategoryId, productsList: productList);

    try {
      _subCategoryList.add(subCategoryData);

      _localDb.putListData(_subCategoryList);
    } catch (e) {}

    // isLoader = false;
    setBusy(false);
    return productList;
  }

  getSortList(String name) {
    if (name == "Price: High to Low") {
      productList.sort((a, b) {
        return b.priceUntaxed!.compareTo(a.priceUntaxed!);
      });
      notifyListeners();
    } else if (name == "Price: Low to High") {
      productList.sort((a, b) {
        return a.priceUntaxed!.compareTo(b.priceUntaxed!);
      });
      notifyListeners();
    } else if (name == "Name: A to Z") {
      //Ascending Order

      productList.sort((a, b) {
        String resultFirst = a.name!.toLowerCase().replaceAll("*po* ", '');
        String resultSecond = b.name!.toLowerCase().replaceAll("*po* ", '');

        String firstList =
            resultFirst.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z]'), '');
        String secondList =
            resultSecond.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z]'), '');

        return firstList.compareTo(secondList);
      });

      notifyListeners();
    } else if (name == "Name: Z to A") {
      // Descending order by Name

      productList.sort((a, b) {
        String resultFirst = a.name!.toLowerCase().replaceAll("*po* ", '');
        String resultSecond = b.name!.toLowerCase().replaceAll("*po* ", '');

        String firstList =
            resultFirst.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z]'), '');
        String secondList =
            resultSecond.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z]'), '');
        return secondList.compareTo(firstList);
      });

      notifyListeners();
    }
  }

  getBedgeCount() async {
    itemCount = await AppUtil.getCartProductLength();
    notifyListeners();
  }

  String removeSpecialChars(String str) {
    String pattern = r'[^\w\s]+';
    RegExp regex = RegExp(pattern);
    String result = str.toLowerCase().replaceAll("*po* ", '');
    String resultOfRegRExpr = result.toLowerCase().replaceAll(regex, '');

    RegExp regexForNumber = RegExp(r'^\d');
    if (regex.hasMatch(resultOfRegRExpr)) {
      // sort the string here
    } else {}
    // if (str.contains('*po*')) {
    //
    //   str.toLowerCase().replaceAll('*po*', '');
    //
    // }
    // String pattern = r'[^\w\s]+';//po vbhvbdhvbjdf
    // RegExp regex = RegExp(pattern);
    // String result = str.replaceAll(regex, '');

    // Exclude names containing "*PO*"

    return resultOfRegRExpr;
  }

  //r'[^\w\s]+'r'[^a-zA-Z\s]+

  getProductDetailswithPrice(subCategoryId, bool calledFromOnModelReady) async {
    // Map<String, dynamic> formData = {
    //   'product_list': [
    //     {'id': 10021, 'quantity': 1}
    //   ]
    // };
    Map<String, dynamic> requestBody = {
      "include_pricing": 1,
      'product_list': [
        {'id': subCategoryId, 'quantity': 1}
      ]
    };

    ProductResponseWithPrice productResponseWithPrice = await apiCall
        .getProductDetailswithPrice1(requestBody, subCategoryId.toString());

    switch (productResponseWithPrice.statusCode) {
      case Constants.sucessCode:
        break;
      case Constants.wrongError:
        isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            productResponseWithPrice.error ?? 'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            productResponseWithPrice.error ?? 'Oops Something went wrong');
        break;
      default:
        {
          if (productResponseWithPrice.error != null &&
              productResponseWithPrice.error!.isNotEmpty) {
            isAPIError = true;
            AppUtil.showDialogbox(AppUtil.getContext(),
                productResponseWithPrice.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
  }

  // get Item price
  Future<ProductSubDetailModel> getItemPrice(productId) async {
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
    Map<String, dynamic> requestBody = {
      "only_pricing": 1,
      "delivery_method_id": deliveryMethodId,
      "product_list": [
        {"id": productId, "quantity": 1}
      ]
    };

    ProductSubDetailModel productSubDetailModelResponse = await apiCall
        .getProductDetailPageItem(requestBody, productId.toString());

    switch (productSubDetailModelResponse.statusCode) {
      case Constants.sucessCode:
        return productSubDetailModelResponse;

      case Constants.wrongError:
        isAPIError = true;
        AppUtil.showDialogbox(
            AppUtil.getContext(),
            productSubDetailModelResponse!.error ??
                'Oops Something went wrong');
        return productSubDetailModelResponse;

      case Constants.networkErroCode:
        isAPIError = true;
        AppUtil.showDialogbox(
            AppUtil.getContext(),
            productSubDetailModelResponse!.error ??
                'Oops Something went wrong');
        return productSubDetailModelResponse;
      default:
        {
          if (productSubDetailModelResponse!.error != null &&
              productSubDetailModelResponse!.error!.isNotEmpty) {
            isAPIError = true;
            AppUtil.showDialogbox(
                AppUtil.getContext(),
                productSubDetailModelResponse!.error ??
                    'Oops Something went wrong');
          }
        }
        return productSubDetailModelResponse;
    }
  }
}
