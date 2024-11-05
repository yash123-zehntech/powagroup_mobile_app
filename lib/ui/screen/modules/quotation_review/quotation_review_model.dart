import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/connectivity.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/quotation_review_model.dart';
import 'package:powagroup/ui/screen/modules/quotation_review/response_model/quotation_review_for_pagination.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../services/hive_db_services.dart';
import '../reviews/response_model/Customer_review_for_pagination.dart';

class QuotationReviewViewModel extends BaseViewModel {
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

  List<Message> _commentsList = List.empty(growable: true);

  List<Message> get commentsList => _commentsList;

  set commentsList(List<Message> commentsList) {
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

  // final HiveDbServices<ProductDetailById> _localDb =
  //     HiveDbServices(Constants.product_details);

  List<QuotationPageReviewForPagination> _customerReviewDetailsList =
      List.empty(growable: true);
  List<QuotationPageReviewForPagination> get customerReviewDetailsList =>
      _customerReviewDetailsList;

  set customerReviewDetailsList(
      List<QuotationPageReviewForPagination> customerReviewDetailsList) {
    _customerReviewDetailsList = customerReviewDetailsList;
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
        getCustomerReviewsForQuation(offset, false);
      } else {}
    }
  }

  bool get isBottom {
    if (!controller.hasClients) return false;
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  getCustomerReviewsForQuation(offsetValue, bool isCalledPagination) async {
    HiveDbServices<QuotationPageReviewForPagination>
        _localDbForQuotationReviewForPagination =
        HiveDbServices(Constants.Leave_comment_For_Quote_page);

    _customerReviewDetailsList =
        await _localDbForQuotationReviewForPagination.getData();

    _customerReviewDetailsList.forEach((element) {
      if (element.productId == productId) {
        commentsList = element.customerReviewDetailsForQuoteList!;
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
          commentsList = element.customerReviewDetailsForQuoteList!;
        }
      });
    }

    QuotationComments reviewDetails =
        await apiCall.getLeaveCommentsForQuotation(productId, offsetValue);

    switch (reviewDetails.statusCode) {
      case Constants.sucessCode:

        // itemTotalCount = reviewDetails.totalReviewCount!;
        itemTotalCount = 24;

        if (itemTotalCount != commentsList.length) {
          _commentsList.clear();
          _commentsList.addAll(reviewDetails.messages!);
        }

        difference = itemTotalCount - _commentsList.length;

        if (difference == 0) {
          _hasMore = false;
        }

        _customerReviewDetailsList
            .removeWhere((element) => element.productId == productId);

        QuotationPageReviewForPagination customerReviewByProduct =
            QuotationPageReviewForPagination(
                productId: productId,
                customerReviewDetailsForQuoteList: _commentsList);

        _customerReviewDetailsList.clear();
        _customerReviewDetailsList.add(customerReviewByProduct);

        // _localDbForQuotationReviewForPagination.clear();

        _localDbForQuotationReviewForPagination
            .putListData(_customerReviewDetailsList);

        _customerReviewDetailsList =
            await _localDbForQuotationReviewForPagination.getData();

        if (_customerReviewDetailsList != null &&
            _customerReviewDetailsList.isNotEmpty) {
          _customerReviewDetailsList.forEach((element) {
            if (element.productId == productId) {
              // _commentsList.clear();
              _commentsList = element.customerReviewDetailsForQuoteList!;
            }
          });
          // notifyListeners();

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
    HiveDbServices<QuotationPageReviewForPagination>
        _localDbForQuotationReviewForPagination =
        HiveDbServices(Constants.Leave_comment_For_Quote_page);

    isLocalDBAlreadyCalledForCustomerReview = true;

    _customerReviewDetailsList =
        await _localDbForQuotationReviewForPagination.getData();

    if (_customerReviewDetailsList.isNotEmpty) {
      _customerReviewDetailsList.forEach((element) {
        if (element.productId == productId) {
          commentsList = element.customerReviewDetailsForQuoteList!;
        }
      });
      customerReviewDetailsList = _customerReviewDetailsList;
    }
    return customerReviewDetailsList;
  }
}
