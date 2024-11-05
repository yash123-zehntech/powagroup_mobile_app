import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_offline/flutter_offline.dart';

import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/connectivity.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_by_id.dart';
import 'package:powagroup/ui/screen/modules/reviews/response_model/Customer_review_for_pagination.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../home_module/home_module/model/review_model.dart';

class ReviewViewModel extends BaseViewModel {
  ScrollController controller = ScrollController();

  int _productId = 0;

  int _offset = 0;

  int _isCalledFirstTime = 0;

  int _itemTotalCount = 0;

  int _difference = 0;

  Api apiCall = locator<Api>();
  final navigationService = locator<NavigationService>();
  Map sourceMap = {ConnectivityResult.none: false};
  final MyConnectivity connectivity = MyConnectivity.instance;
  bool? isNetworkConnected;
  bool _isAPIError = false;
  bool _isAlreadyCalled = false;

  bool _hasMore = true;

  bool get hasMore => _hasMore;

  bool _isLocalDBAlreadyCalledForCustomerReview = false;

  // final List<UserReview> _commentsList = [];

  // List<UserReview> get commentsList => _commentsList;

  List<UserReview> _commentsList = List.empty(growable: true);

  List<UserReview> get commentsList => _commentsList;

  set commentsList(List<UserReview> commentsList) {
    _commentsList = commentsList;
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

  final HiveDbServices<ProductDetailById> _localDb =
      HiveDbServices(Constants.product_details);

  List<CustomerReviewForPagination> _customerReviewDetailsList =
      List.empty(growable: true);
  List<CustomerReviewForPagination> get customerReviewDetailsList =>
      _customerReviewDetailsList;

  set customerReviewDetailsList(
      List<CustomerReviewForPagination> customerReviewDetailsList) {
    _customerReviewDetailsList = customerReviewDetailsList;
    notifyListeners();
  }

  List<UserReview>? _userReviews = List.empty(growable: true);

  List<UserReview> get userReviews => _userReviews!;

  set userReviews(List<UserReview> userReviews) {
    _userReviews = userReviews;
    notifyListeners();
  }

  bool _isCustomerApiCalling = false;
  bool get isCustomerApiCalling => _isCustomerApiCalling;

  set isCustomerApiCalling(bool isCustomerApiCalling) {
    _isCustomerApiCalling = isCustomerApiCalling;
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

  bool get isAPIError => _isAPIError;
  set isAPIError(bool isAPIError) {
    _isAPIError = isAPIError;
    notifyListeners();
  }

  int get offset => _offset;
  set offset(int offset) {
    _offset = offset;
    notifyListeners();
  }

  int get isCalledFirstTime => _isCalledFirstTime;
  set isCalledFirstTime(int isCalledFirstTime) {
    _isCalledFirstTime = isCalledFirstTime;
    notifyListeners();
  }

  int? get productId => _productId;
  set productId(int? productId) {
    _productId = productId!;
    notifyListeners();
  }

  int get itemTotalCount => _itemTotalCount;
  set itemTotalCount(int itemTotalCount) {
    _itemTotalCount = itemTotalCount;
    notifyListeners();
  }

  int get difference => _difference;
  set difference(int difference) {
    _difference = difference;
    notifyListeners();
  }

  onScroll() {
    isCalledFirstTime = isCalledFirstTime + 1;
    // if (isBottom) {
    if (isCalledFirstTime == 1) {
      if (difference != 0 && difference > 0) {
        offset = offset + 10;
        getCustomerReviews(offset, true);
      } else {}
    }
  }

  bool get isBottom {
    if (!controller.hasClients) return false;
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  getCustomerReviews(offsetValue, bool isCalledPagination) async {
    HiveDbServices<CustomerReviewForPagination>
        _localDbForCustomerReviewForPagination =
        HiveDbServices(Constants.Leave_comment_for_pagination);

    _customerReviewDetailsList =
        await _localDbForCustomerReviewForPagination.getData();

    _customerReviewDetailsList.forEach((element) {
      if (element.productId == productId) {
        commentsList = element.customerReviewDetails!;
      }
    });

    if (commentsList.isEmpty) {
      if (!isCalledPagination) {
        setBusy(true);
      }
    } else {
      if (difference == 0) {
        _hasMore = false;
      }

      customerReviewDetailsList = _customerReviewDetailsList;

      customerReviewDetailsList.forEach((element) {
        if (element.productId == productId) {
          commentsList = element.customerReviewDetails!;

         
        }
      });
    }

    ProductReview reviewDetails =
        await apiCall.getLeaveComments(productId, offsetValue);

    switch (reviewDetails.statusCode) {
      case Constants.sucessCode:
        itemTotalCount = reviewDetails.totalReviewCount!;

        if (itemTotalCount != commentsList.length) {
          _commentsList.addAll(reviewDetails.reviews!);
        }

        difference = itemTotalCount - _commentsList.length;
        

        if (difference == 0) {
          _hasMore = false;
        }

        _customerReviewDetailsList
            .removeWhere((element) => element.productId == productId);

        CustomerReviewForPagination customerReviewByProduct =
            CustomerReviewForPagination(
                productId: productId, customerReviewDetails: _commentsList);
        _customerReviewDetailsList.clear();
        _customerReviewDetailsList.add(customerReviewByProduct);

        _localDbForCustomerReviewForPagination
            .putListData(_customerReviewDetailsList);

        _customerReviewDetailsList =
            await _localDbForCustomerReviewForPagination.getData();

        if (_customerReviewDetailsList != null &&
            _customerReviewDetailsList.isNotEmpty) {
          _customerReviewDetailsList.forEach((element) {
            if (element.productId == productId) {
              //_commentsList.clear();
              _commentsList = element.customerReviewDetails!;

              
            }
          });

          // _hasMore = false;
        }

        break;
      case Constants.wrongError:
        isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            reviewDetails.error ?? 'Oops Something went wrong');
        break;
      case Constants.networkErroCode:
        isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            reviewDetails.error ?? 'Oops Something went wrong');
        break;
      default:
        {
          if (reviewDetails.error != null && reviewDetails.error!.isNotEmpty) {
            isAPIError = true;
            AppUtil.showDialogbox(AppUtil.getContext(),
                reviewDetails.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    isCalledFirstTime = 0;
    if (!isCalledPagination) {
      setBusy(false);
    }
    // isCustomerApiCalling = false;
  }

  getLocalDataListComments(var productId) async {
    HiveDbServices<CustomerReviewForPagination>
        _localDbForCustomerReviewForPagination =
        HiveDbServices(Constants.Leave_comment_for_pagination);

    isLocalDBAlreadyCalledForCustomerReview = true;

    _customerReviewDetailsList =
        await _localDbForCustomerReviewForPagination.getData();

    if (_customerReviewDetailsList.isNotEmpty) {
      _customerReviewDetailsList.forEach((element) {
        if (element.productId == productId) {
          commentsList = element.customerReviewDetails!;
        }
      });
      customerReviewDetailsList = _customerReviewDetailsList;
    }
    return customerReviewDetailsList;
  }
}
