import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/helper_widget/debouncer.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/connectivity.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/3d_viewer_module/3d_viewer.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_methods_response.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/customer_reviews_by_product.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/favorite_detail_model.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_by_id.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_model.dart';
import 'package:powagroup/ui/screen/modules/reviews/review_view.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../home_module/home_module/model/review_model.dart';
import '../user_module/profile/response_model.dart/user_profile_model.dart';
import 'response_model/rating_details_model.dart';
import 'package:http/http.dart' as http;

class ProductDetailViewModel extends BaseViewModel {
  Api apiCall = locator<Api>();
  ProductSubDetailModel? productSubDetailModelResponse;
  FavoriteResponseModel? favoriteResponseModel;
  RatingDetail? ratingDetails;
  final navigationService = locator<NavigationService>();
  Map sourceMap = {ConnectivityResult.none: false};
  final MyConnectivity connectivity = MyConnectivity.instance;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController qtyValueController = TextEditingController();

  CarouselController carouselController = CarouselController();
  bool? isNetworkConnected;
  bool isFavItemCheck = true;
  bool isExpandView = false;
  bool _isCalling = false;
  bool _isAlreadyCalled = false;
  bool _isLocalDBAlreadyCalled = false;
  bool _isLocalDBAlreadyCalledForCustomerReview = false;
  bool _isAPIError = false;
  int _itemCount = 0;
  int itemPerPage = 0;
  int _pageCount = 0;
  int _subCategoryId = 0;

  bool set = false;
  final debouncer = Debouncer(milliseconds: 1000);
  final FocusNode titleNode = FocusNode();
  final FocusNode messageNode = FocusNode();

  TextEditingController msgController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  final HiveDbServices<ProductDetailById> _localDb =
      HiveDbServices(Constants.product_details);

  List<ProductDetailById> _productDetailsList = new List.empty(growable: true);

  List<ProductDetailById> get productDetailsList => _productDetailsList;

  set productDetailsList(List<ProductDetailById> productDetailsList) {
    _productDetailsList = productDetailsList;
    // notifyListeners();
  }

  List<CustomerReviewByProduct> _customerReviewDetailsList =
      new List.empty(growable: true);

  List<CustomerReviewByProduct> get customerReviewDetailsList =>
      _customerReviewDetailsList;

  set customerReviewDetailsList(
      List<CustomerReviewByProduct> productDetailsList) {
    _customerReviewDetailsList = customerReviewDetailsList;
    notifyListeners();
  }

  List<UserReview>? _userReviews = List.empty(growable: true);

  List<UserReview> get userReviews => _userReviews!;

  set userReviews(List<UserReview> userReviews) {
    _userReviews = userReviews;
    notifyListeners();
  }

  ProductDetailsData? _productDetails = ProductDetailsData();

  ProductDetailsData get productDetails => _productDetails!;

  set productDetails(ProductDetailsData productDetails) {
    _productDetails = productDetails;
    notifyListeners();
  }

  List<UserReview> _userReviewList = new List.empty(growable: true);

  List<UserReview> get userReviewList => _userReviewList;

  set userReviewList(List<UserReview> productDetailsList) {
    _userReviewList = userReviewList;
    notifyListeners();
  }

  getBedgeCount() async {
    itemCount = await AppUtil.getCartProductLength();
    notifyListeners();
  }

