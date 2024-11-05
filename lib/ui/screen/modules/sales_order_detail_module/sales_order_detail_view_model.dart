import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/review_model.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/quotation_review_model.dart';
import 'package:powagroup/ui/screen/modules/quotation_review/quotation_review.dart';
import 'package:powagroup/ui/screen/modules/sales_order_detail_module/customer_review_by_product_for_sale.dart';
import 'package:powagroup/ui/screen/modules/sales_order_detail_module/response_model.dart/line_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_detail_module/response_model.dart/order_detail_response.dart';
import 'package:powagroup/ui/screen/modules/sales_order_detail_module/response_model.dart/sales_details_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/sales_order_response.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../services/hive_db_services.dart';
import '../product_detail_module.dart/response_model/customer_reviews_by_product.dart';
import '../product_detail_module.dart/response_model/product_detail_model.dart';
import '../quotation_detail_module/quotation_add_new_comments_model.dart';

class SalesOrderDetailViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  Api apiCall = locator<Api>();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  SalesOrderDetails salesOrderResponse = SalesOrderDetails();
  bool _isAPIError = false;
  int itemPerPage = 0;
  String _msg = '';
  String _title = '';
  bool set = false;

  bool get isAPIError => _isAPIError;
  set isAPIError(bool isAPIError) {
    _isAPIError = isAPIError;
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

  final FocusNode titleNode = FocusNode();
  TextEditingController titleController = TextEditingController();

  final FocusNode messageNode = FocusNode();

  TextEditingController msgController = TextEditingController();

  ProductDetailsData? _productDetails = ProductDetailsData();
  ProductDetailsData get productDetails => _productDetails!;

  set productDetails(ProductDetailsData productDetails) {
    _productDetails = productDetails;
    notifyListeners();
  }

  bool _isCustomerApiCalling = false;
  bool get isCustomerApiCalling => _isCustomerApiCalling;

  set isCustomerApiCalling(bool isCustomerApiCalling) {
    _isCustomerApiCalling = isCustomerApiCalling;
    notifyListeners();
  }

  bool _isDataFill = false;

  bool get isDataFill => _isDataFill;
  set isDataFill(bool isDataFill) {
    _isDataFill = isDataFill;
    notifyListeners();
  }

  List<CustomerReviewByProductForSale> _customerReviewDetailsList =
      new List.empty(growable: true);

  List<CustomerReviewByProductForSale> get customerReviewDetailsList =>
      _customerReviewDetailsList;

  set customerReviewDetailsList(
      List<CustomerReviewByProductForSale> productDetailsList) {
    _customerReviewDetailsList = customerReviewDetailsList;
    notifyListeners();
  }

  List<Message>? _userReviews = List.empty(growable: true);

  List<Message> get userReviews => _userReviews!;

  set userReviews(List<Message> userReviews) {
    _userReviews = userReviews;
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

  HiveDbServices<SalesOrderDetails> _localDb =
      HiveDbServices(Constants.sales_order_details);
  List<SalesOrderDetails> _salesOrderDetailsList = List.empty(growable: true);

  List<SalesOrderDetails> get salesOrderDetailsList => _salesOrderDetailsList;

  set salesOrderDetailsList(List<SalesOrderDetails> salesOrderDetailsList) {
    _salesOrderDetailsList = salesOrderDetailsList;
    notifyListeners();
  }

  Orders _orderData = Orders();

  Orders get orderData => _orderData;

  set orderData(Orders orderData) {
    _orderData = orderData;
    notifyListeners();
  }

  bool _isLocalDBAlreadyCalled = false;
  bool get isLocalDBAlreadyCalled => _isLocalDBAlreadyCalled;

  set isLocalDBAlreadyCalled(bool isLocalDBAlreadyCalled) {
    _isLocalDBAlreadyCalled = isLocalDBAlreadyCalled;
    notifyListeners();
  }

  onSendButtonClick(int? id) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      onButtonClick(id);
      notifyListeners();
    } else {}
  }

  // // Call API for sales order
  getSalesOrderDetails(bool calledFromOnModelReady, productId) async {
    if (!calledFromOnModelReady) {
      isAlreadyCalled = true;
    } else {
      isAlreadyCalled = false;
    }

    _salesOrderDetailsList = await _localDb.getData();

    if (_salesOrderDetailsList.isEmpty) {
      setBusy(true);
    } else {
      salesOrderDetailsList = _salesOrderDetailsList;

      salesOrderDetailsList.forEach(
        (element) {
          if (element.order!.id == productId) {
            orderData = element.order!;
          }
        },
      );
    }

    salesOrderResponse = await apiCall.getSalesOrderDetails(productId);
    switch (salesOrderResponse.statusCode) {
      case Constants.sucessCode:
        _localDb.clear();
        SalesOrderDetails salesOrderData =
            SalesOrderDetails(order: salesOrderResponse.order);

        salesOrderDetailsList.add(salesOrderData);

        _localDb.putListData(salesOrderDetailsList);

        _salesOrderDetailsList = await _localDb.getData();

        salesOrderDetailsList = _salesOrderDetailsList;
        salesOrderDetailsList.forEach(
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
            salesOrderResponse.error ?? 'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            salesOrderResponse.error ?? 'Oops Something went wrong');
        break;
      default:
        {
          if (salesOrderResponse.error != null &&
              salesOrderResponse.error!.isNotEmpty) {
            //isAPIError = true;
            AppUtil.showDialogbox(AppUtil.getContext(),
                salesOrderResponse.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    setBusy(false);
  }

  // // Call API for sales order
  // getSalesOrderDetails(productId) async {
  //   setBusy(true);

  //   salesOrderResponse = await apiCall.getSalesOrderDetails(productId);
  //   switch (salesOrderResponse!.statusCode) {
  //     case Constants.sucessCode:
  //       break;
  //     case Constants.wrongError:
  //       isAPIError = true;
  //       AppUtil.showDialogbox(AppUtil.getContext(),
  //           salesOrderResponse!.error ?? 'Oops Something went wrong');

  //       break;
  //     case Constants.networkErroCode:
  //       isAPIError = true;
  //       AppUtil.showDialogbox(AppUtil.getContext(),
  //           salesOrderResponse!.error ?? 'Oops Something went wrong');
  //       break;
  //     default:
  //       {
  //         if (salesOrderResponse!.error != null &&
  //             salesOrderResponse!.error!.isNotEmpty) {
  //           isAPIError = true;
  //           AppUtil.showDialogbox(AppUtil.getContext(),
  //               salesOrderResponse!.error ?? 'Oops Something went wrong');
  //         }
  //       }
  //       break;
  //   }
  //   setBusy(false);
  // }

  Future<List<SalesOrderDetails>> getLocalDataList(productId) async {
    isLocalDBAlreadyCalled = true;

    _salesOrderDetailsList = await _localDb.getData();

    salesOrderDetailsList = _salesOrderDetailsList;
    salesOrderDetailsList.forEach(
      (element) {
        if (element.order!.id == productId) {
          orderData = element.order!;
        }
      },
    );
    notifyListeners();
    return salesOrderDetailsList;
  }

  getTopComments(
      var productId, int itemPerPage, bool calledFromOnModelReady) async {
    if (!calledFromOnModelReady) {
      isAlreadyCalled = true;
    } else {
      isAlreadyCalled = false;
    }

    HiveDbServices<CustomerReviewByProductForSale>
        _localDbForCustomerReviewForSale =
        HiveDbServices(Constants.Leave_comment_For_Sale);

    // List<UserReview>? _customerReviewList =
    //     await _localDbForCustomerReview.getData();

    _customerReviewDetailsList =
        await _localDbForCustomerReviewForSale.getData();

    if (_customerReviewDetailsList.isEmpty) {
      isCustomerApiCalling = true;
      // setBusy(true);
    } else {
      customerReviewDetailsList = _customerReviewDetailsList.take(3).toList();

      customerReviewDetailsList.forEach((element) {
        if (element.productId == productId) {
          userReviews = element.customerReviewDetailsForSale!;
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
        _localDbForCustomerReviewForSale.clear();

        _customerReviewDetailsList
            .removeWhere((element) => element.productId == productId);

        CustomerReviewByProductForSale customerReviewByProductForQuote =
            CustomerReviewByProductForSale(
                productId: productId,
                customerReviewDetailsForSale:
                    quotationCommentsResponse.messages!.take(3).toList());

        _customerReviewDetailsList.add(customerReviewByProductForQuote);

        _localDbForCustomerReviewForSale
            .putListData(_customerReviewDetailsList);

        _customerReviewDetailsList =
            await _localDbForCustomerReviewForSale.getData();

        if (_customerReviewDetailsList != null &&
            _customerReviewDetailsList.isNotEmpty) {
          _customerReviewDetailsList.forEach((element) {
            if (element.productId == productId) {
              userReviews = element.customerReviewDetailsForSale!;
            }
          });
        }

        // _customerReviewList = await _localDbForCustomerReview.getData();

        // customerReviewList = _customerReviewList.take(3).toList();
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
        // rate = -1;
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

  // on See All Text Click
  onSeeAllClick(int? productId, BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: CustomerReviewViewForQuotation(
          productId: productId,
        ));
  }
}
