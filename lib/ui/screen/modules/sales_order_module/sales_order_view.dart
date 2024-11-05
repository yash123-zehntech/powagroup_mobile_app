import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/network_error%20widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/sales_order_view_model.dart';
import 'package:powagroup/ui/screen/modules/tracking_module/map_screen.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';

class SalesOrderView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SalesOrderViewState();
  }
}

class _SalesOrderViewState extends State<SalesOrderView>
    with TickerProviderStateMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SalesOrderViewModel>.reactive(
      viewModelBuilder: () => SalesOrderViewModel(),
      onDispose: (viewModel) {
        viewModel.controller.asMap().forEach((index, element) {
          viewModel.controller[index]!.dispose();
        });
      },
      onViewModelReady: (viewModel) async {
        viewModel.tickerProvider = this;

        bool isConnected = await AppUtil.checkNetwork();
        if (isConnected != null && isConnected) {
          viewModel.getSalesOrder(true);
        }
      },
      builder: (context, viewModel, child) => Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarWidget(
              title: 'Sales Orders',
              backIcon: IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                padding: EdgeInsets.only(left: 5.h),
                icon: Icon(
                  PowaGroupIcon.back,
                  size: 24.h,
                  color: const Color(0xff36393C),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          backgroundColor: const Color(0xffEFF1F2),
          body: !viewModel.isAPIError
              ? OfflineBuilder(
                  connectivityBuilder: (BuildContext context,
                      ConnectivityResult connectivity, Widget child) {
                    final bool connected =
                        connectivity != ConnectivityResult.none;
                    if (connected) {
                      if (!viewModel.isBusy &&
                          viewModel.salesOrdersList.isNotEmpty) {
                        return bodyWidget(viewModel);
                      }
                      return child;
                    } else if (!connected) {
                      if (!viewModel.isLocalDBAlreadyCalled) {
                        try {
                          Future.delayed(const Duration(milliseconds: 3), () {
                            viewModel.getLocalDataList();
                          });
                        } catch (error) {
                          viewModel.getLocalDataList();
                        }
                      }
                      if (viewModel.salesOrdersList.isNotEmpty) {
                        return bodyWidget(viewModel);
                      } else {
                        return Text("Not Found-",
                            style: TextStyle(color: Colors.black));
                      }
                    }
                    return child;
                  },
                  builder: ((context) {
                    if (viewModel.salesOrdersList.isNotEmpty) {
                      return bodyWidget(viewModel);
                    } else {
                      return NetworkError(
                        content: 'Sales Orders Not Found!!',
                        subContant: 'No data, Please try again later.',
                        icon: 'assets/icon/network_error.png',
                        viewModel: viewModel,
                      );
                    }
                  }),
                  child: child,
                )
              : Center(
                  child: NetworkError(
                  content: 'Sales Orders Not Found!!',
                  subContant: 'No data, Please try again later.',
                  icon: 'assets/icon/network_error.png',
                  viewModel: viewModel,
                ))),
    );
  }

  Widget bodyWidget(SalesOrderViewModel viewModel) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: viewModel.isBusy ? 10 : viewModel.salesOrdersList.length,
        padding: EdgeInsets.only(left: 16.h, right: 16.h, top: 16.h),
        itemBuilder: (BuildContext context, int index) {
          return salesOrderItem(viewModel, index, context);
        });
  }

  // Return Sales Order Item Widget
  Widget salesOrderItem(SalesOrderViewModel viewModel, int index, context) {
    return viewModel.isBusy
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ShimmerLoading(
                isLoading: true,
                child: Container(
                  width: double.infinity,
                  height: 100.h,
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10)),
                )),
          )
        : Container(
            margin: EdgeInsets.only(bottom: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: const Color(0xffFFFFFF),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  title: Text(
                    viewModel.salesOrdersList[index].name != null &&
                            viewModel.salesOrdersList[index].name!.isNotEmpty
                        ? '#${viewModel.salesOrdersList[index].name!}'
                        : "",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.33,
                        color: const Color(0xff36393C)),
                  ),
                  subtitle: Text(
                    AppUtil.getDate1(
                        viewModel.salesOrdersList[index].orderDate != null &&
                                viewModel.salesOrdersList[index].orderDate!
                                    .isNotEmpty
                            ? viewModel.salesOrdersList[index].orderDate
                            : ''),
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: Globlas.deviceType == "phone" ? 12 : 22,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.33,
                        color: const Color(0xff36393C)),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            viewModel.onExpandClick(
                                index, viewModel.salesOrdersList[index].id);
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, anim) =>
                                RotationTransition(
                              turns: child.key == const ValueKey('icon1')
                                  ? Tween<double>(begin: 1, end: 0)
                                      .animate(anim)
                                  : Tween<double>(begin: 0.75, end: 1)
                                      .animate(anim),
                              child:
                                  FadeTransition(opacity: anim, child: child),
                            ),
                            child: Icon(
                                viewModel.salesOrdersList[index].isExpand!
                                    ? PowaGroupIcon.arrow_up
                                    : PowaGroupIcon.arrow_down,
                                size: 9.h,
                                color:
                                    viewModel.salesOrdersList[index].isExpand!
                                        ? Color(0xffD60505)
                                        : const Color(0xff858D93),
                                key: viewModel.currIndex == 0
                                    ? const ValueKey("icon1")
                                    : const ValueKey("icon2")),
                          )),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapTrackingScreen(
                                        detailsShippingOrder: viewModel
                                            .salesOrdersList[index]
                                            .shippingDetails,
                                      )));
                        },
                        child: viewModel.salesOrdersList[index]
                                        .shippingDetails !=
                                    null &&
                                viewModel.salesOrdersList[index]
                                        .shippingDetails!.latitude !=
                                    null &&
                                viewModel.salesOrdersList[index]
                                        .shippingDetails!.longitude !=
                                    null
                            ? Icon(
                                PowaGroupIcon.truck_1,
                                size: 24.h,
                                color: Color(0xffFF9900),
                              )
                            : Text(
                                viewModel.salesOrdersList[index]
                                                .shippingStatus !=
                                            null &&
                                        viewModel.salesOrdersList[index]
                                            .shippingStatus!.isNotEmpty
                                    ? viewModel
                                        .salesOrdersList[index].shippingStatus!
                                    : 'N/A',
                                style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize:
                                        Globlas.deviceType == "phone" ? 10 : 20,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.33,
                                    color: viewModel.salesOrdersList[index]
                                                .shippingStatus ==
                                            "Shipped"
                                        ? const Color(0xff407937)
                                        : const Color(0xffFF9900)),
                              ),
                      ),
                    ],
                  ),
                  onTap: () {
                    viewModel.onSalesOrderItemClick(
                        viewModel.salesOrdersList[index].id, context);
                  },
                ),
                !viewModel.isBusy && viewModel.animation.length > 0
                    ? SizeTransition(
                        sizeFactor: viewModel.animation[index]!,
                        axis: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  viewModel.isBusy
                                      ? ShimmerLoading(
                                          isLoading: true,
                                          child: Container(
                                            width: double.infinity,
                                            height: 15.h,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ))
                                      : Text(
                                          viewModel.salesOrdersList[index]
                                                          .lines !=
                                                      null &&
                                                  viewModel
                                                      .salesOrdersList[index]
                                                      .lines
                                                      .toString()
                                                      .isNotEmpty
                                              ? '${viewModel.salesOrdersList[index].lines!.length - 1} Item'
                                              : "N/A",
                                          style: TextStyle(
                                              fontFamily: 'Raleway',
                                              fontSize:
                                                  Globlas.deviceType == "phone"
                                                      ? 14
                                                      : 24,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: -0.33,
                                              color: const Color(0xff36393C)),
                                        ),
                                  viewModel.isBusy
                                      ? ShimmerLoading(
                                          isLoading: true,
                                          child: Container(
                                            width: double.infinity,
                                            height: 15.h,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ))
                                      : Text(
                                          //  '\$ ',
                                          viewModel.salesOrdersList[index]
                                                          .total !=
                                                      null &&
                                                  viewModel
                                                      .salesOrdersList[index]
                                                      .total
                                                      .toString()
                                                      .isNotEmpty
                                              ? '\$${viewModel.salesOrdersList[index].total!.toStringAsFixed(2)}'
                                              : "",
                                          style: TextStyle(
                                              fontFamily: 'Raleway',
                                              fontSize:
                                                  Globlas.deviceType == "phone"
                                                      ? 18
                                                      : 28,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: -0.33,
                                              color: const Color(0xff33A3E4)),
                                        ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          );
  }

  // Return Product Item View
  Widget productItem(SalesOrderViewModel viewModel, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: viewModel.isBusy
          ? ShimmerLoading(
              isLoading: true,
              child: Container(
                width: double.infinity,
                height: 15.h,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10)),
              ))
          : Text(
              viewModel.salesOrdersList[index].name != null &&
                      viewModel.salesOrdersList[index].name!.isNotEmpty
                  ? viewModel.salesOrdersList[index].name!
                  : "",
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.33,
                  color: const Color(0xff36393C)),
            ),
    );
  }
}
