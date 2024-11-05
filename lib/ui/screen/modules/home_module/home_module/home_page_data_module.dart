import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/delivery_view_model.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_methods_response.dart';
import 'package:powagroup/ui/screen/modules/blog_module/blog_detail_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/content_slider.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/projects.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/review_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/videos.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_module/product_subcategory_view.dart';
import 'package:powagroup/ui/screen/modules/popular_product_module/popular_product.dart';
import 'package:powagroup/ui/screen/modules/project_module/project.dart';
import 'package:powagroup/ui/screen/modules/project_module/project_list/project_list.dart';
import 'package:powagroup/ui/screen/modules/search_module/search_view.dart';
import 'package:powagroup/ui/screen/modules/video_module/video_player/video_player.dart';
import 'package:powagroup/ui/screen/modules/video_module/videos_list/video_list.dart';
import 'package:powagroup/util/shared_preference.dart';
import 'package:provider/provider.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/connectivity.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/blog_detail.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/home_option.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_category_module/response_model/product_categories_response.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_subcategory_response.dart';
import 'package:powagroup/util/app_data.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
//import 'package:random_date/random_date.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../product_subcategory_item_module/response_model/product_hive_model.dart';

class HomePageDataViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  Map sourceMap = {ConnectivityResult.none: false};
  final MyConnectivity connectivity = MyConnectivity.instance;
  bool? isNetworkConnected;
  Api apiCall = locator<Api>();

  int _currentPageValue = 0;

  List<Category> _categoriesList = List.empty(growable: true);
  List<BlogPost> _blogsList = List.empty(growable: true);
  List<Project> _projectsList = List.empty(growable: true);
  List<SliderData> _sliderContentList = List.empty(growable: true);
  List<Video> _videosList = List.empty(growable: true);
  List<ProductData> _newProductList = List.empty(growable: true);

  List<UserReview> _customerReviewList = List.empty(growable: true);

  List<UserReview> _reviewList = List.empty(growable: true);
  bool _isBlogAPICalling = false;
  bool _isProjectAPICalling = false;
  //bool _isSliderContentAPICalling = false;
  bool _isVideoPICalling = false;
  bool _isNewProductAPICalling = false;
  bool _isAlreadyCalled = false;
  bool _isLocalDBAlreadyCalled = false;
  bool _isLocalforblocAlreadyCalled = false;
  bool _isLocalforProductAlreadyCalled = false;
  bool _isLocalforReviewAlreadyCalled = false;
  bool _isAPIError = false;
  bool isAllProductClicked = false;
  bool isResourcesClicked = true;
  final HiveDbServices<Category> _localDb =
      HiveDbServices(Constants.categories);

  List<Category> get categoriesList => _categoriesList;

  set categoriesList(List<Category> categoriesList) {
    _categoriesList = categoriesList;
    try {
      Future.delayed(const Duration(seconds: 4), () {
        notifyListeners();
      });
    } catch (error) {}
  }

  bool get isAPIError => _isAPIError;
  set isAPIError(bool isAPIError) {
    _isAPIError = isAPIError;
    notifyListeners();
  }

  int get currentPageValue => _currentPageValue;
  set currentPageValue(int currentPageValue) {
    _currentPageValue = currentPageValue;
    notifyListeners();
  }

  bool get isLocalDBAlreadyCalled => _isLocalDBAlreadyCalled;

  set isLocalDBAlreadyCalled(bool isLocalDBAlreadyCalled) {
    _isLocalDBAlreadyCalled = isLocalDBAlreadyCalled;
    notifyListeners();
  }

  bool get isLocalforblocAlreadyCalled => _isLocalforblocAlreadyCalled;

  set isLocalforblocAlreadyCalled(bool isLocalforblocAlreadyCalled) {
    _isLocalforblocAlreadyCalled = isLocalforblocAlreadyCalled;
    notifyListeners();
  }

  bool get isLocalforReviewAlreadyCalled => _isLocalforReviewAlreadyCalled;

  set isLocalforReviewAlreadyCalled(bool isLocalforReviewAlreadyCalled) {
    _isLocalforReviewAlreadyCalled = isLocalforReviewAlreadyCalled;
    notifyListeners();
  }

  bool get isLocalforProductAlreadyCalled => _isLocalforProductAlreadyCalled;

  set isLocalforProductAlreadyCalled(bool isLocalforProductAlreadyCalled) {
    _isLocalforProductAlreadyCalled = isLocalforProductAlreadyCalled;
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

  List<BlogPost> get blogsList => _blogsList;

  set blogsList(List<BlogPost> blogsList) {
    _blogsList = blogsList;
    notifyListeners();
  }

  List<DeliveryMethod> _deliveryMethodsList = List.empty(growable: true);

  List<DeliveryMethod> get deliveryMethodsList => _deliveryMethodsList;

  set deliveryMethodsList(List<DeliveryMethod> deliveryMethodsList) {
    _deliveryMethodsList = deliveryMethodsList;
    notifyListeners();
  }

  List<Project> get projectsList => _projectsList;

  set projectsList(List<Project> projectList) {
    _projectsList = projectList;
    notifyListeners();
  }

  List<SliderData> get sliderContentList => _sliderContentList;

  set sliderContentList(List<SliderData> sliderContentList) {
    _sliderContentList = sliderContentList;
    notifyListeners();
  }

  List<Video> get videosList => _videosList;

  set videosList(List<Video> videosList) {
    _videosList = videosList;
    notifyListeners();
  }

  List<UserReview> get reviewList => _reviewList;

  set reviewList(List<UserReview> reviewList) {
    _reviewList = reviewList;
    notifyListeners();
  }

  List<ProductData> get newProductList => _newProductList;

  set newProductList(List<ProductData> newProductList) {
    _newProductList = newProductList;
    notifyListeners();
  }

  List<Category>? subCategoryList;

  onSearchIconClick(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context, screen: SearchView());
  }

  List<UserReview> get customerReviewList => _customerReviewList;

  set customerReviewList(List<UserReview> customerReviewList) {
    _customerReviewList = customerReviewList;
    notifyListeners();
  }

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int currentIndex) {
    _currentIndex = currentIndex;
    notifyListeners();
  }

  String _loginToken = '';
  String get loginToken => _loginToken;

  set loginToken(String loginToken) {
    _loginToken = loginToken;
    notifyListeners();
  }

  bool get isBlogAPICalling => _isBlogAPICalling;

  set isBlogAPICalling(bool isBlogAPICalling) {
    _isBlogAPICalling = isBlogAPICalling;
    notifyListeners();
  }

  bool get isProjectAPICalling => _isProjectAPICalling;

  set isProjectAPICalling(bool isProjectAPICalling) {
    _isProjectAPICalling = isProjectAPICalling;
    notifyListeners();
  }

  // bool get isSliderContentAPICalling => _isSliderContentAPICalling;

  // set isSliderContentAPICalling(bool isSliderContentAPICalling) {
  //   _isSliderContentAPICalling = isSliderContentAPICalling;
  //   try {
  //     Future.delayed(const Duration(seconds: 4), () {
  //       notifyListeners();
  //     });
  //   } catch (error) {}
  // }

  Future<void> initializeViewModel(HomePageDataViewModel viewModel) async {
    viewModel.getLoginToken();
    viewModel.homeOptionList.add(HomeOption(
        'Get your Powagroup Account!', 'Get personalised Pricing etc.'));
    viewModel.homeOptionList
        .add(HomeOption('REQUEST YOUR CATALOGUE TODAY!', ''));
    viewModel.homeOptionList.add(HomeOption('GET A FREE POWAGROUP BEANIE', ''));

    bool isConnected = await AppUtil.checkNetwork();
    if (isConnected) {
      viewModel.getContentSlider(true);
      viewModel.getProductCategories(true);
      viewModel.getBlogsDetails(true);
      viewModel.getVideos(true);
    }
  }

  bool get isVideoAPICalling => _isVideoPICalling;

  set isVideoAPICalling(bool isVideoAPICalling) {
    _isVideoPICalling = isVideoAPICalling;
    notifyListeners();
  }

  bool _isCustomerApiCalling = false;
  bool get isCustomerApiCalling => _isCustomerApiCalling;

  set isCustomerApiCalling(bool isCustomerApiCalling) {
    _isCustomerApiCalling = isCustomerApiCalling;
    notifyListeners();
  }

  bool get isNewProductAPICalling => _isNewProductAPICalling;

  set isNewProductAPICalling(bool isNewProductAPICalling) {
    _isNewProductAPICalling = isNewProductAPICalling;
    notifyListeners();
  }

  final pageViewController =
      PageController(initialPage: 0, viewportFraction: 0.7);

  List<HomeOption> homeOptionList = List.empty(growable: true);

  // get Login Token
  void getLoginToken() async {
    loginToken = await AppUtil.getLoginToken();
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

        print("Length ------------- ${deliveryMethodsList.length}");

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
  }

  // on login buttion clik
  onProductCategoryItemClick(
      Category categoryObj, int index, BuildContext context) async {
    List<Category>? _categoriesList = await _localDb.getData();

    List<Category> subCategoryList = _categoriesList
        .where((element) => element.parentName == categoriesList[index].name)
        .toList();

    PersistentNavBarNavigator.pushNewScreen(context,
        screen: ProductSubCategoryView(
            categoryObj: categoryObj, subCategoryList: subCategoryList));
  }

  // Call API for product category
  getProductCategories(bool calledFromOnModelReady) async {
    if (!calledFromOnModelReady) {
      isAlreadyCalled = true;
    } else {
      isAlreadyCalled = false;
    }

    HiveDbServices<Category> _localDb = HiveDbServices(Constants.categories);
    List<Category>? _categoriesList = await _localDb.getData();

    if (_categoriesList.isEmpty) {
      setBusy(true);
      ProductCategoriesResponse? productCategoriesResponse =
          await apiCall.getProductCategories1();

      switch (productCategoriesResponse.statusCode) {
        case Constants.sucessCode:
          await _localDb.clear();
          productCategoriesResponse.categories!.forEach((Category element) {
            _localDb.addData(element);
          });

          _categoriesList.clear();

          _categoriesList = await _localDb.getData();

          categoriesList.clear();

          categoriesList = _categoriesList
              .where((element) => element.parentId == false)
              .toList();

          break;
        case Constants.wrongError:
          isAPIError = true;
          AppUtil.showDialogbox(AppUtil.getContext(),
              productCategoriesResponse.error ?? 'Oops Something went wrong');

          break;
        case Constants.networkErroCode:
          isAPIError = true;
          AppUtil.showDialogbox(AppUtil.getContext(),
              productCategoriesResponse.error ?? 'Oops Something went wrong');
          break;
        default:
          {
            if (productCategoriesResponse.error != null &&
                productCategoriesResponse.error!.isNotEmpty) {
              //isAPIError = true;
              AppUtil.showDialogbox(
                  AppUtil.getContext(),
                  productCategoriesResponse.error ??
                      'Oops Something went wrong');
            }
          }
          break;
      }
      setBusy(false);
    } else {
      categoriesList.clear();
      categoriesList = _categoriesList
          .where((element) => element.parentId == false)
          .toList();
    }
  }

