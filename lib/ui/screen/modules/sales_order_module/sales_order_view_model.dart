import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/sales_order_detail_module/sales_order_detail_view.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/orderlist.model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/sales_order_response.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SalesOrderViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  int currIndex = 0;
  HiveDbServices<Order> _localDb = HiveDbServices(Constants.sales_orders);

  List<Animation<double>?> animation = [];
  List<AnimationController?> controller = [];

  List<Order> _salesOrdersList = List.empty(growable: true);

  List<Order> get salesOrdersList => _salesOrdersList;

  set salesOrdersList(List<Order> salesOrdersList) {
    _salesOrdersList = salesOrdersList;
    notifyListeners();
  }

  Api apiCall = locator<Api>();
  bool _isLocalDBAlreadyCalled = false;
  bool _isAPIError = false;
  bool _isAlreadyCalled = false;
  bool get isAPIError => _isAPIError;
  set isAPIError(bool isAPIError) {
    _isAPIError = isAPIError;
    notifyListeners();
  }

  dynamic _tickerProvider;

  dynamic get tickerProvider => _tickerProvider;
  set tickerProvider(dynamic tickerProvider) {
    _tickerProvider = tickerProvider;
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

  bool get isLocalDBAlreadyCalled => _isLocalDBAlreadyCalled;

  set isLocalDBAlreadyCalled(bool isLocalDBAlreadyCalled) {
    _isLocalDBAlreadyCalled = isLocalDBAlreadyCalled;
    notifyListeners();
  }

  // // on login buttion clik
  onSalesOrderItemClick(int? productId, context) {
    // navigationService.navigateTo(Routes.salesOrderDetialView,
    //     arguments: SalesOrderDetialViewArguments(productId: productId));

    PersistentNavBarNavigator.pushNewScreen(context,
        screen: SalesOrderDetialView(
          productId: productId,
        ));
  }

  // on Expand Icon click
  onExpandClick(index, int? id) {
    salesOrdersList.forEach((element) {
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
      salesOrdersList.asMap().forEach((indexValue, element) {
        if (element.id == quotationId) {
          controller[index]!.forward();
          notifyListeners();
        } else {
          controller[indexValue]!.reverse();
          notifyListeners();
        }
      });
    } else {
      salesOrdersList.forEach((element) {
        controller[index]!.reverse();
        notifyListeners();
      });
    }
  }

  // // Call API for sales order
  getSalesOrder(bool calledFromOnModelReady) async {
    String loginToken = await AppUtil.getLoginToken();

    if (loginToken != null && loginToken.isNotEmpty) {
      if (!calledFromOnModelReady) {
        isAlreadyCalled = true;
      } else {
        isAlreadyCalled = false;
      }

      _salesOrdersList = await _localDb.getData();

      if (_salesOrdersList.isEmpty) {
        setBusy(true);
      } else {
        salesOrdersList = _salesOrdersList;
      }

      SalesOrderResponse? salesOrderResponse = await apiCall.getSalesOrder();

      switch (salesOrderResponse.statusCode) {
        case Constants.sucessCode:
          salesOrdersList.clear();
          if (salesOrderResponse.orders != null &&
              salesOrderResponse.orders!.length > 0) {
            salesOrderResponse.orders!.forEach((element) {
              salesOrdersList.add(Order(
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
                  shippingDetails: element.shippingDetails,
                  siteContact: element.siteContact,
                  state: element.state,
                  subtotal: element.subtotal,
                  subtotalExDelivery: element.subtotal,
                  tax: element.tax,
                  total: element.total,
                  isExpand: false,
                  lines: element.lines));
            });
          }

          for (int i = 0; i < salesOrdersList.length; i++) {
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

          _localDb.clear();

          _localDb.putListData(salesOrdersList);

          _salesOrdersList = await _localDb.getData();

          salesOrdersList = _salesOrdersList;
          print("length -------- ${salesOrdersList.length}");
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
              AppUtil.showDialogbox(AppUtil.getContext(),
                  salesOrderResponse.error ?? 'Oops Something went wrong');
            }
          }
          break;
      }
      setBusy(false);
    } else {
      AppUtil.showLoginMessageDialog(AppUtil.getContext(),
          'Please Sign In/Register to view your sales orders');
    }
  }

  Future<List<Order>> getLocalDataList() async {
    isLocalDBAlreadyCalled = true;
    _salesOrdersList = await _localDb.getData();
    if (_salesOrdersList.isNotEmpty) {
      salesOrdersList = _salesOrdersList;
    }
    return salesOrdersList;
  }
}
