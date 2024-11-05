import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/connectivity.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/quotation_detial_view.dart';
import 'package:powagroup/ui/screen/modules/quotation_module/response_model/quotation_response.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/orderlist.model.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class QuotationViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  Map sourceMap = {ConnectivityResult.none: false};
  final MyConnectivity connectivity = MyConnectivity.instance;
  bool? isNetworkConnected;
  bool isExpandView = false;
  int currIndex = 0;

  List<Animation<double>?> animation = [];
  List<AnimationController?> controller = [];

  HiveDbServices<QuotationOrder> _localDb =
      HiveDbServices(Constants.quotation_orders);
  List<QuotationOrder> _quotationOrdersList = List.empty(growable: true);

  Api apiCall = locator<Api>();
  bool _isAlreadyCalled = false;
  List<QuotationOrder> get quotationOrdersList => _quotationOrdersList;

  set quotationOrdersList(List<QuotationOrder> quotationOrdersList) {
    _quotationOrdersList = quotationOrdersList;
    notifyListeners();
  }

  bool _isLocalDBAlreadyCalled = false;
  bool _isAPIError = false;

  dynamic _tickerProvider;

  dynamic get tickerProvider => _tickerProvider;
  set tickerProvider(dynamic tickerProvider) {
    _tickerProvider = tickerProvider;
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
      Future.delayed(const Duration(seconds: 4), () {
        notifyListeners();
      });
    } catch (error) {}
  }
  // // on login buttion clik

  bool get isLocalDBAlreadyCalled => _isLocalDBAlreadyCalled;

  set isLocalDBAlreadyCalled(bool isLocalDBAlreadyCalled) {
    _isLocalDBAlreadyCalled = isLocalDBAlreadyCalled;
    notifyListeners();
  }

  onQuotationItemClick(int? productId, context) {
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: QuotationDetialView(
          productId: productId,
        ));
  }

  // on Expand Icon click
  onExpandClick(index, int? id) {
    quotationOrdersList.forEach((element) {
      if (element.id == id) {
        element.isExpand = !element.isExpand!;
        animateView(controller[index], animation[index], index, id!);
      } else {
        element.isExpand = false;
      }
      notifyListeners();
    });
  }

  animateView(AnimationController? _controller, Animation<double>? _animation,
      int index, int quotationId) {
    if (animation[index]!.status != AnimationStatus.completed) {
      quotationOrdersList.asMap().forEach((indexValue, element) {
        if (element.id == quotationId) {
          controller[index]!.forward();
          notifyListeners();
        } else {
          controller[indexValue]!.reverse();
          notifyListeners();
        }
      });
    } else {
      quotationOrdersList.forEach((element) {
        controller[index]!.reverse();
        notifyListeners();
      });
    }
  }

  // // Call API for sales order
  getQuotations(bool calledFromOnModelReady) async {
    String loginToken = await AppUtil.getLoginToken();

    if (loginToken != null && loginToken.isNotEmpty) {
      if (!calledFromOnModelReady) {
        isAlreadyCalled = true;
      } else {
        isAlreadyCalled = false;
      }
      int addressId = 0;
      _quotationOrdersList = await _localDb.getData();

      if (_quotationOrdersList.isEmpty) {
        setBusy(true);
      } else {
        quotationOrdersList = _quotationOrdersList;
      }

      QuotationResponse? quotationResponse = await apiCall.getQuotations();

      switch (quotationResponse.statusCode) {
        case Constants.sucessCode:
          quotationOrdersList.forEach((element) {
            if (element.isExpand!) {
              addressId = element.id!;
            }
          });
          quotationOrdersList.clear();
          if (quotationResponse.orders != null &&
              quotationResponse.orders!.length > 0) {
            quotationResponse.orders!.forEach((element) {
              quotationOrdersList.add(QuotationOrder(
                customer: element.customer,
                customerId: element.customerId,
                customerName: element.customerName,
                deliveries: element.deliveries,
                deliveryEx: element.deliveryEx,
                expiryDate: element.expiryDate,
                id: element.id,
                invoiceAddress: element.invoiceAddress,
                invoices: element.invoices,
                name: element.name,
                orderDate: element.orderDate,
                paymentStatus: element.paymentStatus,
                shippingAddress: element.shippingAddress,
                shippingStatus: element.shippingStatus,
                siteContact: element.siteContact,
                state: element.state,
                subtotal: element.subtotal,
                subtotalExDelivery: element.subtotalExDelivery,
                tax: element.tax,
                total: element.total,
                isExpand: addressId == element.id ? true : false,
              ));
            });

            for (int i = 0; i < quotationOrdersList.length; i++) {
              controller.add(AnimationController(
                duration: const Duration(milliseconds: 1000),
                vsync: tickerProvider,
                reverseDuration: const Duration(milliseconds: 1000),
              ));
              animation.add(CurvedAnimation(
                parent: controller[i]!,
                curve: Curves.fastLinearToSlowEaseIn,
                reverseCurve: Curves.easeInToLinear,
              ));
            }
          }

          _localDb.clear();

          _localDb.putListData(quotationOrdersList);

          _quotationOrdersList = await _localDb.getData();

          quotationOrdersList = _quotationOrdersList;
          notifyListeners();

          break;
        case Constants.wrongError:
          isAPIError = true;
          AppUtil.showDialogbox(AppUtil.getContext(),
              quotationResponse.error ?? 'Oops Something went wrong');

          break;
        case Constants.networkErroCode:
          isAPIError = true;
          AppUtil.showDialogbox(AppUtil.getContext(),
              quotationResponse.error ?? 'Oops Something went wrong');
          break;
        default:
          {
            if (quotationResponse.error != null &&
                quotationResponse.error!.isNotEmpty) {
              //isAPIError = true;
              AppUtil.showDialogbox(AppUtil.getContext(),
                  quotationResponse.error ?? 'Oops Something went wrong');
            }
          }
          break;
      }
      setBusy(false);
    } else {
      AppUtil.showLoginMessageDialog(AppUtil.getContext(),
          'Please Sign In/Register to view your quotations');
    }
  }

  Future<List<QuotationOrder>> getLocalDataList() async {
    isLocalDBAlreadyCalled = true;
    _quotationOrdersList = await _localDb.getData();
    if (_quotationOrdersList.isNotEmpty) {
      quotationOrdersList = _quotationOrdersList;
    }
    return quotationOrdersList;
  }
}