  onCheckoutButtonClick(viewModel) async {
    String loginToken = await AppUtil.getLoginToken();
    int userId = await AppUtil.getUserId();

    ProductDetailsData data = await getLocalDataList(subCategoryId);

    ProductSubDetailModel data1 = await viewModel.getItemPrice(
      subCategoryId,
    );

    if (data.priceTotal != null) {
      if (loginToken != null && loginToken.isNotEmpty) {
        AppUtil.onAddToTruckClick(
            ProductData(
                userId: userId,
                description: data.description,
                yashValue: data.yashValue,
                extraImages: data.extraImages,
                id: data.id,
                isFav: data.isFav,
                mainImageUrl: data.mainImageUrl,
                name: data.name,
                price: data1.productResult != null
                    ? data1.productResult!.product!.price.toString() ?? ""
                    : data1.product!.price.toString() ?? "",
                priceByQty: data1.productResult! != null
                    ? data1.productResult!.product!.priceByQty.toString() ?? ""
                    : data1.product!.priceByQty.toString() ?? "",
                priceDelivery: data1.productResult != null
                    ? double.parse(
                        data1.productResult!.delivery_tax!.toString())
                    : double.parse(data1.delivery_tax!.toString()),
                priceTax: data1.productResult != null
                    ? double.parse(
                        data1.productResult!.product!.priceTax.toString())
                    : double.parse(data1.product!.priceTax!.toString()),
                priceTotal: data.qtyBreaks == null || data.qtyBreaks!.isEmpty
                    ? data.priceTotal
                    : data.qtyBreaks![0].price,
                priceUntaxed: data1.productResult != null
                    ? data1.productResult!.product!.priceUntaxed
                    : data1.product!.priceUntaxed,
                qtyBreaks: data1.productResult != null
                    ? data1.productResult!.product!.qtyBreaks
                    : data1.product!.qtyBreaks,
                saleUom: data.saleUom,
                sku: data.sku,
                deliveryEx: data1.productResult != null
                    ? data1.productResult!.delivery_ex!
                    : data1.delivery_ex!,
                deliveryInc: data.deliveryInc,
                deliveryTax: data1.productResult != null
                    ? double.parse(
                        data1.productResult!.delivery_tax!.toString())
                    : double.parse(data1.delivery_tax!.toString()),
                controllerForCart: TextEditingController(text: data.yashValue)),
            false,
            viewModel);
      } else {
        AppUtil.showLoginMessageDialog(AppUtil.getContext(),
            'Please Sign In/Register to purchase products');
      }
    } else {}
  }

  final featuredImages = [
    'assets/icon/image 14.jpg',
    'assets/icon/image 15.jpg',
  ];
  String _msg = '';
  String _title = '';

  String get msg => _msg;
  set msg(String msg) {
    _msg = msg;
    notifyListeners();
  }

  String get title => _title;
  set title(String title) {
    _title = title;
    notifyListeners();
  }

