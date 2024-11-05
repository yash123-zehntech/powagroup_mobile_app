import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/quotation_add_new_comments_model.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/quotation_review_model.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/response_model/customer_reviews_by_product_for_quote.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/response_model/quotation_detail_responsemodel.dart';

import 'package:powagroup/ui/screen/modules/quotation_module/response_model/quotation_response.dart';
import 'package:powagroup/ui/screen/modules/quotation_review/quotation_review.dart';

import 'package:powagroup/ui/screen/modules/sales_order_detail_module/response_model.dart/order_detail_response.dart';

import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../util/constant.dart';

import '../product_detail_module.dart/response_model/product_detail_model.dart';

class QuotationDetailViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  QuotationResponse? quotationResponse;
  Api apiCall = locator<Api>();
  // AnimationController? controller;
  QuotationOrderDetailsList quotationOrderResponse =
      QuotationOrderDetailsList();
  bool _isAPIError = false;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  String _msg = '';
  String _title = '';
  bool set = false;
  int itemPerPage = 0;

  bool get isAPIError => _isAPIError;
  set isAPIError(bool isAPIError) {
    _isAPIError = isAPIError;
    notifyListeners();
  }

  List<Message>? _userReviews = List.empty(growable: true);

  List<Message> get userReviews => _userReviews!;

  set userReviews(List<Message> userReviews) {
    _userReviews = userReviews;
    notifyListeners();
  }

  int rates = 0;
  int get rate => rates;
  set rate(int rate) {
    rates = rate;
    notifyListeners();
  }

  bool _isSet = false;
  bool get isSet => _isSet;
  set isSet(bool isSet) {
    _isSet = isSet;
    notifyListeners();
  }

  String get title => _title;
  set title(String title) {
    _title = title;
    notifyListeners();
  }

  List<CustomerReviewByProductForQuote> _customerReviewDetailsList =
      new List.empty(growable: true);

  List<CustomerReviewByProductForQuote> get customerReviewDetailsList =>
      _customerReviewDetailsList;

  set customerReviewDetailsList(
      List<CustomerReviewByProductForQuote> productDetailsList) {
    _customerReviewDetailsList = customerReviewDetailsList;
    notifyListeners();
  }

  ProductDetailsData? _productDetails = ProductDetailsData();
  ProductDetailsData get productDetails => _productDetails!;

  set productDetails(ProductDetailsData productDetails) {
    _productDetails = productDetails;
    notifyListeners();
  }

  bool _isDataFill = false;

  bool get isDataFill => _isDataFill;
  set isDataFill(bool isDataFill) {
    _isDataFill = isDataFill;
    notifyListeners();
  }

  bool _showPricing = false;
  bool get showPricing => _showPricing;
  set showPricing(bool value) {
    _showPricing = value;
    notifyListeners();
  }

  final FocusNode titleNode = FocusNode();
  TextEditingController titleController = TextEditingController();

  final FocusNode messageNode = FocusNode();

  TextEditingController msgController = TextEditingController();

  QuotationAddNewComments? quotationAddNewComments;

  // on See All Text Click
  onSeeAllClick(int? productId, context) {
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: CustomerReviewViewForQuotation(
          productId: productId,
        ));
  }

  onSendButtonClick(int? id) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      onButtonClick(id);
      notifyListeners();
    } else {}
  }

  onButtonClick(var productId) async {
    setBusy(true);
    var map = Map<String, dynamic>();
    map['message'] = titleController.text.toString();

    QuotationAddNewComments quotationAddNewCommentsResponse =
        await apiCall.commentSectionForQuotation(map, productId,
            titleController.text.toString(), msgController.text.toString());
    switch (quotationAddNewCommentsResponse.statusCode) {
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
            quotationAddNewCommentsResponse.error ?? "Something Went Wrong");
        // isExpandView = false;
        notifyListeners();

        break;
      case Constants.networkErroCode:
        isDataFill = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            quotationAddNewCommentsResponse.error ?? "Something Went Wrong");

        break;
      default:
        {
          if (quotationAddNewCommentsResponse.error != null &&
              quotationAddNewCommentsResponse.error!.isNotEmpty) {
            //AppUtil.showToast(loginResp.error ?? '');
          }
        }
        break;
    }
    setBusy(false);
  }

  onAcceptButtonClick() {
    navigationService.navigateTo(Routes.loginView);
  }

  HiveDbServices<QuotationOrderDetailsList> _localDb =
      HiveDbServices(Constants.quotation_details);
  List<QuotationOrderDetailsList> _quotationOrderDetailsList =
      List.empty(growable: true);

  List<QuotationOrderDetailsList> get quotationOrderDetailsList =>
      _quotationOrderDetailsList;

  set quotationOrderDetailsList(
      List<QuotationOrderDetailsList> quotationOrderDetailsList) {
    _quotationOrderDetailsList = quotationOrderDetailsList;
    notifyListeners();
  }

  Orders _orderData = Orders();

  Orders get orderData => _orderData;

  set orderData(Orders orderData) {
    _orderData = orderData;
    notifyListeners();
  }

  bool _isCustomerApiCalling = false;
  bool get isCustomerApiCalling => _isCustomerApiCalling;

  set isCustomerApiCalling(bool isCustomerApiCalling) {
    _isCustomerApiCalling = isCustomerApiCalling;
    notifyListeners();
  }

  bool _isLocalDBAlreadyCalled = false;
  bool get isLocalDBAlreadyCalled => _isLocalDBAlreadyCalled;

  set isLocalDBAlreadyCalled(bool isLocalDBAlreadyCalled) {
    _isLocalDBAlreadyCalled = isLocalDBAlreadyCalled;
    notifyListeners();
  }

  bool _isAlreadyCalled = false;
  bool get isAlreadyCalled => _isAlreadyCalled;

  set isAlreadyCalled(bool isAlreadyCalled) {
    _isAlreadyCalled = isAlreadyCalled;

    try {
      Future.delayed(const Duration(milliseconds: 1), () {
        notifyListeners();
      });
    } catch (error) {}
  }

  // // API calling
  // // Call API for sales order
  getQuotationDetails(bool calledFromOnModelReady, productId) async {
    if (!calledFromOnModelReady) {
      isAlreadyCalled = true;
    } else {
      isAlreadyCalled = false;
    }

    _quotationOrderDetailsList = await _localDb.getData();

    if (_quotationOrderDetailsList.isEmpty) {
      setBusy(true);
    } else {
      quotationOrderDetailsList = _quotationOrderDetailsList;

      quotationOrderDetailsList.forEach(
        (element) {
          if (element.order!.id == productId) {
            orderData = element.order!;
            notifyListeners();
          }
        },
      );
    }

    quotationOrderResponse =
        await apiCall.getQuotationDetails(productId.toString());

    switch (quotationOrderResponse.statusCode) {
      case Constants.sucessCode:
        _localDb.clear();
        QuotationOrderDetailsList quotationOrderData =
            QuotationOrderDetailsList(order: quotationOrderResponse.order);

        quotationOrderDetailsList.add(quotationOrderData);

        _localDb.putListData(quotationOrderDetailsList);

        _quotationOrderDetailsList = await _localDb.getData();

        quotationOrderDetailsList = _quotationOrderDetailsList;
        quotationOrderDetailsList.forEach(
          (element) {
            if (element.order!.id == productId) {
              orderData = element.order!;
            }
          },
        );

        notifyListeners();

        break;
      case Constants.wrongError:
        isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            quotationOrderResponse.error ?? 'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            quotationOrderResponse.error ?? 'Oops Something went wrong');
        break;
      default:
        {
          if (quotationOrderResponse.error != null &&
              quotationOrderResponse.error!.isNotEmpty) {
            //isAPIError = true;
            AppUtil.showDialogbox(AppUtil.getContext(),
                quotationOrderResponse.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    setBusy(false);
  }

  Future<List<QuotationOrderDetailsList>> getLocalDataList(productId) async {
    isLocalDBAlreadyCalled = true;

    _quotationOrderDetailsList = await _localDb.getData();

    quotationOrderDetailsList = _quotationOrderDetailsList;
    quotationOrderDetailsList.forEach(
      (element) {
        if (element.order!.id == productId) {
          orderData = element.order!;
        }
      },
    );
    notifyListeners();
    return quotationOrderDetailsList;
  }

  // getQuotationDetails(var qutationId) async {
  //   setBusy(true);

  //   quotationResponse =
  //       await apiCall.getQuotationDetails(qutationId.toString());

  //   switch (quotationResponse!.statusCode) {
  //     case Constants.sucessCode:
  //       break;
  //     case Constants.wrongError:
  //       isAPIError = true;
  //       AppUtil.showDialogbox(AppUtil.getContext(),
  //           quotationResponse!.error ?? 'Oops Something went wrong');

  //       break;
  //     case Constants.networkErroCode:
  //       isAPIError = true;
  //       AppUtil.showDialogbox(AppUtil.getContext(),
  //           quotationResponse!.error ?? 'Oops Something went wrong');
  //       break;
  //     default:
  //       {
  //         if (quotationResponse!.error != null &&
  //             quotationResponse!.error!.isNotEmpty) {
  //           isAPIError = true;
  //           AppUtil.showDialogbox(AppUtil.getContext(),
  //               quotationResponse!.error ?? 'Oops Something went wrong');
  //         }
  //       }
  //       break;
  //   }
  //   setBusy(false);
  // }

  getTopComments(
      var productId, int itemPerPage, bool calledFromOnModelReady) async {
    if (!calledFromOnModelReady) {
      isAlreadyCalled = true;
    } else {
      isAlreadyCalled = false;
    }

    HiveDbServices<CustomerReviewByProductForQuote>
        _localDbForCustomerReviewForQuote =
        HiveDbServices(Constants.Leave_comment_For_Quote);

    // List<UserReview>? _customerReviewList =
    //     await _localDbForCustomerReview.getData();

    _customerReviewDetailsList =
        await _localDbForCustomerReviewForQuote.getData();

    if (_customerReviewDetailsList.isEmpty) {
      isCustomerApiCalling = true;
      // setBusy(true);
    } else {
      customerReviewDetailsList = _customerReviewDetailsList.take(3).toList();

      customerReviewDetailsList.forEach((element) {
        if (element.productId == productId) {
          userReviews = element.customerReviewDetailsForQuote!;
        }
      });
    }

    QuotationComments quotationCommentsResponse =
        await apiCall.getLeaveCommentsForQuotation(
      productId,
      itemPerPage,
    );

    switch (quotationCommentsResponse.statusCode) {
      case Constants.sucessCode:
        _localDbForCustomerReviewForQuote.clear();

        _customerReviewDetailsList
            .removeWhere((element) => element.productId == productId);

        CustomerReviewByProductForQuote customerReviewByProductForQuote =
            CustomerReviewByProductForQuote(
                productId: productId,
                customerReviewDetailsForQuote:
                    quotationCommentsResponse.messages!.take(3).toList());

        // reviewDetails.messages!.take(3).toList());

        _customerReviewDetailsList.add(customerReviewByProductForQuote);

        _localDbForCustomerReviewForQuote
            .putListData(_customerReviewDetailsList);

        _customerReviewDetailsList =
            await _localDbForCustomerReviewForQuote.getData();

        if (_customerReviewDetailsList != null &&
            _customerReviewDetailsList.isNotEmpty) {
          _customerReviewDetailsList.forEach((element) {
            if (element.productId == productId) {
              userReviews = element.customerReviewDetailsForQuote!;
            }
          });
        }

        break;
      case Constants.wrongError:
        AppUtil.showDialogbox(AppUtil.getContext(),
            quotationCommentsResponse.error ?? 'Oops Something went wrong');
        break;
      case Constants.networkErroCode:
        AppUtil.showDialogbox(AppUtil.getContext(),
            quotationCommentsResponse.error ?? 'Oops Something went wrong');
        break;
      default:
        {
          if (quotationCommentsResponse.error != null &&
              quotationCommentsResponse.error!.isNotEmpty) {
            AppUtil.showDialogbox(AppUtil.getContext(),
                quotationCommentsResponse.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    isCustomerApiCalling = false;
    // setBusy(false);
  }
}
