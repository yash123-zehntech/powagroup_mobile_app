import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/connectivity.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_methods_response.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/job_product_item_module/job_product_item_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_subcategory_response.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/product_detail_view.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_model.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/shared_preference.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../product_detail_module.dart/response_model/favorite_detail_model.dart';
import '../create_jobList_dropdown model/response_model/joblist_hive_model.dart';

class FavoriteViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  Map sourceMap = {ConnectivityResult.none: false};
  final MyConnectivity connectivity = MyConnectivity.instance;
  bool? isNetworkConnected;
  final HiveDbServices<JobListData> _localDb =
      HiveDbServices(Constants.createjobs);
  bool isAllProductClicked = false;
  bool isJobProductClicked = true;
  bool _isLocalDBAlreadyCalled = false;
  bool isConnectionNotReady = false;
  int? groupValue = 0;
  String? value = "True";
  List<JobListData> jobList = List.empty(growable: true);
  List<ProductData> _productList = List.empty(growable: true);
  int _itemCount = 0;
  late ProductData data;
  FavoriteResponseModel? favoriteResponseModel;
  bool _isCalling = false;

  bool get isCalling => _isCalling;
  set isCalling(bool isCalling) {
    _isCalling = isCalling;
    notifyListeners();
  }

  List<ProductData> get productList => _productList;
  // ProductData? productData;

  set productList(List<ProductData> productList) {
    _productList = productList;
    notifyListeners();
  }

  Api apiCall = locator<Api>();

  List<ProductData> _allProductList = List.empty(growable: true);

  bool _isAPIError = false;
  bool _isAlreadyCalled = false;
  bool get isAPIError => _isAPIError;
  set isAPIError(bool isAPIError) {
    _isAPIError = isAPIError;
    notifyListeners();
  }

  List<ProductData> get allProductList => _allProductList;

  set allProductList(List<ProductData> allProductList) {
    _allProductList = allProductList;
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

  List<SubCategoryData> _subCategoryList = [];

  // List<ProductData> _favProductList = [];

  ProductData? productData;

  List<ProductData> _favProductList = List.empty(growable: true);

  List<ProductData> get favProductList => _favProductList;

  set favProductList(List<ProductData> productListWithPrice) {
    _favProductList = favProductList;
    notifyListeners();
  }

  List<ProductData> _favProductListWithPrice = List.empty(growable: true);

  List<ProductData> get favProductListWithPrice => _favProductListWithPrice;

  set favProductListWithPrice(List<ProductData> favProductListWithoutPrice) {
    _favProductListWithPrice = favProductListWithoutPrice;
    notifyListeners();
  }

  bool get isLocalDBAlreadyCalled => _isLocalDBAlreadyCalled;

  set isLocalDBAlreadyCalled(bool isLocalDBAlreadyCalled) {
    _isLocalDBAlreadyCalled = isLocalDBAlreadyCalled;
    notifyListeners();
  }

  List<DeliveryMethod> _deliveryMethodsList = List.empty(growable: true);

  List<DeliveryMethod> get deliveryMethodsList => _deliveryMethodsList;

  set deliveryMethodsList(List<DeliveryMethod> deliveryMethodsList) {
    _deliveryMethodsList = deliveryMethodsList;
    notifyListeners();
  }

  bool get isAlreadyCalled => _isAlreadyCalled;

  set isAlreadyCalled(bool isAlreadyCalled) {
    _isAlreadyCalled = isAlreadyCalled;

    try {
      Future.delayed(const Duration(seconds: 4), () {
        notifyListeners();
      });
    } catch (error) {}
  }

  // on login buttion clik
  onTabItemClicked() {
    if (isAllProductClicked) {
      isAllProductClicked = false;
      isJobProductClicked = true;
    } else if (isJobProductClicked) {
      isJobProductClicked = false;
      isAllProductClicked = true;
    }
    notifyListeners();
  }

  // on Click Job Product Item
  onJobProductItemClick(JobListData jobList, List<JobListProduct>? productsList,
      String jobName, String jobDate, BuildContext context) {
    if (productsList != null && productsList.isNotEmpty) {
      productsList.forEach((element) {
        if (element.controllerForJobList == null) {
          element.controllerForJobList = TextEditingController(
              text: element.yashValue != null && element.yashValue!.isNotEmpty
                  ? element.yashValue!.replaceAll(".0", "")
                  : element.qtyBreaks![0].qty!.replaceAll(".0", ""));
        } else {}
      });
    }

    PersistentNavBarNavigator.pushNewScreen(
        withNavBar: true,
        context,
        screen: JobProductItemView(
            jobList: jobList,
            productsList: productsList,
            jobName: jobName,
            jobDate: jobDate));
  }

  onAddToTruck() {
    navigationService.navigateTo(Routes.returnView);
  }

  // Call API for all Product
  getAllFavouriteProduct(value, bool calledFromOnModelReady) async {
    String loginToken = await AppUtil.getLoginToken();

    if (loginToken != null && loginToken.isNotEmpty) {
      if (!calledFromOnModelReady) {
        isAlreadyCalled = true;
      } else {
        isAlreadyCalled = false;
      }
      allProductList.clear();
      _favProductList.clear();
      HiveDbServices<ProductData> _localDb =
          HiveDbServices(Constants.all_fav_product);

      _favProductList = await _localDb.getData();

      if (_favProductList.isEmpty) {
        setBusy(true);
      } else {
        allProductList = _favProductList;
      }
      Map<String, dynamic> requestBody = {
        // "product_list": [
        //   {"id": 10021, "quantity": 1}
        // ]
      };

      ProductSubCategoriesItemsResponse productSubCategoriesItemsResponse =
          await apiCall.getAllFavouriteProduct1(value, jsonEncode(requestBody));

      switch (productSubCategoriesItemsResponse.statusCode) {
        case Constants.sucessCode:
          await _localDb.clear();
          int userId = await AppUtil.getUserId();
          if (productSubCategoriesItemsResponse != null &&
              productSubCategoriesItemsResponse.productResult! != null &&
              productSubCategoriesItemsResponse.productResult!.products !=
                  null &&
              productSubCategoriesItemsResponse
                  .productResult!.products!.isNotEmpty) {
            favProductList.clear();
            productSubCategoriesItemsResponse.productResult!.products!
                .forEach((element) {
              favProductList.add(ProductData(
                  userId: userId,
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
                  sku: element.sku.toString(),
                  deliveryEx: productSubCategoriesItemsResponse
                      .productResult!.delivery_ex,
                  deliveryInc: productSubCategoriesItemsResponse
                      .productResult!.delivery_inc,
                  deliveryTax: productSubCategoriesItemsResponse
                      .productResult!.delivery_tax,
                  yashValue:
                      element.qtyBreaks != null && element.qtyBreaks!.isNotEmpty
                          ? element.qtyBreaks![0].qty!.replaceAll(".0", "")
                          : ""));
            });
          }

          // _localDb.putListData(favProductList);
          // allProductList = await _localDb.getData();

          break;
        case Constants.wrongError:
          isAPIError = true;
          AppUtil.showDialogbox(
              AppUtil.getContext(),
              productSubCategoriesItemsResponse.error ??
                  'Oops Something went wrong');

          break;
        case Constants.networkErroCode:
          isAPIError = true;
          AppUtil.showDialogbox(
              AppUtil.getContext(),
              productSubCategoriesItemsResponse.error ??
                  'Oops Something went wrong');
          break;
        default:
          {
            if (productSubCategoriesItemsResponse.error != null &&
                productSubCategoriesItemsResponse.error!.isNotEmpty) {
              isAPIError = true;
              AppUtil.showDialogbox(
                  AppUtil.getContext(),
                  productSubCategoriesItemsResponse.error ??
                      'Oops Something went wrong');
            }
          }
          break;
      }

      setBusy(false);
    } else {
      AppUtil.showLoginMessageDialog(AppUtil.getContext(),
          'Please Sign In/Register to view your favorite products');
    }
  }

  getAllFavouriteProductWithPrice(value, bool calledFromOnModelReady) async {
    String loginToken = await AppUtil.getLoginToken();

    if (loginToken != null && loginToken.isNotEmpty) {
      if (!calledFromOnModelReady) {
        isAlreadyCalled = true;
      } else {
        isAlreadyCalled = false;
      }
      allProductList.clear();
      _favProductListWithPrice.clear();
      HiveDbServices<ProductData> _localDb =
          HiveDbServices(Constants.all_fav_product);
      _favProductListWithPrice = await _localDb.getData();

      if (_favProductListWithPrice.isEmpty) {
        setBusy(true);
      } else {
        allProductList = _favProductListWithPrice;
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

      Map<String, dynamic> requestBody = {
        // "delivery_method_id": deliveryMethodId,
        "only_pricing": 1,
      };

      ProductSubCategoriesItemsResponse productSubCategoriesItemsResponse =
          await apiCall.getAllFavouriteProduct1(value, jsonEncode(requestBody));

      switch (productSubCategoriesItemsResponse.statusCode) {
        case Constants.sucessCode:
          // await _localDb.clear();
          // int userId = await AppUtil.getUserId();

          if (productSubCategoriesItemsResponse != null &&
              productSubCategoriesItemsResponse.productResult! != null &&
              productSubCategoriesItemsResponse.productResult!.products !=
                  null &&
              productSubCategoriesItemsResponse
                  .productResult!.products!.isNotEmpty) {
            favProductListWithPrice.clear();
            productSubCategoriesItemsResponse.productResult!.products!
                .forEach((element) {
              favProductListWithPrice.add(ProductData(
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
                  deliveryEx: productSubCategoriesItemsResponse
                      .productResult!.delivery_ex,
                  deliveryInc: productSubCategoriesItemsResponse
                      .productResult!.delivery_inc,
                  deliveryTax: productSubCategoriesItemsResponse
                      .productResult!.delivery_tax,
                  yashValue:
                      element.qtyBreaks != null && element.qtyBreaks!.isNotEmpty
                          ? element.qtyBreaks![0].qty!.replaceAll(".0", "")
                          : ""));
            });
          }

          // _localDb.putListData(_favProductListWithPrice);
          // allProductList = await _localDb.getData();
          mergeProductLists(favProductList, favProductListWithPrice);

          break;
        case Constants.wrongError:
          isAPIError = true;
          AppUtil.showDialogbox(
              AppUtil.getContext(),
              productSubCategoriesItemsResponse.error ??
                  'Oops Something went wrong');

          break;
        case Constants.networkErroCode:
          isAPIError = true;
          AppUtil.showDialogbox(
              AppUtil.getContext(),
              productSubCategoriesItemsResponse.error ??
                  'Oops Something went wrong');
          break;
        default:
          {
            if (productSubCategoriesItemsResponse.error != null &&
                productSubCategoriesItemsResponse.error!.isNotEmpty) {
              isAPIError = true;
              AppUtil.showDialogbox(
                  AppUtil.getContext(),
                  productSubCategoriesItemsResponse.error ??
                      'Oops Something went wrong');
            }
          }
          break;
      }

      setBusy(false);
    } else {
      AppUtil.showLoginMessageDialog(AppUtil.getContext(),
          'Please Sign In/Register to view your favorite products');
    }
  }

  List<ProductData> mergeProductLists(
      List<ProductData> list1, List<ProductData> list2) {
    List<ProductData> mergedList = [];
    for (ProductData item1 in list1) {
      for (ProductData item2 in list2) {
        if (item1.id == item2.id) {
          // If IDs match, create a new ProductData object with data from both lists
          ProductData mergedItem = ProductData(
              userId: item1.userId ?? item2.userId,
              id: item1.id ?? item2.id,
              name: item1.name ?? item2.name,
              yashValue: item2.yashValue,
              price: item1.price ?? item2.price,
              priceUntaxed: item2.priceUntaxed,
              mainImageUrl: item1.mainImageUrl,
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

    allProductList = mergedList;

    // _localDb.putListData(allProductList);

    try {
      // // allProductList.add(mergedList);
      // SubCategoryData subCategoryData =
      //     SubCategoryData(subCategoryId: "", productsList: allProductList);

      // _subCategoryList.add(subCategoryData);

      // _localDb.putListData(_subCategoryList);
      HiveDbServices<ProductData> _localDb =
          HiveDbServices(Constants.all_fav_product);
      _localDb.putListData(allProductList);
    } catch (e) {}
    setBusy(false);
    return allProductList;
  }

  getJobProductList() async {
    jobList = await _localDb.getData();
    if (jobList != null && jobList.isNotEmpty) {
      jobList.forEach((element) {});
    }
  }

  getBedgeCount() async {
    itemCount = await AppUtil.getCartProductLength();
    notifyListeners();
  }

  getLocalDataList() async {
    HiveDbServices<ProductData> _localDb =
        HiveDbServices(Constants.all_fav_product);
    List<ProductData>? _favProductList = await _localDb.getData();
    isLocalDBAlreadyCalled = true;

    allProductList = _favProductList;
    notifyListeners();
    return allProductList;
  }

  deleteProduct(
    var subCategoryId,
  ) async {
    HiveDbServices<ProductData> _localDb =
        HiveDbServices(Constants.all_fav_product);
    allProductList.removeWhere(
        (element) => element.id.toString() == subCategoryId.toString());

    _localDb.clear();
    AppUtil.showSnackBar('Product removed from favourite successfully');
    _localDb.putListData(allProductList);

    notifyListeners();
  }

  removeFromFavorite(var subCategoryId) async {
    notifyListeners();
    var body = {
      "fav": "False",
    };

    favoriteResponseModel =
        await apiCall.checkFavoritePorduct(jsonEncode(body), subCategoryId);

    switch (favoriteResponseModel!.statusCode) {
      case Constants.sucessCode:
        deleteProduct(
          subCategoryId,
        );
        notifyListeners();

        break;
      case Constants.wrongError:
        AppUtil.showDialogbox(AppUtil.getContext(),
            favoriteResponseModel!.error ?? "Something Went Wrong");

        notifyListeners();

        break;
      case Constants.networkErroCode:
        AppUtil.showDialogbox(AppUtil.getContext(),
            favoriteResponseModel!.error ?? "Something Went Wrong");
        // AppUtil.showToast(loginResp.error ?? '');
        break;
      default:
        {
          if (favoriteResponseModel!.error != null &&
              favoriteResponseModel!.error!.isNotEmpty) {}
        }
        break;
    }

    notifyListeners();
  }

  deleteJobList(String? id) async {
    jobList.removeWhere((element) => element.id == id);
    // viewModel.jobList = await AppUtil.getJobProductList();

    final HiveDbServices<JobListData> _localDb =
        HiveDbServices(Constants.createjobs);
    _localDb.clear();
    _localDb.putListData(jobList);
    jobList = await AppUtil.getJobProductList();
    getJobProductList();
    notifyListeners();
  }

  // on login buttion clik
  onProductSubCategoryItemClick(ProductData productData) async {
    await Navigator.push(
        AppUtil.getContext(),
        MaterialPageRoute(
            builder: ((context) =>
                ProductDetialView(productObj: productData, fromFav: true))));
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