  bool _isSet = false;
  bool get isSet => _isSet;
  set isSet(bool isSet) {
    _isSet = isSet;
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

  int get subCategoryId => _subCategoryId;
  set subCategoryId(int subCategoryId) {
    _subCategoryId = subCategoryId;
    notifyListeners();
  }

  int get pageCount => _pageCount;
  set pageCount(int pageCount) {
    _pageCount = pageCount;
    notifyListeners();
  }

  var initalrating;
  double rates1 = 0.0;
  double get rate1 => rates1;
  set rate1(double rate1) {
    rates1 = rate1;
    notifyListeners();
  }

  int rates = 0;
  int get rate => rates;
  set rate(int rate) {
    rates = rate;
    notifyListeners();
  }

  bool get isCalling => _isCalling;
  set isCalling(bool isCalling) {
    _isCalling = isCalling;
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

  bool _isPriceLoading = true;

  bool get isPriceLoading => _isPriceLoading;

  set isPriceLoading(bool isPriceLoading) {
    _isPriceLoading = isPriceLoading;

    // try {
    //   Future.delayed(const Duration(seconds: 4), () {
    notifyListeners();
    //   });
    // } catch (error) {}
  }

  bool get isAPIError => _isAPIError;
  set isAPIError(bool isAPIError) {
    _isAPIError = isAPIError;
    notifyListeners();
  }

  bool _isStarClick = false;
  bool get isStarClick => _isStarClick;
  set isStarClick(bool isStarClick) {
    _isStarClick = isStarClick;
    notifyListeners();
  }

  int currIndex = 0;
  bool _isDataFill = false;

  bool get isDataFill => _isDataFill;
  set isDataFill(bool isDataFill) {
    _isDataFill = isDataFill;
    notifyListeners();
  }

  bool _isAlertnativeListEmpty = false;
  bool get isAlertnativeListEmpty => _isAlertnativeListEmpty;
  set isAlertnativeListEmpty(bool isAlertnativeListEmpty) {
    _isAlertnativeListEmpty = isAlertnativeListEmpty;
    notifyListeners();
  }

  List<DeliveryMethod> _deliveryMethodsList = List.empty(growable: true);

  List<DeliveryMethod> get deliveryMethodsList => _deliveryMethodsList;

  set deliveryMethodsList(List<DeliveryMethod> deliveryMethodsList) {
    _deliveryMethodsList = deliveryMethodsList;
    notifyListeners();
  }

  bool _isAccessioresListEmpty = false;
  bool get isAccessioresListEmpty => _isAccessioresListEmpty;
  set isAccessioresListEmpty(bool isAccessioresListEmpty) {
    _isAccessioresListEmpty = isAccessioresListEmpty;
    notifyListeners();
  }

  bool get isLocalDBAlreadyCalled => _isLocalDBAlreadyCalled;

  set isLocalDBAlreadyCalled(bool isLocalDBAlreadyCalled) {
    _isLocalDBAlreadyCalled = isLocalDBAlreadyCalled;
    notifyListeners();
  }

  bool get isLocalDBAlreadyCalledForCustomerReview =>
      _isLocalDBAlreadyCalledForCustomerReview;

  set isLocalDBAlreadyCalledForCustomerReview(
      bool isLocalDBAlreadyCalledForCustomerReview) {
    _isLocalDBAlreadyCalledForCustomerReview =
        isLocalDBAlreadyCalledForCustomerReview;
    notifyListeners();
  }

  int _rating = 0;
  int get rating => _rating;
  set rating(int rating) {
    _rating = rating;
    notifyListeners();
  }

  onExpandClick() {
    isExpandView = !isExpandView;
    currIndex = currIndex == 0 ? 1 : 0;
    notifyListeners();
  }

  animateView(AnimationController? _controller, Animation<double>? _animation) {
    if (_animation!.status != AnimationStatus.completed) {
      _controller!.forward();
    } else {
      _controller!.reverse();
    }
  }

  bool? isAddedtoFavList;
  set isAddedtoFav(bool isAddedtoFav) {
    isAddedtoFavList = isAddedtoFav;
    notifyListeners();
  }

  List<UserReview> _customerReviewList = List.empty(growable: true);
  List<UserReview> get customerReviewList => _customerReviewList;

  set customerReviewList(List<UserReview> customerReviewList) {
    _customerReviewList = customerReviewList;
    notifyListeners();
  }

  // get product data
  ProductData getProduct() {
    ProductData productData = ProductData(
        deliveryEx: productDetails.deliveryEx,
        deliveryInc: productDetails.deliveryInc,
        deliveryTax: productDetails.deliveryTax,
        description: productDetails.description,
        extraImages: productDetails.extraImages,
        id: productDetails.id,
        isFav: productDetails.isFav,
        mainImageUrl: productDetails.mainImageUrl,
        name: productDetails.name,
        price: productDetails.price.toString(),
        priceByQty: productDetails.priceByQty.toString(),
        priceDelivery: productDetails.priceDelivery != null
            ? productDetails.priceDelivery!.toDouble()
            : 0.0,
        priceTax: productDetails.priceTax,
        priceTotal: productDetails.qtyBreaks == null ||
                productDetails.qtyBreaks!.isEmpty
            ? productDetails.priceTotal
            : productDetails.qtyBreaks![0].price,
        priceUntaxed: productDetails.priceUntaxed,
        qtyBreaks: productDetails.qtyBreaks,
        saleUom: productDetails.saleUom,
        sku: productDetails.sku,
        yashValue: productDetails.yashValue,
        controllerForCart:
            TextEditingController(text: productDetails.yashValue));

    return productData;
  }

  getProductDeatilsItems(bool calledFromOnModelReady) async {
    productDetailsList = await _localDb.getData();
    if (!calledFromOnModelReady) {
      isAlreadyCalled = true;
    } else {
      isAlreadyCalled = false;
    }

    if (productDetailsList.isEmpty) {
      setBusy(true);
    } else {
      productDetailsList.forEach((element) {
        if (element.subCategoryId == subCategoryId) {
          productDetails = element.productDetails!;

          qtyValueController.text = productDetails.yashValue!;
        }
      });
    }

    Map<String, dynamic> requestBody = {
      "product_list": [
        {
          "id": subCategoryId,
          //"quantity": 1
        }
      ]
    };

    productSubDetailModelResponse = await apiCall.getProductDetailPageItem(
        requestBody, subCategoryId.toString());

    switch (productSubDetailModelResponse!.statusCode) {
      case Constants.sucessCode:
        await _localDb.clear();

        productDetailsList
            .removeWhere((element) => element.subCategoryId == subCategoryId);

        ProductDetailsData mapData = ProductDetailsData(
          id: productSubDetailModelResponse!.productResult!.product!.id,
          accessoryProducts: productSubDetailModelResponse!
              .productResult!.product!.accessoryProducts,
          alternativeProducts: productSubDetailModelResponse!
              .productResult!.product!.alternativeProducts,
          description: productSubDetailModelResponse!
              .productResult!.product!.description,
          extraImages: productSubDetailModelResponse!
              .productResult!.product!.extraImages,
          isFav: productSubDetailModelResponse!.productResult!.product!.isFav,
          totalReviewCount: productSubDetailModelResponse!
              .productResult!.product!.totalReviewCount,
          reviewAvg:
              productSubDetailModelResponse!.productResult!.product!.reviewAvg,
          mainImageUrl: productSubDetailModelResponse!
              .productResult!.product!.mainImageUrl,
          name: productSubDetailModelResponse!.productResult!.product!.name,
          price: productSubDetailModelResponse!.productResult!.product!.price,
          priceByQty:
              productSubDetailModelResponse!.productResult!.product!.priceByQty,
          priceDelivery: productSubDetailModelResponse!
              .productResult!.product!.priceDelivery,
          priceTax:
              productSubDetailModelResponse!.productResult!.product!.priceTax,
          priceTotal: productSubDetailModelResponse!
                          .productResult!.product!.qtyBreaks ==
                      null ||
                  productSubDetailModelResponse!
                      .productResult!.product!.qtyBreaks!.isEmpty
              ? productSubDetailModelResponse!
                  .productResult!.product!.priceTotal
              : productSubDetailModelResponse!
                  .productResult!.product!.qtyBreaks![0].price,
          priceUntaxed: productSubDetailModelResponse!
              .productResult!.product!.priceUntaxed,
          qtyBreaks:
              productSubDetailModelResponse!.productResult!.product!.qtyBreaks,
          saleUom:
              productSubDetailModelResponse!.productResult!.product!.saleUom,
          sku: productSubDetailModelResponse!.productResult!.product!.sku,
          deliveryEx: productSubDetailModelResponse!.productResult!.delivery_ex,
          deliveryInc:
              productSubDetailModelResponse!.productResult!.delivery_inc,
          deliveryTax:
              productSubDetailModelResponse!.productResult!.delivery_tax,
          yashValue: productDetails.yashValue != null &&
                  productDetails.yashValue!.isNotEmpty
              ? productDetails.yashValue
              : productSubDetailModelResponse!
                              .productResult!.product!.qtyBreaks !=
                          null &&
                      productSubDetailModelResponse!
                          .productResult!.product!.qtyBreaks!.isNotEmpty
                  ? productSubDetailModelResponse!
                      .productResult!.product!.qtyBreaks![0].qty!
                      .replaceAll(".0", "")
                      .toString()
                  : '1',
        );

        ProductDetailById productDetailById = ProductDetailById(
            subCategoryId: subCategoryId, productDetails: mapData);

        productDetailsList.add(productDetailById);

        _localDb.putListData(productDetailsList);

        productDetailsList = await _localDb.getData();

        if (productDetailsList != null && productDetailsList.isNotEmpty) {
          productDetailsList.forEach((element) {
            if (element.subCategoryId == subCategoryId) {
              productDetails = element.productDetails!;
              qtyValueController.text = productDetails.yashValue!;
            }
          });
        }

        getProductDeatilsItemsOnlyPrice(false);

        break;
      case Constants.wrongError:
        isAPIError = true;
        AppUtil.showDialogbox(
            AppUtil.getContext(),
            productSubDetailModelResponse!.error ??
                'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        isAPIError = true;
        AppUtil.showDialogbox(
            AppUtil.getContext(),
            productSubDetailModelResponse!.error ??
                'Oops Something went wrong');
        break;
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
        break;
    }
    setBusy(false);
  }

  getProductDeatilsItemsOnlyPrice(bool calledFromOnModelReady) async {
    isPriceLoading = true;

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
      //"delivery_method_id": deliveryMethodId,
    };

    productSubDetailModelResponse = await apiCall.getProductDetailPageItem(
        requestBody, subCategoryId.toString());

    switch (productSubDetailModelResponse!.statusCode) {
      case Constants.sucessCode:
        productDetailsList = await _localDb.getData();
        if (productDetailsList != null && productDetailsList.isNotEmpty) {
          productDetailsList.forEach((element) {
            if (element.subCategoryId == subCategoryId) {
              element.productDetails!.priceUntaxed =
                  productSubDetailModelResponse!
                      .productResult!.product!.priceUntaxed;

              element.productDetails!.priceTax = productSubDetailModelResponse!
                  .productResult!.product!.priceTax;

              element.productDetails!.priceDelivery =
                  productSubDetailModelResponse!
                      .productResult!.product!.priceDelivery;

              element.productDetails!.qtyBreaks = productSubDetailModelResponse!
                  .productResult!.product!.qtyBreaks;

              if (element.productDetails!.qtyBreaks != null &&
                  element.productDetails!.qtyBreaks!.isNotEmpty) {
                element.productDetails!.qtyBreaks!.forEach((qtyBreakData) {
                  if (qtyBreakData.qty.replaceAll(".0", "").toString() ==
                      productDetails.yashValue) {
                    element.productDetails!.priceTotal =
                        // productSubDetailModelResponse!
                        //     .productResult!.product!.priceTotal;
                        qtyBreakData.price;
                  } else {
                    element.productDetails!.priceTotal =
                        productSubDetailModelResponse!
                            .productResult!.product!.qtyBreaks![0].price;
                  }
                });
              } else {
                element.productDetails!.priceTotal =
                    productSubDetailModelResponse!
                        .productResult!.product!.priceUntaxed;
              }

              qtyValueController.text = productDetails.yashValue!;

              notifyListeners();
            }
          });
        }

        break;
      case Constants.wrongError:
        isAPIError = true;
        AppUtil.showDialogbox(
            AppUtil.getContext(),
            productSubDetailModelResponse!.error ??
                'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        isAPIError = true;
        AppUtil.showDialogbox(
            AppUtil.getContext(),
            productSubDetailModelResponse!.error ??
                'Oops Something went wrong');
        break;
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
        break;
    }
    isPriceLoading = false;
  }

  addFavorite(var subCategoryId) async {
    isCalling = true;
    isAddedtoFavList = true;
    notifyListeners();
    var map = Map<String, dynamic>();
    currIndex == 0 ? map['fav'] = "True" : map['fav'] = "False";

    favoriteResponseModel =
        await apiCall.checkFavoritePorduct(map, subCategoryId);
    isCalling = false;

    switch (favoriteResponseModel!.statusCode) {
      case Constants.sucessCode:
        onExpandClick();
        notifyListeners();
        if (isExpandView == true) {
          notifyListeners();
          AppUtil.showSnackBar("Added to Favourite");
        } else if (isExpandView == false) {
          notifyListeners();
          AppUtil.showSnackBar("Remove From Favourite");
        }

        break;
      case Constants.wrongError:
        // AppUtil.showToast(loginResp.error ?? '');

        AppUtil.showDialogbox(AppUtil.getContext(),
            favoriteResponseModel!.error ?? "Something Went Wrong");
        isExpandView = false;
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
              favoriteResponseModel!.error!.isNotEmpty) {
            //AppUtil.showToast(loginResp.error ?? '');
          }
        }
        break;
    }
    isAddedtoFavList = false;
    notifyListeners();
    // _FavCheck = true;
  }

  // Update or add controller value by index

  updateControllerValue(value, price) async {
    if (productDetails.yashValue == null || productDetails.yashValue!.isEmpty) {
      productDetails.yashValue = '';

      productDetails.yashValue = value;
      productDetails.priceUntaxed = price;
    } else {
      productDetails.yashValue = value;
      // productDetails.priceUntaxed = price;
      productDetails.priceTotal = price;
    }

    productDetails.priceByQty = price;

    productDetailsList.forEach((element) {
      if (element.subCategoryId == subCategoryId) {
        productDetailsList
            .removeWhere((element) => element.subCategoryId == subCategoryId);

        ProductDetailById productDetailById = ProductDetailById(
          subCategoryId: subCategoryId,
          productDetails: productDetails,
        );

        productDetailsList.add(productDetailById);
      }
    });

    _localDb.clear();

    _localDb.putListData(productDetailsList);

    await getLocalDataList(subCategoryId);

    notifyListeners();
  }

  // get Item Total Price to show total price of items
  int getItemTotalPrice() {
    int itemTotalPrice = 0;
    if (productDetails != null) {
      //  for (int i = 0; i < cartProductList.length; i++) {
      if (productDetails.qtyBreaks != null &&
          productDetails.qtyBreaks!.isNotEmpty) {
        itemTotalPrice = (itemTotalPrice + productDetails.priceByQty!).toInt();
      } else {
        itemTotalPrice = itemTotalPrice + productDetails.price!;
      }
      // }
    }

    return itemTotalPrice;
  }

  Future<ProductDetailsData> getLocalDataList(
    var subCategoryId,
  ) async {
    isLocalDBAlreadyCalled = true;
    productDetailsList = await _localDb.getData();
    if (productDetailsList.isNotEmpty) {
      productDetailsList.forEach((element) {
        if (element.subCategoryId == subCategoryId) {
          productDetails = element.productDetails!;
        }
      });
    }
    return productDetails;
  }

  // on See All Text Click
  onSeeAllClick(ProductDetailsData data, BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: CustomerReviewView(
          productObj: data,
        ));
  }

