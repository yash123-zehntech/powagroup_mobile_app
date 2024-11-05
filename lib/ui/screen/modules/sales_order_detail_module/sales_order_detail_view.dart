import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/bullet_point_widget.dart';
import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/helper_widget/double_icon_widget.dart';
import 'package:powagroup/helper_widget/network_error%20widget.dart';
import 'package:powagroup/helper_widget/popup_menu_widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/services/download_service.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/product_detail_view_model.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/quotation_review_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_detail_module/sales_order_detail_view_model.dart';
import 'package:powagroup/ui/screen/modules/tracking_module/map_screen.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:powagroup/util/validator.dart';
import 'package:readmore/readmore.dart';
import 'package:stacked/stacked.dart';

import '../home_module/home_module/model/review_model.dart';

class SalesOrderDetialView extends StatelessWidget {
  int? productId;
  SalesOrderDetialView({Key? key, this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SalesOrderDetailViewModel>.reactive(
      viewModelBuilder: () => SalesOrderDetailViewModel(),
      onViewModelReady: (viewModel) async {
        bool isConnected = await AppUtil.checkNetwork();
        if (isConnected != null && isConnected) {
          viewModel.getSalesOrderDetails(
            true,
            productId,
          );
          viewModel.getTopComments(productId, viewModel.itemPerPage, true);
        }
        // viewModel.getSalesOrderDetails(productId);
      },
      builder: (context, viewModel, child) => Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarWidget(
              title: 'Sales Order',
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
                  //viewModel.navigationService.back();
                  Navigator.pop(context);
                },
              ),
              // actionIcon: PopupWidget(
              //   id: productId != null
              //       ? productId.toString()
              //       : '', //productId.toString(),
              //   viewModel: viewModel,
              // )
              // actionIcon: IconButton(
              //   padding: const EdgeInsets.only(right: 15),
              //   icon: Icon(
              //     PowaGroupIcon.heart,
              //     size: 24.h,
              //     color: const Color(0xff36393C),
              //   ),
              //   onPressed: () {
              //     viewModel.navigationService.back();
              //   },
              // ),
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
                      //viewModel.categoriesList
                      if (!viewModel.isBusy &&
                          viewModel.salesOrderDetailsList.isNotEmpty &&
                          viewModel.orderData.id != null) {
                        return bodyWidget(viewModel, context);
                      } else {
                        if (!viewModel.isAlreadyCalled) {
                          viewModel.getSalesOrderDetails(false, productId);
                          viewModel.getTopComments(
                              productId, viewModel.itemPerPage, false);
                        }
                      }
                      return child;
                    } else if (!connected) {
                      if (!viewModel.isLocalDBAlreadyCalled) {
                        viewModel.getLocalDataList(productId);
                        // try {
                        //   Future.delayed(const Duration(milliseconds: 1), () {
                        //     viewModel.getLocalDataList(productId);
                        //   });
                        // } catch (error) {
                        //   viewModel.getLocalDataList(productId);
                        // }
                      }
                      if (viewModel.salesOrderDetailsList.isNotEmpty &&
                          viewModel.orderData.id != null) {
                        return bodyWidget(viewModel, context);
                      } else {
                        return NetworkError(
                          content: 'Network Error',
                          subContant: 'The network connection is lost',
                          icon: 'assets/icon/mobile_network_error.png',
                          viewModel: viewModel,
                        );
                      }
                    }
                    return child;
                  },
                  builder: ((context) {
                    return bodyWidget(viewModel, context);
                  }),
                  child: child,
                )
              : NetworkError(
                  content: 'Sales Order Details Not Found!!',
                  subContant: 'No data, Please try again later.',
                  icon: 'assets/icon/network_error.png',
                  viewModel: viewModel,
                )),
    );
  }

  // Return Sales Order Details Widget
  Widget detailWidget(
      SalesOrderDetailViewModel viewModel, BuildContext context) {
    return viewModel.isBusy || viewModel.orderData.id == null
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ShimmerLoading(
                isLoading: true,
                child: Container(
                  width: double.infinity,
                  height: 220.h,
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10)),
                )),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 16.h, right: 16.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 65.h,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        viewModel.orderData != null
                            ? '#${viewModel.orderData.name == null ? '' : viewModel.orderData.name}'
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
                        viewModel.orderData != null
                            ? viewModel.orderData.orderDate != null
                                ? AppUtil.getDate1(
                                    viewModel.orderData.orderDate != null
                                        ? viewModel.orderData.orderDate
                                        : '')
                                : ''
                            : '',
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
                          Text(
                            viewModel.orderData != null
                                ? '${viewModel.orderData.paymentStatus == null ? '' : viewModel.orderData.paymentStatus}'
                                : 'Wating payment',
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize:
                                    Globlas.deviceType == "phone" ? 12 : 19,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.33,
                                color: viewModel.orderData != null &&
                                        viewModel.orderData.paymentStatus ==
                                            "invoiced_part_paid"
                                    ? const Color(0xffFF9900)
                                    : viewModel.orderData.paymentStatus ==
                                            "invoice_paid"
                                        ? const Color(0xff407937)
                                        : const Color(0xffD60505)),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapTrackingScreen(
                                            detailsShippingOrder: viewModel
                                                .orderData.shippingDetails,
                                          )));
                            },
                            child: viewModel.orderData.shippingDetails !=
                                        null &&
                                    viewModel.orderData.shippingDetails!
                                            .latitude !=
                                        null &&
                                    viewModel.orderData.shippingDetails!
                                            .longitude !=
                                        null
                                ? Icon(
                                    PowaGroupIcon.truck_1,
                                    size: 24.h,
                                    color: Color(0xffFF9900),
                                  )
                                : Text(
                                    viewModel.orderData != null
                                        ? '${viewModel.orderData.shippingStatus == null ? 'N/A' : viewModel.orderData.shippingStatus}'
                                        : 'N/A',
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: Globlas.deviceType == "phone"
                                            ? 12
                                            : 18,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.33,
                                        color: viewModel.orderData != null &&
                                                viewModel.orderData
                                                        .shippingStatus ==
                                                    "part_shipped"
                                            ? const Color(0xffFF9900)
                                            : viewModel.orderData
                                                        .shippingStatus ==
                                                    "shipped"
                                                ? const Color(0xff407937)
                                                : const Color(0xffD60505)),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  addressWidget(
                      'Invoicing  Address',
                      viewModel.orderData != null
                          ? '${viewModel.orderData.invoiceAddress == null ? '' : '${viewModel.orderData.invoiceAddress!.street1} ${viewModel.orderData.invoiceAddress!.city}${viewModel.orderData.invoiceAddress!.state} ${viewModel.orderData.invoiceAddress!.country}'}'
                          : 'N/A'),
                  const SizedBox(
                    height: 12,
                  ),
                  addressWidget(
                      'Shipping Address',
                      viewModel.orderData != null
                          ? '${viewModel.orderData.shippingAddress == null ? '' : '${viewModel.orderData.shippingAddress!.street1} ${viewModel.orderData.shippingAddress!.city}${viewModel.orderData.shippingAddress!.state} ${viewModel.orderData.shippingAddress!.country}'}'
                          : 'N/A'),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(
                    height: 1,
                    color: Color(0xff858D93),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  invoiceDeliveryOrderWidget(
                      'Invoices :',
                      viewModel.orderData != null
                          ? viewModel.orderData.invoices != null &&
                                  viewModel.orderData.invoices!.isNotEmpty
                              ? '${viewModel.orderData.invoices![0].invoiceNumber}'
                              : 'N/A'
                          : 'N/A',
                      viewModel.orderData.invoices != null &&
                              viewModel.orderData.invoices!.isNotEmpty
                          ? viewModel.orderData.invoices![0].pdfUrl!
                          : ""),
                  const SizedBox(
                    height: 8,
                  ),
                  invoiceDeliveryOrderWidget(
                      'Delivery Orders :',
                      viewModel.orderData != null
                          ? viewModel.orderData.deliveries != null &&
                                  viewModel.orderData.deliveries!.isNotEmpty
                              ? '${viewModel.orderData.deliveries![0].deliveryNumber}'
                              : 'N/A'
                          : 'N/A',
                      viewModel.orderData.deliveries != null &&
                              viewModel.orderData.deliveries!.isNotEmpty
                          ? viewModel.orderData.deliveries![0].pdfUrl!
                          : ""),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          );
  }

  // Return Invoice DeliveryOrder Download Common Widget
  Widget invoiceDeliveryOrderWidget(String title, String data, String pdfUrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
              text: title,
              style: TextStyle(
                fontFamily: 'Raleway',
                letterSpacing: -0.33,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                color: const Color(0xff858D93),
                fontSize: Globlas.deviceType == "phone" ? 13 : 23,
              ),
              children: [
                TextSpan(
                    text: " $data",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.33,
                        color: const Color(0xff1D1B1E)))
              ]),
        ),
        IconButton(
            padding: const EdgeInsets.all(0),
            constraints: const BoxConstraints(),
            onPressed: () async {
              if (pdfUrl != null && pdfUrl.isNotEmpty) {
                DownloadService downloadService = MobileDownloadService();
                await downloadService.download(url: pdfUrl, isShare: false);
              }
            },
            icon: Icon(
              PowaGroupIcon.download,
              size: 18.h,
              color: Color(0xff000000),
            ))
      ],
    );
  }

  // Return Address Widget
  Widget addressWidget(String title, String address) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: Globlas.deviceType == "phone" ? 13 : 23,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.33,
              color: const Color(0xff858D93)),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          address,
          style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: Globlas.deviceType == "phone" ? 14 : 24,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.33,
              color: const Color(0xff1B1D1E)),
        ),
      ],
    );
  }

  // Return Order Details Widget
  Widget orderDetailsWidget(SalesOrderDetailViewModel viewModel) {
    return viewModel.isBusy || viewModel.orderData.id == null
        // &&
        // viewModel.orderList.id == null &&
        // viewModel.orderList.lines == null &&
        // viewModel.orderList.lines![0] == null
        ? ShimmerLoading(
            isLoading: true,
            child: Container(
              width: double.infinity,
              height: 220.h,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10)),
            ))
        : Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    'Order Details',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: Globlas.deviceType == "phone" ? 16 : 26,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.33,
                        color: const Color(0xff1B1D1E)),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      (viewModel.orderData != null &&
                              viewModel.orderData.lines != null)
                          ? '${(viewModel.orderData.lines!.length - 1).toString()} Item'
                          : 'N/A',
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.33,
                          color: const Color(0xff36393C)),
                    ),
                    Text(
                      (viewModel.orderData != null &&
                              viewModel.orderData.total != null)
                          ? '\$${viewModel.orderData.total!.toStringAsFixed(2)}'
                          : 'N/A',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: Globlas.deviceType == "phone" ? 18 : 28,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.33,
                          color: const Color(0xff33A3E4)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: viewModel.orderData != null &&
                            viewModel.orderData.lines != null &&
                            viewModel.orderData.lines != null
                        ? viewModel.orderData.lines!.length
                        : 2,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return productItem(viewModel, index);
                    })
              ],
            ),
          );
  }

  // Return Product Item View
  Widget productItem(SalesOrderDetailViewModel viewModel, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(right: 16.sp),
              child: Text(
                viewModel.orderData != null &&
                        viewModel.orderData.lines != null &&
                        viewModel.orderData.lines![index] != null &&
                        viewModel.orderData.lines![index] != null &&
                        viewModel.orderData.lines![index].description != null
                    ? '${viewModel.orderData.lines![index].description.toString()}'
                    : '',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -0.33,
                    color: const Color(0xff36393C)),
              ),
            ),
          ),
          Text(
            (viewModel.orderData != null &&
                    viewModel.orderData.lines![index].total != null)
                ? '\$${viewModel.orderData.lines![index].total!.toStringAsFixed(2)}'
                : '\$30.00',
            textAlign: TextAlign.start,
            style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.33,
                color: const Color(0xff000000)),
          )
        ],
      ),
    );
  }

  // Return Price Details Widget
  Widget priceDetailWidget(SalesOrderDetailViewModel viewModel) {
    return viewModel.isBusy || viewModel.orderData.id == null
        ? ShimmerLoading(
            isLoading: true,
            child: Container(
              width: double.infinity,
              height: 220.h,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10)),
            ))
        : Container(
            padding:
                const EdgeInsets.only(top: 16, bottom: 16, left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    'Price Details',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: Globlas.deviceType == "phone" ? 16 : 26,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.33,
                        color: const Color(0xff1B1D1E)),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                priceRowWidget(
                    'Item Total',
                    (viewModel.orderData != null &&
                            viewModel.orderData.subtotalExDelivery != null)
                        ? '\$${viewModel.orderData.subtotalExDelivery!.toStringAsFixed(2)}'
                        : '\$00.00'),
                const SizedBox(
                  height: 16,
                ),
                priceRowWidget(
                    'Delivery Charges',
                    (viewModel.orderData != null &&
                            viewModel.orderData.deliveryEx != null)
                        ? '\$${viewModel.orderData.deliveryEx!.toStringAsFixed(2)}'
                        : '\$02.00'),
                const SizedBox(
                  height: 16,
                ),
                priceRowWidget(
                    'Excluding GST',
                    (viewModel.orderData != null &&
                            viewModel.orderData.subtotal != null)
                        ? '\$${viewModel.orderData.subtotal!.toStringAsFixed(2)}'
                        : '\$150'),
                const SizedBox(
                  height: 16,
                ),
                priceRowWidget(
                    'GST',
                    (viewModel.orderData != null &&
                            viewModel.orderData.tax != null)
                        ? '\$${viewModel.orderData.tax!.toStringAsFixed(2)}'
                        : '\$00.00'),
                const SizedBox(
                  height: 16,
                ),
                const Divider(
                  height: 1,
                  color: Color(0xff858D93),
                ),
                const SizedBox(
                  height: 16,
                ),
                priceRowWidget(
                  'Total Pay',
                  (viewModel.orderData != null &&
                          viewModel.orderData.total != null)
                      ? '\$${viewModel.orderData.total!.toStringAsFixed(2)}'
                      : '\$152',
                ),
              ],
            ),
          );
  }

  // Return Price Row Widget
  Widget priceRowWidget(String name, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            name,
            style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.33,
                color: const Color(0xff000000)),
          ),
        ),
        Expanded(
          child: Text(
            price,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: name == "Total Pay"
                    ? Globlas.deviceType == "phone"
                        ? 13
                        : 28
                    : Globlas.deviceType == "phone"
                        ? 14
                        : 24,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.33,
                color: name == ""
                    ? const Color(0xff33A3E4)
                    : const Color(0xff000000)),
          ),
        )
      ],
    );
  }

  // Return Comment Section Widget
  // Widget commentSectionWidget(SalesOrderDetailViewModel viewModel) {
  //   return viewModel.isBusy || viewModel.orderData.id == null
  //       ? ShimmerLoading(
  //           isLoading: true,
  //           child: Container(
  //             width: double.infinity,
  //             height: 220.h,
  //             decoration: BoxDecoration(
  //                 color: Colors.grey[100],
  //                 borderRadius: BorderRadius.circular(10)),
  //           ))
  //       : Container(
  //           padding: const EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //             color: Colors.white,
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 16),
  //                 child: Text(
  //                   'History',
  //                   style: TextStyle(
  //                       fontFamily: 'Raleway',
  //                       fontSize: Globlas.deviceType == "phone" ? 16 : 26,
  //                       fontStyle: FontStyle.normal,
  //                       fontWeight: FontWeight.w700,
  //                       letterSpacing: -0.33,
  //                       color: const Color(0xff1B1D1E)),
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 16,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 mainAxisSize: MainAxisSize.max,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Container(
  //                     width: 32.h,
  //                     height: 32.h,
  //                     alignment: Alignment.center,
  //                     decoration: const BoxDecoration(
  //                         shape: BoxShape.circle, color: Color(0xffF2F2F2)),
  //                     child: Text(
  //                       'A',
  //                       style: TextStyle(
  //                           fontFamily: 'Inter-Medium',
  //                           fontSize: Globlas.deviceType == "phone" ? 14 : 24,
  //                           fontStyle: FontStyle.normal,
  //                           fontWeight: FontWeight.w500,
  //                           letterSpacing: -0.33,
  //                           color: const Color(0xff8B8B8B)),
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     width: 10,
  //                   ),
  //                   Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         'Rosie Elford',
  //                         style: TextStyle(
  //                             fontFamily: 'Inter-Medium',
  //                             fontSize: Globlas.deviceType == "phone" ? 14 : 24,
  //                             fontStyle: FontStyle.normal,
  //                             fontWeight: FontWeight.w500,
  //                             letterSpacing: -0.33,
  //                             color: const Color(0xff000000)),
  //                       ),
  //                       const SizedBox(
  //                         height: 2,
  //                       ),
  //                       Text(
  //                         'Published on August 11th 2022, 11:00 PM',
  //                         style: TextStyle(
  //                             fontFamily: 'Inter-Regular',
  //                             fontSize: Globlas.deviceType == "phone" ? 12 : 22,
  //                             fontStyle: FontStyle.normal,
  //                             fontWeight: FontWeight.w400,
  //                             letterSpacing: -0.33,
  //                             color: const Color(0xff858D93)),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(
  //                 height: 16,
  //               ),
  //               Text(
  //                 'Lorem ipsum is a placeholder text commonly',
  //                 style: TextStyle(
  //                     fontFamily: 'Raleway',
  //                     fontSize: Globlas.deviceType == "phone" ? 14 : 24,
  //                     fontStyle: FontStyle.normal,
  //                     fontWeight: FontWeight.w300,
  //                     letterSpacing: -0.33,
  //                     color: const Color(0xff1B1D1E)),
  //               ),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               const Divider(
  //                 height: 1,
  //                 color: Color(0xff858D93),
  //               ),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               TextField(
  //                 textAlignVertical: TextAlignVertical.top,
  //                 maxLines: 2,
  //                 decoration: InputDecoration(
  //                     contentPadding: const EdgeInsets.symmetric(
  //                         vertical: 10, horizontal: 12),
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(6),
  //                       borderSide: BorderSide(
  //                         width: 1,
  //                         color: const Color(0xff858D93).withOpacity(0.5),
  //                       ),
  //                     ),
  //                     disabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(6),
  //                       borderSide: BorderSide(
  //                         width: 1,
  //                         color: const Color(0xff858D93).withOpacity(0.5),
  //                       ),
  //                     ),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(6),
  //                       borderSide: BorderSide(
  //                         width: 1,
  //                         color: const Color(0xff858D93).withOpacity(0.5),
  //                       ),
  //                     ),
  //                     enabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(6),
  //                       borderSide: BorderSide(
  //                         width: 1,
  //                         color: const Color(0xff858D93).withOpacity(0.5),
  //                       ),
  //                     ),
  //                     hintText: 'Write a massage..',
  //                     hintStyle: TextStyle(
  //                         fontFamily: 'Inter-Regular',
  //                         fontSize: Globlas.deviceType == "phone" ? 14 : 24,
  //                         fontStyle: FontStyle.normal,
  //                         fontWeight: FontWeight.w400,
  //                         letterSpacing: -0.33,
  //                         color: const Color(0xff858D93))),
  //               ),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               ButtonWidget(
  //                 isBusy: false,
  //                 buttonTitle: 'Send',
  //                 containerWidth: 130.0.h,
  //                 containerHeigth: 38.h,
  //               ),
  //               const SizedBox(
  //                 height: 12,
  //               ),
  //             ],
  //           ),
  //         );
  // }

  Widget commentSectionWidget(SalesOrderDetailViewModel viewModel, context) {
    return Container(
      // padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                viewModel.isBusy || productId == null
                    ? ShimmerLoading(
                        isLoading: true,
                        child: Container(
                          width: 60.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[100],
                          ),
                        ))
                    : Text(
                        'History',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: Globlas.deviceType == "phone" ? 16 : 26,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.33,
                            color: const Color(0xff1B1D1E)),
                      ),
                viewModel.userReviews.length == 3
                    ? Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: viewModel.isBusy || productId == null
                                ? ShimmerLoading(
                                    isLoading: true,
                                    child: Container(
                                      width: 60.w,
                                      height: 10.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[100],
                                      ),
                                    ))
                                : InkWell(
                                    onTap: () {
                                      viewModel.onSeeAllClick(
                                          productId, context);
                                    },
                                    child: Text(
                                      'See All',
                                      style: TextStyle(
                                          fontFamily: 'Raleway',
                                          fontSize:
                                              Globlas.deviceType == "phone"
                                                  ? 12
                                                  : 22,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: -0.33,
                                          color: const Color(0xff36393C)),
                                    ),
                                  ),
                          ),
                          InkWell(
                              onTap: () {
                                viewModel.onSeeAllClick(productId, context);
                              },
                              child: doubleIcon())
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ListView.separated(
              separatorBuilder: (context, int) {
                return const Divider(
                  height: 1,
                  color: Color(0xff858D93),
                );
              },
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: viewModel.isBusy || productId != null
                  ? viewModel.userReviews.length
                  : 0,
              itemBuilder: (BuildContext context, int index) {
                return userComments(viewModel, index, viewModel.userReviews);
              }),
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Divider(
              height: 1,
              color: Color(0xff858D93),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              'Title',
              style: TextStyle(
                  fontFamily: 'Inter-Medium',
                  fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.33,
                  color: const Color(0xff000000)),
            ),
          ),
          Form(
            key: viewModel.formKey,
            // autovalidateMode: AutovalidateMode.onUserInteraction,

            autovalidateMode: !viewModel.isSet
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                children: [
                  TextFormField(
                    focusNode: viewModel.titleNode,

                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    // onChanged: ((value) => viewModel.title = value),
                    controller: viewModel.titleController,
                    validator: (value) => Validation.fieldEmpty(value!),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Raleway',
                        fontSize: 12.0.sp),
                    decoration: InputDecoration(
                      hintText: 'Write a title..',
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 4.sp,
                          vertical: Globlas.deviceType == 'phone' ? 8 : 12),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFD60505),
                        ),
                        //borderRadius: BorderRadius.circular(5),
                      ),
                      hintStyle: TextStyle(
                          color: const Color(0xff858D93),
                          fontWeight: FontWeight.w400,
                          fontSize: Globlas.deviceType == 'phone' ? 15 : 25),
                    ),
                    onSaved: (value) => viewModel.title = value!,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 10),
                    child: TextFormField(
                      focusNode: viewModel.messageNode,
                      controller: viewModel.msgController,
                      validator: (value) => Validation.fieldEmpty(value!),
                      textAlignVertical: TextAlignVertical.top,
                      maxLines: 2,
                      // onChanged: ((value) => viewModel.msg = value),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            width: 1,
                            color: const Color(0xff858D93).withOpacity(0.5),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            width: 1,
                            color: const Color(0xff858D93).withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            width: 1,
                            color: const Color(0xff858D93).withOpacity(0.5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            width: 1,
                            color: const Color(0xff858D93).withOpacity(0.5),
                          ),
                        ),
                        hintText: 'Write a message..',
                        hintStyle: TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.33,
                            color: const Color(0xff858D93)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16),
            child: InkWell(
              child: ButtonWidget(
                isBusy: viewModel.isBusy,
                buttonTitle: 'Send',
                containerWidth: 130.0.h,
                containerHeigth: 38.h,
              ),
              onTap: () async {
                String loginToken = await AppUtil.getLoginToken();

                if (loginToken != null && loginToken.isNotEmpty) {
                  FocusScope.of(context).unfocus();
                  new TextEditingController().clear();

                  viewModel.onSendButtonClick(productId);
                } else {
                  AppUtil.showLoginMessageDialog(AppUtil.getContext(),
                      'Please Sign In/Register to submit review for the product');
                }
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget userComments(viewModel, int index, List<Message> userReviews) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              viewModel.isBusy
                  ? ShimmerLoading(
                      isLoading: true,
                      child: Container(
                        width: 32.h,
                        height: 32.h,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xffF2F2F2)),
                      ))
                  : Container(
                      width: 32.h,
                      height: 32.h,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xffF2F2F2)),
                      child: Text(
                        userReviews[index].id != null &&
                                userReviews[index].id == null
                            ? ''
                            : "Title",
                        style: TextStyle(
                            fontFamily: 'Inter-Medium',
                            fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.33,
                            color: const Color(0xff8B8B8B)),
                      ),
                    ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    viewModel.isBusy
                        ? ShimmerLoading(
                            isLoading: true,
                            child: Container(
                              width: 170.w,
                              height: 12.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                            ))
                        : Row(
                            children: [
                              Text(
                                userReviews[index].id! == null
                                    ? ' '
                                    : userReviews[index].id.toString(),
                                style: TextStyle(
                                    fontFamily: 'Inter-Medium',
                                    fontSize:
                                        Globlas.deviceType == "phone" ? 14 : 24,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.33,
                                    color: const Color(0xff000000)),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                height:
                                    Globlas.deviceType == "phone" ? 18.h : 18.h,
                                width:
                                    Globlas.deviceType == "phone" ? 28.w : 18.w,
                                child: Row(
                                  children: [
                                    RatingBar.builder(
                                      initialRating: 1,
                                      tapOnlyMode: false,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemSize: Globlas.deviceType == "phone"
                                          ? 12
                                          : 16,
                                      itemCount: 1,
                                      itemPadding: const EdgeInsets.all(0.0),
                                      itemBuilder: (context, index) {
                                        return const Icon(
                                          Icons.star,
                                          color: Colors.white,
                                        );
                                      },
                                      onRatingUpdate: (rating) {},
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                    const SizedBox(
                      height: 2,
                    ),
                    viewModel.isBusy
                        ? ShimmerLoading(
                            isLoading: true,
                            child: Container(
                              width: 170.w,
                              height: 12.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                            ))
                        : Text(
                            AppUtil.getDate2(userReviews[index].datetime != null
                                ? userReviews[index].datetime.toString()
                                : ''),
                            style: TextStyle(
                                fontFamily: 'Inter-Regular',
                                fontSize:
                                    Globlas.deviceType == "phone" ? 12 : 22,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.33,
                                color: const Color(0xff858D93)),
                          ),
                    const SizedBox(
                      height: 2,
                    ),
                    viewModel.isBusy
                        ? ShimmerLoading(
                            isLoading: true,
                            child: Container(
                              width: 170.w,
                              height: 12.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                            ))
                        : Html(
                            data: userReviews[index].note != null
                                ? userReviews[index].note.toString()
                                : '',
                            shrinkWrap: true,
                            extensions: [
                              TagExtension(
                                tagsToExtend: {"flutter"},
                                child: const FlutterLogo(),
                              ),
                            ],
                            // tagsList: Html.tags..addAll(["flutter"]),
                            style: {
                              "flutter": Style(
                                  fontFamily: 'Raleway',
                                  fontSize: Globlas.deviceType == "phone"
                                      ? FontSize.medium
                                      : FontSize.xxLarge,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: -0.33,
                                  color: const Color(0xff000000))
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bodyWidget(SalesOrderDetailViewModel viewModel, context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding:
          EdgeInsets.only(left: 16.h, right: 16.h, top: 16.h, bottom: 60.h),
      children: [
        detailWidget(viewModel, context),
        const SizedBox(
          height: 10,
        ),
        orderDetailsWidget(viewModel),
        const SizedBox(
          height: 10,
        ),
        priceDetailWidget(viewModel),
        const SizedBox(
          height: 10,
        ),
        commentSectionWidget(viewModel, context),
      ],
    );
  }
}
