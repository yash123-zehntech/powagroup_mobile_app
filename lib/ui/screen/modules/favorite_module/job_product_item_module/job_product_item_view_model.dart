import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/helper_widget/debouncer.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/cart_module/cart_view.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_methods_response.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/confirmation_module/confirmation_view.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/response_model/joblist_hive_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_page_module/home_page_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/product_detail_view.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_model.dart';
import 'package:powagroup/ui/screen/modules/search_module/search_view.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../all_product_module/favorite_view.dart';

class JobProductItemViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final bottomSheetService = locator<BottomSheetService>();
  ScrollController scrollController = new ScrollController();
  bool isShowModelPopup = false;
  int _itemCount = 0;
  Api apiCall = locator<Api>();

  static HiveDbServices<ProductData> _cartLocalDB =
      HiveDbServices(Constants.cart_product);
  List<SubCategoryData> _subCategoryList = [];
  List<ProductData> _productList = List.empty(growable: true);
  List<JobListProduct> _jobListProduct = List.empty(growable: true);
  HiveDbServices<SubCategoryData> _localDb = HiveDbServices(Constants.products);
  final HiveDbServices<JobListData> _localDbGorJob =
      HiveDbServices(Constants.createjobs);

  ProductData? productJobDetail;
  int get itemCount => _itemCount;

  final debouncer = Debouncer(milliseconds: 1000);
  set itemCount(int itemCount) {
    _itemCount = itemCount;
    notifyListeners();
  }

  List<JobListData> getJobListItem = List.empty(growable: true);
  bool _isLocalDBAlreadyCalled = false;
  bool get isLocalDBAlreadyCalled => _isLocalDBAlreadyCalled;

  set isLocalDBAlreadyCalled(bool isLocalDBAlreadyCalled) {
    _isLocalDBAlreadyCalled = isLocalDBAlreadyCalled;
    notifyListeners();
  }

  bool _isAPIError = false;
  bool get isAPIError => _isAPIError;
  set isAPIError(bool isAPIError) {
    _isAPIError = isAPIError;
    notifyListeners();
  }

  double _deliveryEX = 0.0;
  double get deliveryEX => _deliveryEX;
  set deliveryEX(double deliveryEX) {
    _deliveryEX = deliveryEX;
    notifyListeners();
  }

  bool _showPricing = false;
  bool get showPricing => _showPricing;
  set showPricing(bool value) {
    _showPricing = value;
    notifyListeners();
  }

  List<DeliveryMethod> _deliveryMethodsList = List.empty(growable: true);

  List<DeliveryMethod> get deliveryMethodsList => _deliveryMethodsList;

  set deliveryMethodsList(List<DeliveryMethod> deliveryMethodsList) {
    _deliveryMethodsList = deliveryMethodsList;
    notifyListeners();
  }

  List<ProductData> get productList => _productList;

  set productList(List<ProductData> productList) {
    _productList = productList;
    notifyListeners();
  }

  List<JobListProduct> get jobListProduct => _jobListProduct;

  set jobListProduct(List<JobListProduct> jobListProduct) {
    _jobListProduct = jobListProduct;
    notifyListeners();
  }

  // on login buttion clik
  onProductItemClick(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context, screen: SearchView());
    // PersistentNavBarNavigator.pushNewScreen(context,
    //     screen: ConfirmationView());
  }

  getBedgeCount() async {
    itemCount = await AppUtil.getCartProductLength();
    notifyListeners();
  }

  // Update or add controller value by index
  updateControllerValue1(
      JobListData? jobListData,
      index,
      String value,
      price,
      List<JobListProduct> productsList,
      String? jobName,
      String? jobDate) async {
    HiveDbServices<JobListData> localDbforJob =
        HiveDbServices(Constants.createjobs);

    List<JobListData> jobList = await localDbforJob.getData();

    if (jobList != null && jobList.isNotEmpty) {
      jobList.asMap().forEach((i, element) async {
        if (jobList[i].jobName!.toLowerCase() == jobName!.toLowerCase()) {
          jobList[i].jobDate = jobDate;

          if (jobList[i].productsList![index].controllerForJobList == null) {
            jobList[i].productsList![index].controllerForJobList =
                TextEditingController();

            jobList[i].productsList![index].yashValue = value.toString();
            jobList[i].productsList![index].controllerForJobList!.text =
                value.replaceAll(".0", "");
            // jobList[i].productsList![index].priceUntaxed = price;
            jobList[i].productsList![index].priceTotal = price;
          } else {
            jobList[i].productsList![index].yashValue = value.toString();
            jobList[i].productsList![index].controllerForJobList!.text =
                value.replaceAll(".0", "");
            // jobList[i].productsList![index].priceUntaxed = price;
            jobList[i].productsList![index].priceTotal = price;
          }

          jobList[i].productsList![index].priceByQty = price.toString();

          localDbforJob.putAt(
              i,
              JobListData(
                  id: jobListData!.id,
                  description: jobListData.description,
                  jobName: jobName,
                  jobDate: jobDate,
                  productsList: jobList[i].productsList));
        }
      });
    }

    notifyListeners();
  }

  // on Button action click
  onYesButtonActionClick(BuildContext context) async {
    // Navigator.of(AppUtil.getContext()).pop();
    bool result = false;

    result = await PersistentNavBarNavigator.pushNewScreen(context,
        screen: SearchView());
    if (result != null && result) {}
  }

  onBackActionClick(context) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: FavoriteView(),
    );
  }

  // Add Job List to Cart
  addJobListToCart(
      List<JobListProduct>? productsList, BuildContext context) async {
    List<ProductData> cartProductList = await _cartLocalDB.getData();

    ProductSubDetailModel data = await getItemPrice(
      productsList![0].id,
    );

    deliveryEX = data.productResult!.delivery_ex;

    await _cartLocalDB.clear();

    if (cartProductList == null || cartProductList.isEmpty) {
      productsList!.asMap().forEach((index, element) {
        cartProductList.add(ProductData(
            description: productsList[index].description,
            yashValue: productsList[index].yashValue != null &&
                    productsList[index].yashValue!.isNotEmpty
                ? productsList[index].yashValue
                : productsList[index].qtyBreaks!.isNotEmpty
                    ? productsList[index]
                        .qtyBreaks![0]
                        .qty!
                        .replaceAll(".0", "")
                        .toString()
                    : '',
            extraImages: productsList[index].extraImages,
            id: productsList[index].id,
            isFav: productsList[index].isFav,
            mainImageUrl: productsList[index].mainImageUrl,
            name: productsList[index].name,
            price: productsList[index].price,
            priceByQty: productsList[index].priceByQty,
            priceDelivery: productsList[index].priceDelivery!.toDouble(),
            priceTax: productsList[index].priceTax,
            priceTotal: productsList[index].qtyBreaks == null ||
                    productsList[index].qtyBreaks!.isEmpty
                ? productsList[index].priceTotal
                : productsList[index].qtyBreaks![0].price,
            priceUntaxed: productsList[index].priceUntaxed,
            qtyBreaks: productsList[index].qtyBreaks,
            saleUom: productsList[index].saleUom,
            sku: productsList[index].sku,
            deliveryEx: deliveryEX,
            deliveryInc: productsList[index].deliveryInc,
            deliveryTax: productsList[index].deliveryTax

            // selectedQtyValue:
            //     productsList[index].dropDownControllerValueForJobList != null ||
            //             productsList[index].selectedQtyValueForJobList != null
            //         ? productsList[index].selectedQtyValueForJobList.toString()
            //         : productsList[index].qtyBreaks![0].qty.toString()
            ));
      });
    } else {
      productsList!.forEach((element) {
        ProductData productData = cartProductList.firstWhere(
            (data) => data.id.toString() == element.id.toString(), orElse: () {
          return ProductData(
              description: element.description,
              yashValue:
                  element.yashValue != null && element.yashValue!.isNotEmpty
                      ? element.yashValue
                      : element.qtyBreaks!.isNotEmpty
                          ? element.qtyBreaks![0].qty!
                              .replaceAll(".0", "")
                              .toString()
                          : '',
              extraImages: element.extraImages,
              id: element.id,
              isFav: element.isFav,
              mainImageUrl: element.mainImageUrl,
              name: element.name,
              price: element.price,
              priceByQty: element.priceByQty,
              priceDelivery: element.priceDelivery!.toDouble(),
              priceTax: element.priceTax,
              priceTotal:
                  element.qtyBreaks == null || element.qtyBreaks!.isEmpty
                      ? element.priceTotal
                      : element.qtyBreaks![0].price,
              priceUntaxed: element.priceUntaxed,
              qtyBreaks: element.qtyBreaks,
              saleUom: element.saleUom,
              sku: element.sku,
              deliveryEx: deliveryEX,
              deliveryInc: element.deliveryInc,
              deliveryTax: element.deliveryTax
              // selectedQtyValue:
              //     element.dropDownControllerValueForJobList != null &&
              //             element.selectedQtyValueForJobList != null
              //         ? element.selectedQtyValueForJobList.toString()
              //         : element.qtyBreaks![0].qty.toString()
              );
        });

        cartProductList.remove(productData);

        cartProductList.add(ProductData(
            description: element.description,
            yashValue: element.yashValue != null &&
                    element.yashValue!.isNotEmpty
                ? element.yashValue
                : element.qtyBreaks!.isNotEmpty
                    ? element.qtyBreaks![0].qty!.replaceAll(".0", "").toString()
                    : '',
            extraImages: element.extraImages,
            id: element.id,
            isFav: element.isFav,
            mainImageUrl: element.mainImageUrl,
            name: element.name,
            price: element.price,
            priceByQty: element.priceByQty,
            priceDelivery: element.priceDelivery!.toDouble(),
            priceTax: element.priceTax,
            priceTotal: element.qtyBreaks == null || element.qtyBreaks!.isEmpty
                ? element.priceTotal
                : element.qtyBreaks![0].price,
            priceUntaxed: element.priceUntaxed,
            qtyBreaks: element.qtyBreaks,
            saleUom: element.saleUom,
            sku: element.sku,
            deliveryEx: deliveryEX,
            deliveryInc: element.deliveryInc,
            deliveryTax: element.deliveryTax
            // selectedQtyValue:
            //     element.dropDownControllerValueForJobList != null &&
            //             element.selectedQtyValueForJobList != null
            //         ? element.selectedQtyValueForJobList.toString()
            //         : element.qtyBreaks![0].qty.toString()
            ));
      });
    }

    _cartLocalDB.putListData(cartProductList);

    cartProductList = await _cartLocalDB.getData();

    try {
      PersistentNavBarNavigator.pushNewScreen(context,
          screen: CartView(
            index: 0,
            // number: 3,
            // numberforCart: 0,
          ));
    } catch (e) {}

    getBedgeCount();
  }

  // on login buttion clik
  onProductSubCategoryItemClick(
      JobListProduct jobProduct, BuildContext context) async {
    productJobDetail = ProductData(
        id: jobProduct.id,
        description: jobProduct.description,
        yashValue: jobProduct.yashValue,
        extraImages: jobProduct.extraImages,
        isFav: jobProduct.isFav,
        mainImageUrl: jobProduct.mainImageUrl,
        name: jobProduct.name,
        price: jobProduct.price,
        priceByQty: jobProduct.priceByQty,
        priceDelivery: jobProduct.priceDelivery!.toDouble(),
        priceTax: jobProduct.priceTax,
        priceTotal:
            jobProduct.qtyBreaks == null || jobProduct.qtyBreaks!.isEmpty
                ? jobProduct.priceTotal
                : jobProduct.qtyBreaks![0].price,
        priceUntaxed: jobProduct.priceUntaxed,
        qtyBreaks: jobProduct.qtyBreaks,
        saleUom: jobProduct.saleUom,
        deliveryEx: jobProduct.deliveryEx,
        deliveryInc: jobProduct.deliveryInc,
        deliveryTax: jobProduct.deliveryTax,
        sku: jobProduct.sku);
    dynamic subCategoryId =
        await PersistentNavBarNavigator.pushNewScreen(context,
            screen: ProductDetialView(
              productObj: productJobDetail,
            ));

    if (subCategoryId != null) {
      getLocalDataList(subCategoryId.toString());
    }
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

  deleteProduct(
      JobListData? jobList,
      JobListProduct productsList,
      JobProductItemViewModel viewModel,
      BuildContext context,
      int index) async {
    getJobListItem = await AppUtil.getJobProductList();

    _localDbGorJob.clear();
    for (var i = 0; i < getJobListItem.length; i++) {
      if (getJobListItem[i].id == jobList!.id) {
        for (var j = 0; j < getJobListItem[i].productsList!.length; j++) {
          if (getJobListItem[i].productsList![j].id == productsList.id) {
            getJobListItem[i].productsList!.removeAt(j);
          }
        }
      }
    }
    await _localDbGorJob.putListData(getJobListItem);

    notifyListeners();
    return true;
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