  onSendButtonClick(int? id, int rate) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      onButtonClick(id, rate);
      notifyListeners();
    } else {}
  }

  // // on Click View in 3d Button
  // onClick3D(BuildContext context) {
  //   PersistentNavBarNavigator.pushNewScreen(context, screen: ViewerScreen3D(
  //     src : 'assets/Astronaut.glb',
  //   ));
  // }

  onButtonClick(var productId, int rating) async {
    setBusy(true);
    var map = Map<String, dynamic>();

    ratingDetails = await apiCall.commentSection(map, productId,
        titleController.text.toString(), msgController.text.toString(), rating);
    switch (ratingDetails!.statusCode) {
      case Constants.sucessCode:
        AppUtil.showSnackBar("success");
        getTopComments(productId, itemPerPage, false);
        notifyListeners();
        titleController.clear();
        msgController.clear();
        rate = -1;
        isSet = true;
        notifyListeners();

        break;
      case Constants.wrongError:
        isDataFill = true;

        AppUtil.showDialogbox(AppUtil.getContext(),
            ratingDetails!.error ?? "Something Went Wrong");
        isExpandView = false;
        notifyListeners();

        break;
      case Constants.networkErroCode:
        isDataFill = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            ratingDetails!.error ?? "Something Went Wrong");

        break;
      default:
        {
          if (ratingDetails!.error != null &&
              ratingDetails!.error!.isNotEmpty) {
            //AppUtil.showToast(loginResp.error ?? '');
          }
        }
        break;
    }
    setBusy(false);
  }

  bool _isCustomerApiCalling = false;
  bool get isCustomerApiCalling => _isCustomerApiCalling;

  set isCustomerApiCalling(bool isCustomerApiCalling) {
    _isCustomerApiCalling = isCustomerApiCalling;
    notifyListeners();
  }

  getTopComments(
      var productId, int itemPerPage, bool calledFromOnModelReady) async {
    if (!calledFromOnModelReady) {
      isAlreadyCalled = true;
    } else {
      isAlreadyCalled = false;
    }

    HiveDbServices<CustomerReviewByProduct> _localDbForCustomerReview =
        HiveDbServices(Constants.Leave_comment);

    // List<UserReview>? _customerReviewList =
    //     await _localDbForCustomerReview.getData();

    _customerReviewDetailsList = await _localDbForCustomerReview.getData();

    if (_customerReviewDetailsList.isEmpty) {
      isCustomerApiCalling = true;
      // setBusy(true);
    } else {
      customerReviewDetailsList = _customerReviewDetailsList.take(3).toList();

      customerReviewDetailsList.forEach((element) {
        if (element.productId == productId) {
          userReviews = element.customerReviewDetails!;
        }
      });
    }

    ProductReview reviewDetails = await apiCall.getLeaveComments(
      productId,
      itemPerPage,
    );

    switch (reviewDetails.statusCode) {
      case Constants.sucessCode:
        _localDbForCustomerReview.clear();

        _customerReviewDetailsList
            .removeWhere((element) => element.productId == productId);

        CustomerReviewByProduct customerReviewByProduct =
            CustomerReviewByProduct(
                productId: productId,
                customerReviewDetails: reviewDetails.reviews!.take(3).toList());

        _customerReviewDetailsList.add(customerReviewByProduct);

        _localDbForCustomerReview.putListData(_customerReviewDetailsList);

        _customerReviewDetailsList = await _localDbForCustomerReview.getData();

        if (_customerReviewDetailsList != null &&
            _customerReviewDetailsList.isNotEmpty) {
          _customerReviewDetailsList.forEach((element) {
            if (element.productId == productId) {
              userReviews = element.customerReviewDetails!;
            }
          });
        }

        // _customerReviewList = await _localDbForCustomerReview.getData();

        // customerReviewList = _customerReviewList.take(3).toList();
        break;
      case Constants.wrongError:
        AppUtil.showDialogbox(AppUtil.getContext(),
            reviewDetails.error ?? 'Oops Something went wrong');
        break;
      case Constants.networkErroCode:
        AppUtil.showDialogbox(AppUtil.getContext(),
            reviewDetails.error ?? 'Oops Something went wrong');
        break;
      default:
        {
          if (reviewDetails.error != null && reviewDetails.error!.isNotEmpty) {
            AppUtil.showDialogbox(AppUtil.getContext(),
                reviewDetails.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    isCustomerApiCalling = false;
    // setBusy(false);
  }

  getLocalDataListComments(var productId) async {
    HiveDbServices<CustomerReviewByProduct> _localDbForCustomerReview =
        HiveDbServices(Constants.Leave_comment);

    isLocalDBAlreadyCalledForCustomerReview = true;

    _customerReviewDetailsList = await _localDbForCustomerReview.getData();

    if (_customerReviewDetailsList.isNotEmpty) {
      _customerReviewDetailsList.forEach((element) {
        if (element.productId == productId) {
          userReviews = element.customerReviewDetails!;
        }
      });

      customerReviewDetailsList = _customerReviewDetailsList.take(3).toList();
    }
    return customerReviewDetailsList;
  }

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

class productList {
  int? id;
  int? quantity;
}
