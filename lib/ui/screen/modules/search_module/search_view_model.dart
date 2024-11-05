import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/helper_widget/debouncer.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/connectivity.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_methods_response.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/create_job_list_selected.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/response_model/joblist_hive_model.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_job_list_module/create_job_list_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/product_detail_view.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/favorite_detail_model.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_model.dart';
import 'package:powagroup/ui/screen/modules/search_module/response_model/search_product_response.dart';
// import 'package:powagroup/ui/screen/modules/search_module/response_model/search_product_response.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchViewModel extends BaseViewModel {
  final _debouncer = Debouncer(milliseconds: 1000);
  TextEditingController searchController = TextEditingController();
  final navigationService = locator<NavigationService>();
  Api apiCall = locator<Api>();
  HiveDbServices<ProductData> _localDb =
      HiveDbServices(Constants.all_recent_list);
  SearchResponse? searchProductResponse;
  Map sourceMap = {ConnectivityResult.none: false};

  int _itemCount = 0;

  List<JobListData> jobList = List.empty(growable: true);

  final MyConnectivity connectivity = MyConnectivity.instance;
  bool? isNetworkConnected;
  bool _isChangedEditField = false;
  var _selectedIndex;

  int get selectedIndex => _selectedIndex;
  set selectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    notifyListeners();
  }

  //int _listLenght = -1;
  bool _noDataFound = false;
  FocusNode searchFieldFocus = FocusNode();

  bool get isChangedEditField => _isChangedEditField;
  set isChangedEditField(bool isChangedEditField) {
    _isChangedEditField = isChangedEditField;
    notifyListeners();
  }

  bool setsearchTap = false;
  bool get searchTap => setsearchTap;
  set searchTap(bool searchTap) {
    setsearchTap = searchTap;
    notifyListeners();
  }

  int get itemCount => _itemCount;
  set itemCount(int itemCount) {
    _itemCount = itemCount;
    notifyListeners();
  }

  bool _isAPIError = false;

  bool get isAPIError => _isAPIError;
  set isAPIError(bool isAPIError) {
    _isAPIError = isAPIError;
    notifyListeners();
  }

  List<DeliveryMethod> _deliveryMethodsList = List.empty(growable: true);

  List<DeliveryMethod> get deliveryMethodsList => _deliveryMethodsList;

  set deliveryMethodsList(List<DeliveryMethod> deliveryMethodsList) {
    _deliveryMethodsList = deliveryMethodsList;
    notifyListeners();
  }

  List<ProductData> _searchList = List.empty(growable: true);

  List<ProductData> get searchList => _searchList;
  set searchList(List<ProductData> searchList) {
    _searchList = searchList;
    notifyListeners();
  }

  bool get noDataFound => _noDataFound;

  set noDataFound(bool noDataFound) {
    _noDataFound = noDataFound;
    notifyListeners();
  }

  onItemChanged() {
    if (searchController.text.isNotEmpty) {
      if (searchController.text.length <= 2) {
        AppUtil.showSnackBar("Minimum 2 charactors required");
      } else {
        setsearchTap = true;
        notifyListeners();
        _debouncer.run(() {
          if (searchController.text.trim().isNotEmpty) {
            searchFieldFocus.unfocus();
            callSearchAPI(searchController.text);
          }
        });
      }
    } else {
      getSearchLocaldata();
    }
  }

  clearList() {
    if (searchProductResponse != null &&
        searchProductResponse!.productResult != null &&
        searchProductResponse!.productResult!.products != null) {
      searchProductResponse!.productResult!.products!.clear();
      notifyListeners();
    }
  }

  checkConnection() {
    connectivity.myStream.listen((source) {
      sourceMap = source;

      switch (sourceMap.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          isNetworkConnected = true;

          notifyListeners();
          break;
        case ConnectivityResult.wifi:
          isNetworkConnected = true;

          notifyListeners();
          break;
        case ConnectivityResult.none:
        default:
          isNetworkConnected = false;
          searchFieldFocus.unfocus();

          notifyListeners();
      }
    });
    notifyListeners();
  }

  // Call Global Search API for Product
  callSearchAPI(String key) async {
    setBusy(true);

    // Map<String, dynamic> requestBody = {
    //   // "product_list": [
    //   //   {"id": 10021, "quantity": 1}
    //   // ]

    // };
    final Map<String, dynamic> requestBody = {
      "search": key,
      //"include_pricing": 1
    };

    searchProductResponse =
        await apiCall.getProductBySearchKey(jsonEncode(requestBody));

    switch (searchProductResponse!.statusCode) {
      case Constants.sucessCode:
        if (searchProductResponse != null &&
            searchProductResponse!.productResult != null &&
            searchProductResponse!.productResult!.products != null) {
          if (searchProductResponse!.productResult!.products!.isNotEmpty) {
            noDataFound = false;
          } else {
            noDataFound = true;
            searchFieldFocus.unfocus();
          }
          notifyListeners();
        }
        break;
      case Constants.wrongError:
        isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            searchProductResponse!.error ?? 'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            searchProductResponse!.error ?? 'Oops Something went wrong');
        break;
      default:
        {
          if (searchProductResponse!.error != null &&
              searchProductResponse!.error!.isNotEmpty) {
            isAPIError = true;
            AppUtil.showDialogbox(AppUtil.getContext(),
                searchProductResponse!.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    setBusy(false);
  }

  onItemClick(ProductData product, BuildContext context) {
    saveProductToLoccal(product);

    PersistentNavBarNavigator.pushNewScreen(context,
        screen: ProductDetialView(
          productObj: product,
        ));
  }

  clickForJob(ProductData? searchList) async {
    searchFieldFocus.unfocus();
    jobList.clear();
    jobList = await AppUtil.getJobProductList();
    if (jobList.isEmpty || jobList.length == []) {
      await Navigator.of(AppUtil.getContext()).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => CreateJoblistView(
                productData: searchList,
                index: 0,
                //key: key,
                //title: 'title',
              )));
    } else {
      await Navigator.of(AppUtil.getContext()).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => CreateJoblistSelected(
                productData: searchList,
              )));
    }
    //Navigator.of(AppUtil.getContext()).pop();
    jobList = await AppUtil.getJobProductList();
  }

  // save Selected Product to local database
  saveProductToLoccal(ProductData product) async {
    searchList = await _localDb.getData();

    searchList.removeWhere(
        (element) => element.id.toString() == product.id.toString());

    searchList.add(product);

    _localDb.clear();
    await _localDb.putListData(searchList);
  }

  getSearchLocaldata() async {
    searchList = await _localDb.getData();
  }

  delete(ProductData data) async {
    searchList
        .removeWhere((element) => element.id.toString() == data.id.toString());

    _localDb.clear();
    _localDb.putListData(searchList);

    notifyListeners();
  }

  clearLocalList() {
    _localDb.clear();
    searchList.clear();
    notifyListeners();
  }

  getBedgeCount() async {
    itemCount = await AppUtil.getCartProductLength();
    notifyListeners();
  }

  addFavorite(var subCategoryId, ProductData productData) async {
    var body = !productData.isFav!
        ? {
            "fav": "True",
          }
        : {
            "fav": "False",
          };
    FavoriteResponseModel? favoriteResponseModel =
        await apiCall.checkFavoritePorduct(json.encode(body), subCategoryId);

    switch (favoriteResponseModel.statusCode) {
      case Constants.sucessCode:
        if (productData.isFav!) {
          productData.isFav = false;
          AppUtil.showSnackBar("Remove From Favourite");
        } else {
          productData.isFav = true;
          AppUtil.showSnackBar("Added to Favourite");
        }

        break;
      case Constants.wrongError:
        AppUtil.showDialogbox(AppUtil.getContext(),
            favoriteResponseModel.error ?? "Something Went Wrong");

        break;
      case Constants.networkErroCode:
        AppUtil.showDialogbox(AppUtil.getContext(),
            favoriteResponseModel.error ?? "Something Went Wrong");
        // AppUtil.showToast(loginResp.error ?? '');
        break;
      default:
        {
          if (favoriteResponseModel.error != null &&
              favoriteResponseModel.error!.isNotEmpty) {}
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