//Localdatabase method for product category
  Future<List<Category>> getLocalDataForProductCategories() async {
    isLocalDBAlreadyCalled = true;
    _categoriesList = await _localDb.getData();

    if (_categoriesList.isNotEmpty) {
      categoriesList.clear();
      categoriesList = _categoriesList
          .where((element) => element.parentId == false)
          .toList();
    }
    return categoriesList;
  }

  // Call API for new Products
  getNewProducts() async {
    HiveDbServices<ProductData> _localDb =
        HiveDbServices(Constants.new_product);
    List<ProductData>? _newProductList = await _localDb.getData();

    if (_newProductList.isEmpty) {
      isNewProductAPICalling = true;
    } else {
      newProductList.clear();
      newProductList = _newProductList;
    }
    // var map = Map<String, dynamic>();

    var body = {
      "key": "",
    };

    ProductSubCategoriesItemsResponse? newProductResponse =
        await apiCall.getNewProduct(jsonEncode(body));

    switch (newProductResponse.statusCode) {
      case Constants.sucessCode:
        await _localDb.clear();

        if (newProductResponse != null &&
            newProductResponse.productResult!.products != null &&
            newProductResponse.productResult!.products!.isNotEmpty) {
          _newProductList.clear();
          newProductResponse.productResult!.products!.forEach((element) {
            _newProductList!.add(ProductData(
              saleUom: element.saleUom,
              description: element.description,
              id: element.id,
              extraImages: element.extraImages,
              mainImageUrl: element.mainImageUrl,
              name: element.name,
              // price: element.price ?? "",
              // priceByQty: element.priceByQty,
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
              // selectedQtyValue:
              //     element.qtyBreaks != null && element.qtyBreaks!.isNotEmpty
              //         ? element.qtyBreaks![0].qty.toString()
              //         : null
            ));
          });

          _localDb.putListData(_newProductList);
        }

        _newProductList = await _localDb.getData();

        newProductList = _newProductList;

        break;
      case Constants.wrongError:
        AppUtil.showDialogbox(AppUtil.getContext(),
            newProductResponse.error ?? 'Oops Something went wrong');
        break;
      case Constants.networkErroCode:
        AppUtil.showDialogbox(AppUtil.getContext(),
            newProductResponse.error ?? 'Oops Something went wrong');
        break;
      default:
        {
          if (newProductResponse.error != null &&
              newProductResponse.error!.isNotEmpty) {
            AppUtil.showDialogbox(AppUtil.getContext(),
                newProductResponse.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    isNewProductAPICalling = false;
  }

  //LocalDatabaseforfor new Products
  Future<List<ProductData>> getLocalDataForNewProduct() async {
    isLocalforProductAlreadyCalled = true;
    HiveDbServices<ProductData> _localDb =
        HiveDbServices(Constants.new_product);
    List<ProductData>? _newProductList = await _localDb.getData();
    if (_newProductList.isNotEmpty) {
      newProductList = _newProductList;
    }
    return newProductList;
  }

  // Call API for new Blogs
  // getProjects() async {
  //   //if (loginToken != null && loginToken.isNotEmpty) {
  //   HiveDbServices<Project> _localDb = HiveDbServices(Constants.projects);
  //   List<Project>? _projectList = await _localDb.getData();

  //   if (_projectList.isEmpty) {
  //     isProjectAPICalling = true;
  //   } else {
  //     projectsList = _projectList;
  //   }

  //   Projects? projectDetailsResponse = await apiCall.getProjectList();

  //   switch (projectDetailsResponse.statusCode) {
  //     case Constants.sucessCode:
  //       await _localDb.clear();

  //       if (projectDetailsResponse != null &&
  //           projectDetailsResponse.project != null &&
  //           projectDetailsResponse.project!.isNotEmpty) {
  //         _localDb.putListData(projectDetailsResponse.project);
  //       }

  //       _projectList = await _localDb.getData();

  //       projectsList = _projectList;

  //       break;
  //     case Constants.wrongError:
  //       AppUtil.showDialogbox(AppUtil.getContext(),
  //           projectDetailsResponse.error ?? 'Oops Something went wrong');

  //       break;
  //     case Constants.networkErroCode:
  //       AppUtil.showDialogbox(AppUtil.getContext(),
  //           projectDetailsResponse.error ?? 'Oops Something went wrong');
  //       break;
  //     default:
  //       {
  //         if (projectDetailsResponse.error != null &&
  //             projectDetailsResponse.error!.isNotEmpty) {
  //           AppUtil.showDialogbox(AppUtil.getContext(),
  //               projectDetailsResponse.error ?? 'Oops Something went wrong');
  //         }
  //       }
  //       break;
  //   }
  //   isProjectAPICalling = false;
  //   //}
  // }

  // Call API for product category

  getContentSlider(bool calledFromOnModelReady) async {
    if (!calledFromOnModelReady) {
      isAlreadyCalled = true;
    } else {
      isAlreadyCalled = false;
    }

    HiveDbServices<SliderData> _localDb =
        HiveDbServices(Constants.contentSlider);

    List<SliderData>? _sliderDataList = await _localDb.getData();

    if (_sliderDataList.isEmpty) {
      setBusy(true);
      //isSliderContentAPICalling = true;
      ContentSliderApiResponse? contentSliderApiResponse =
          await apiCall.getContentSliderList();

      switch (contentSliderApiResponse.statusCode) {
        case Constants.sucessCode:
          await _localDb.clear();

          if (contentSliderApiResponse != null &&
              contentSliderApiResponse.sliders != null &&
              contentSliderApiResponse.sliders!.isNotEmpty) {
            try {
              _localDb.putListData(contentSliderApiResponse.sliders);
            } catch (e) {}
          }

          _sliderDataList = await _localDb.getData();

          sliderContentList = _sliderDataList;

          break;
        case Constants.wrongError:
          AppUtil.showDialogbox(AppUtil.getContext(),
              contentSliderApiResponse.error ?? 'Oops Something went wrong');

          break;
        case Constants.networkErroCode:
          AppUtil.showDialogbox(AppUtil.getContext(),
              contentSliderApiResponse.error ?? 'Oops Something went wrong');
          break;
        default:
          {
            if (contentSliderApiResponse.error != null &&
                contentSliderApiResponse.error!.isNotEmpty) {
              AppUtil.showDialogbox(
                  AppUtil.getContext(),
                  contentSliderApiResponse.error ??
                      'Oops Something went wrong');
            }
          }
          break;
      }
      // isSliderContentAPICalling = false;
      setBusy(false);
    } else {
      sliderContentList = _sliderDataList;
    }
  }

  getVideos(bool calledFromOnModelReady) async {
    if (!calledFromOnModelReady) {
      isAlreadyCalled = true;
    } else {
      isAlreadyCalled = false;
    }
    //if (loginToken != null && loginToken.isNotEmpty) {
    HiveDbServices<Video> _localDb = HiveDbServices(Constants.videos);
    List<Video>? _videosList = await _localDb.getData();

    if (_videosList.isEmpty) {
      isVideoAPICalling = true;
      VideosApiResponse? videoAPIResponse = await apiCall.getVideosList();

      switch (videoAPIResponse.statusCode) {
        case Constants.sucessCode:
          await _localDb.clear();

          if (videoAPIResponse != null &&
              videoAPIResponse.videos != null &&
              videoAPIResponse.videos!.isNotEmpty) {
            // videoAPIResponse.videos!.forEach((element) {
            //   var randomDate = RandomDate.withRange(2022, 2023);
            //   element.createdDate = randomDate.random();
            // });

            _localDb.putListData(videoAPIResponse.videos);
          }

          _videosList = await _localDb.getData();

          // _videosList.sort((a, b) {
          //   var adate = a.createdDate;
          //   var bdate = b.createdDate;
          //   return adate!.compareTo(bdate!);
          // });

          videosList = _videosList;

          break;
        case Constants.wrongError:
          AppUtil.showDialogbox(AppUtil.getContext(),
              videoAPIResponse.error ?? 'Oops Something went wrong');

          break;
        case Constants.networkErroCode:
          AppUtil.showDialogbox(AppUtil.getContext(),
              videoAPIResponse.error ?? 'Oops Something went wrong');
          break;
        default:
          {
            if (videoAPIResponse.error != null &&
                videoAPIResponse.error!.isNotEmpty) {
              AppUtil.showDialogbox(AppUtil.getContext(),
                  videoAPIResponse.error ?? 'Oops Something went wrong');
            }
          }
          break;
      }
      isVideoAPICalling = false;
    } else {
      videosList = _videosList;
    }

    //}
  }

  // // Call API for new Blogs
  getBlogsDetails(bool calledFromOnModelReady) async {
    if (!calledFromOnModelReady) {
      isAlreadyCalled = true;
    } else {
      isAlreadyCalled = false;
    }
    if (loginToken != null && loginToken.isNotEmpty) {
      HiveDbServices<BlogPost> _localDb = HiveDbServices(Constants.blogs);
      List<BlogPost>? _blogsList = await _localDb.getData();

      if (_blogsList.isEmpty) {
        isBlogAPICalling = true;
        BlogDetailModel? blogDetailModel = await apiCall.getBlogSummary();

        switch (blogDetailModel.statusCode) {
          case Constants.sucessCode:
            await _localDb.clear();

            if (blogDetailModel != null &&
                blogDetailModel.blogPosts != null &&
                blogDetailModel.blogPosts!.isNotEmpty) {
              _localDb.putListData(blogDetailModel.blogPosts);
            }

            _blogsList = await _localDb.getData();

            blogsList = _blogsList;

            break;
          case Constants.wrongError:
            AppUtil.showDialogbox(AppUtil.getContext(),
                blogDetailModel.error ?? 'Oops Something went wrong');

            break;
          case Constants.networkErroCode:
            AppUtil.showDialogbox(AppUtil.getContext(),
                blogDetailModel.error ?? 'Oops Something went wrong');
            break;
          default:
            {
              if (blogDetailModel.error != null &&
                  blogDetailModel.error!.isNotEmpty) {
                AppUtil.showDialogbox(AppUtil.getContext(),
                    blogDetailModel.error ?? 'Oops Something went wrong');
              }
            }
            break;
        }
        isBlogAPICalling = false;
      }
    } else {
      blogsList = _blogsList;
    }
  }

  //Localdatabase method for blogDetail
  Future<List<BlogPost>> getLoacalDataForBlogsDetail() async {
    isLocalforblocAlreadyCalled = true;
    HiveDbServices<BlogPost> _localDb = HiveDbServices(Constants.blogs);
    _blogsList = await _localDb.getData();
    if (_blogsList.isNotEmpty) {
      blogsList = _blogsList;
    }
    return blogsList;
  }

  onBlogItemClick(BlogPost blogPost, BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: BlogDetailView(
          blogPost: blogPost,
        ));
  }

  onProjectItemClick(Project project, BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: ProjectDetailView(
          project: project,
        ));
  }

  onVideoItemClick(Video video, BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context,
        withNavBar: false,
        screen: VideoPlayerView(
          video: video,
        ));
  }

  onClickSeeAllViedeos(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: VideosListView(
          videoList: videosList,
        ));
  }

  onClickSeeAllProject(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: ProjectsListView(
          projectList: projectsList,
        ));
  }

  onClickSeeAllPopularProducts(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: PopularProductListView(
          popularProductList: newProductList,
        ));
  }

  Future<List<UserReview>> getLoacalDataForCustomerReviewDetail() async {
    isLocalforReviewAlreadyCalled = true;
    HiveDbServices<UserReview> _localDb =
        HiveDbServices(Constants.customer_review);
    _reviewList = await _localDb.getData();
    if (_reviewList.isNotEmpty) {
      reviewList = _reviewList;
    }
    return reviewList;
  }

  getCustomerReviews() async {
    HiveDbServices<UserReview> _localDb =
        HiveDbServices(Constants.customer_review);

    List<UserReview>? _reviewList = await _localDb.getData();

    if (_reviewList.isEmpty) {
      isCustomerApiCalling = true;
    } else {
      reviewList = _reviewList;
    }

    ProductReview reviewDetails = await apiCall.getCustomerReviewDetail();

    switch (reviewDetails.statusCode) {
      case Constants.sucessCode:
        await _localDb.clear();

        if (reviewDetails != null &&
            reviewDetails.reviews != null &&
            reviewDetails.reviews!.isNotEmpty) {
          _localDb.putListData(reviewDetails.reviews);
        }

        _reviewList = await _localDb.getData();

        reviewList = _reviewList;

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
  }

  onCreateAccountClick() {
    navigationService.navigateTo(Routes.registerView);
  }
}
