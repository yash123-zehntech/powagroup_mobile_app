import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/helper_widget/double_icon_widget.dart';
import 'package:powagroup/helper_widget/network_error%20widget.dart';
import 'package:powagroup/helper_widget/share_down_popUp.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/services/download_service.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/review_model.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/quotation_detail_view_model.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/quotation_review_model.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/response_model/quotation_detail_responsemodel.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:powagroup/util/validator.dart';
import 'package:readmore/readmore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:stacked/stacked.dart';

import '../home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import '../product_detail_module.dart/product_detail_view_model.dart';

class QuotationDetialView extends StatelessWidget {
  int? productId;
  ProductData? productObj;
  QuotationDetialView({Key? key, this.productId, this.productObj})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuotationDetailViewModel>.reactive(
      viewModelBuilder: () => QuotationDetailViewModel(),
      onViewModelReady: (viewModel) async {
        viewModel.showPricing = await AppUtil.getShowPricing();
        bool isConnected = await AppUtil.checkNetwork();
        if (isConnected != null && isConnected) {
          viewModel.getQuotationDetails(
            true,
            productId,
          );

          if (productId != null) {
            viewModel.getTopComments(productId, viewModel.itemPerPage, true);
          }
        }
        // viewModel.getQuotationDetails(productId);
      },
      builder: (context, viewModel, child) => Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarWidget(
                title: 'Quotations',
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
                actionIcon:
                    //     //=============================To do =========================
                    //     InkWell(
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(right: 20.0),
                    //     child: Icon(
                    //       // Icons.download,
                    //       Icons.share,
                    //       size: 24.h,
                    //       color: const Color(0xff36393C),
                    //     ),
                    //   ),
                    //   onTap: () async {

                    //     DownloadService downloadService = MobileDownloadService();
                    //     // _onShare method:

                    //     await downloadService.shareFile9(
                    //         url: viewModel.orderData.pdfUrl!);
                    //   },
                    // ),

                    PopupWidgetForShare(
                  viewModel: viewModel,
                )),
          ),
          backgroundColor: const Color(0xffEFF1F2),
          body: !viewModel.isAPIError
              ? OfflineBuilder(
                  connectivityBuilder: (BuildContext context,
                      ConnectivityResult connectivity, Widget child) {
                    final bool connected =
                        connectivity != ConnectivityResult.none;
                    if (connected) {
                      if (!viewModel.isBusy && viewModel.orderData.id != null) {
                        return bodyWidget(viewModel, context);
                      } else {
                        if (!viewModel.isAlreadyCalled) {
                          viewModel.getQuotationDetails(false, productId);

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
                      if (viewModel.quotationOrderDetailsList.isNotEmpty &&
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
                  content: 'Quotation Details Not Found!!',
                  subContant: 'No data, Please try again later.',
                  icon: 'assets/icon/network_error.png',
                  viewModel: viewModel,
                )),
    );
  }

  // Return Sales Order Details Widget
  Widget detailWidget(QuotationDetailViewModel viewModel) {
    return viewModel.isBusy || viewModel.orderData.id == null
        ? Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ShimmerLoading(
                isLoading: true,
                child: Container(
                  width: double.infinity,
                  height: 200.h,
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
                      title: RichText(
                        text: TextSpan(
                            text: 'Quotation: ',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              letterSpacing: -0.33,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              color: const Color(0xff858D93),
                              fontSize: Globlas.deviceType == "phone" ? 13 : 23,
                            ),
                            children: [
                              TextSpan(
                                  text: viewModel.orderData != null
                                      ? '#${viewModel.orderData.name == null ? '' : viewModel.orderData.name}'
                                      : "",
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: Globlas.deviceType == "phone"
                                          ? 14
                                          : 24,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.33,
                                      color: const Color(0xff1D1B1E)))
                            ]),
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
                    ),
                  ),
                  viewModel.isBusy
                      ? Container()
                      : addressWidget(
                          'Invoicing  Address',
                          viewModel.orderData != null
                              ? '${viewModel.orderData.invoiceAddress == null ? '' : '${viewModel.orderData.invoiceAddress!.street1} ${viewModel.orderData.invoiceAddress!.city}${viewModel.orderData.invoiceAddress!.state} ${viewModel.orderData.invoiceAddress!.country}'}'
                              : 'Lorem ipsum is a placeholder text commonly'),
                  const SizedBox(
                    height: 12,
                  ),
                  viewModel.isBusy
                      ? Container()
                      : addressWidget(
                          'Shipping Address',
                          viewModel.orderData != null
                              ? '${viewModel.orderData.shippingAddress == null ? '' : '${viewModel.orderData.shippingAddress!.street1} ${viewModel.orderData.shippingAddress!.city}${viewModel.orderData.shippingAddress!.state} ${viewModel.orderData.shippingAddress!.country}'}'
                              : 'Lorem ipsum is a placeholder text commonly'),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          );
  }

  // Return Invoice DeliveryOrder Download Common Widget
  Widget invoiceDeliveryOrderWidget(String title, String data) {
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
            onPressed: () {},
            icon: const Icon(
              Icons.download,
              size: 24,
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
  Widget orderDetailsWidget(QuotationDetailViewModel viewModel) {
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
                              viewModel.orderData.subtotal != null)
                          ? '\$${viewModel.orderData.subtotal!.toStringAsFixed(2)}'
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
  Widget productItem(QuotationDetailViewModel viewModel, int index) {
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
                        viewModel.orderData.lines != null &&
                        viewModel.orderData.lines![0] != null &&
                        viewModel.orderData.lines![0].description != null
                    ? '${viewModel.orderData.lines![index].description.toString()}'
                    : 'N/A',
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
          viewModel.showPricing
              ? Text(
                  (viewModel.orderData != null &&
                          viewModel.orderData.lines![index].subtotal != null)
                      ? '\$${viewModel.orderData.lines![index].subtotal!.toStringAsFixed(2)}'
                      : 'N/A',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.33,
                      color: const Color(0xff000000)),
                )
              : Container(
                  height: 0,
                  width: 0,
                )
        ],
      ),
    );
  }

  // Return Price Details Widget
  Widget priceDetailWidget(QuotationDetailViewModel viewModel) {
    return viewModel.isBusy || viewModel.orderData.id == null
        ? ShimmerLoading(
            isLoading: true,
            child: Container(
              width: double.infinity,
              height: 200.h,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleWidget(
                          'Item Total',
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        titleWidget('Delivery Charges'),
                        const SizedBox(
                          height: 16,
                        ),
                        titleWidget('Excluding GST'),
                        const SizedBox(
                          height: 16,
                        ),
                        titleWidget('GST'),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        priceWidget((viewModel.orderData != null &&
                                viewModel.orderData.subtotal != null)
                            ? '\$${viewModel.orderData.subtotal!.toStringAsFixed(2)}'
                            : '\$150'),
                        const SizedBox(
                          height: 16,
                        ),
                        priceWidget((viewModel.orderData != null &&
                                viewModel.orderData.deliveryEx != null)
                            ? '\$${viewModel.orderData.deliveryEx!.toStringAsFixed(2)}'
                            : '\$02.00'),
                        const SizedBox(
                          height: 16,
                        ),
                        priceWidget((viewModel.orderData != null &&
                                viewModel.orderData.subtotalExDelivery != null)
                            ? '\$${viewModel.orderData.subtotalExDelivery!.toStringAsFixed(2)}'
                            : '\$00.00'),
                        const SizedBox(
                          height: 16,
                        ),
                        priceWidget((viewModel.orderData != null &&
                                viewModel.orderData.tax != null)
                            ? '\$${viewModel.orderData.tax!.toStringAsFixed(2)}'
                            : '\$00.00'),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ],
                ),
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
                        : '\$152'),
              ],
            ),
          );
  }

  // Return Price Widget
  Widget priceWidget(String price) {
    return Text(
      price,
      textAlign: TextAlign.start,
      style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: Globlas.deviceType == "phone" ? 14 : 24,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.33,
          color: const Color(0xff000000)),
    );
  }

  // Return Title Widget
  Widget titleWidget(String title) {
    return Text(
      title,
      style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: Globlas.deviceType == "phone" ? 14 : 24,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.33,
          color: const Color(0xff000000)),
    );
  }

  // Return Price Row Widget
  Widget priceRowWidget(String name, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: Globlas.deviceType == "phone" ? 14 : 24,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.33,
              color: const Color(0xff000000)),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            price,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: name == "Total Pay"
                    ? Globlas.deviceType == "phone"
                        ? 18
                        : 28
                    : Globlas.deviceType == "phone"
                        ? 14
                        : 24,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.33,
                color: name == "Total Pay"
                    ? const Color(0xff33A3E4)
                    : const Color(0xff000000)),
          ),
        )
      ],
    );
  }

  // Return Comment Section Widget
  Widget commentSectionWidget(QuotationDetailViewModel viewModel, context) {
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
                viewModel.isBusy
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
                            child: viewModel.isBusy
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
          // Padding(
          //   padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          //   child: RatingBar(
          //       initialRating: viewModel.rate.toDouble(),
          //       itemSize: 20,
          //       minRating: viewModel.rate.toDouble(),
          //       direction: Axis.horizontal,
          //       allowHalfRating: true,
          //       itemCount: 5,
          //       ratingWidget: RatingWidget(
          //           full: const Icon(Icons.star, color: Color(0xffFD521C)),
          //           half: const Icon(
          //             Icons.star_half,
          //             color: Color(0xffFD521C),
          //           ),
          //           empty: const Icon(
          //             Icons.star_outline,
          //             color: Colors.grey,
          //           )),
          //       onRatingUpdate: (rating) {
          //         // setState(() {
          //         //   viewModel.rate = rating.toInt();

          //         //   viewModel.notifyListeners();
          //         // });
          //       }),

          //   // RatingBar.builder(
          //   //   initialRating: 0,

          //   //   tapOnlyMode: true,
          //   //   minRating: 0,
          //   //   direction: Axis.horizontal,
          //   //   allowHalfRating: true,
          //   //   itemSize: 20,
          //   //   itemCount: 5,
          //   //   itemPadding: const EdgeInsets.all(0.0),
          //   //   itemBuilder: (context, index) {
          //   //     return Icon(
          //   //       Icons.star,
          //   //       color: Color(0xffFD521C),
          //   //     );
          //   //   },
          //   //   onRatingUpdate: (rating) {
          //   //     viewModel.rate = rating.toInt();

          //   //     viewModel.notifyListeners();
          //   //   },
          //   // ),
          // ),
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
      padding: const EdgeInsets.all(16.0),
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
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  viewModel.isBusy
                      ? ShimmerLoading(
                          isLoading: true,
                          child: Container(
                            width: 32.h,
                            height: 32.h,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffF2F2F2)),
                          ))
                      : Container(
                          width: 32.w,
                          height: 32.h,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xffF2F2F2)),
                          child: Text(
                            // userReviews[index].id != null &&
                            //         userReviews[index].id == null
                            //     ? ''
                            //     :
                            "Title",
                            style: TextStyle(
                                fontFamily: 'Inter-Medium',
                                fontSize:
                                    Globlas.deviceType == "phone" ? 14 : 20,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.33,
                                color: const Color(0xff8B8B8B)),
                          ),
                        ),
                ],
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
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(6),
                                //   color: userReviews.isNotEmpty &&
                                //           userReviews[index].rating! > 0
                                //       ? userReviews[index].rating! <= 2
                                //           ? const Color(0xffD60505)
                                //           : userReviews[index].rating! == 3
                                //               ? const Color(0xffFF9900)
                                //               : const Color(0xff407937)
                                //       : Colors.white,
                                // ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 1),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, right: 0, top: 0),
                                      child: RatingBar.builder(
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
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: ShimmerLoading(
                                isLoading: true,
                                child: Container(
                                  width: 170.w,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[100],
                                  ),
                                )),
                          )
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
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: ShimmerLoading(
                                isLoading: true,
                                child: Container(
                                  width: 170.w,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[100],
                                  ),
                                )),
                          )
                        : Html(
                            data: userReviews[index].note != null
                                ? userReviews[index].note.toString()
                                : '',
                            shrinkWrap: true,
                            extensions: [
                              TagExtension(
                                tagsToExtend: {"flutter"},
                                // child: Container()
                                child: const FlutterLogo(),
                              ),
                            ],
                            //tagsList: Html.tags..addAll(["flutter"]),
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

  // Return Comment Section Widget
//   Widget commentSectionWidget(QuotationDetailViewModel viewModel, context) {
//     return viewModel.isBusy || viewModel.orderData.id == null
//         ? ShimmerLoading(
//             isLoading: true,
//             child: Container(
//               width: double.infinity,
//               height: 200.h,
//               decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(10)),
//             ))
//         : Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.white,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'History',
//                       style: TextStyle(
//                           fontFamily: 'Raleway',
//                           fontSize: Globlas.deviceType == "phone" ? 16 : 26,
//                           fontStyle: FontStyle.normal,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: -0.33,
//                           color: const Color(0xff1B1D1E)),
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           'See All',
//                           style: TextStyle(
//                               fontFamily: 'Raleway',
//                               fontSize: Globlas.deviceType == "phone" ? 12 : 22,
//                               fontStyle: FontStyle.normal,
//                               fontWeight: FontWeight.w300,
//                               letterSpacing: -0.33,
//                               color: const Color(0xff36393C)),
//                         ),
//                         SizedBox(
//                           width: 6,
//                         ),
//                         doubleIcon(),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 viewModel.isBusy || viewModel.orderData.id == null
//                     ? ShimmerLoading(
//                         isLoading: true,
//                         child: Container(
//                           width: double.infinity,
//                           height: 40.h,
//                           decoration: BoxDecoration(
//                               color: Colors.grey[100],
//                               borderRadius: BorderRadius.circular(10)),
//                         ))
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.max,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 32.h,
//                             height: 32.h,
//                             alignment: Alignment.center,
//                             decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(0xffF2F2F2)),
//                             child: Text(
//                               'A',
//                               style: TextStyle(
//                                   fontFamily: 'Inter-Medium',
//                                   fontSize:
//                                       Globlas.deviceType == "phone" ? 14 : 24,
//                                   fontStyle: FontStyle.normal,
//                                   fontWeight: FontWeight.w500,
//                                   letterSpacing: -0.33,
//                                   color: const Color(0xff8B8B8B)),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               viewModel.isBusy || viewModel.orderData.id == null
//                                   ? ShimmerLoading(
//                                       isLoading: true,
//                                       child: Container(
//                                         width: double.infinity,
//                                         height: 40.h,
//                                         decoration: BoxDecoration(
//                                             color: Colors.grey[100],
//                                             borderRadius:
//                                                 BorderRadius.circular(10)),
//                                       ))
//                                   : Text(
//                                       'Rosie Elford',
//                                       style: TextStyle(
//                                           fontFamily: 'Inter-Medium',
//                                           fontSize:
//                                               Globlas.deviceType == "phone"
//                                                   ? 14
//                                                   : 24,
//                                           fontStyle: FontStyle.normal,
//                                           fontWeight: FontWeight.w500,
//                                           letterSpacing: -0.33,
//                                           color: const Color(0xff000000)),
//                                     ),
//                               const SizedBox(
//                                 height: 2,
//                               ),
//                               Text(
//                                 'Published on August 11th 2022, 11:00 PM',
//                                 style: TextStyle(
//                                     fontFamily: 'Inter-Regular',
//                                     fontSize:
//                                         Globlas.deviceType == "phone" ? 12 : 22,
//                                     fontStyle: FontStyle.normal,
//                                     fontWeight: FontWeight.w400,
//                                     letterSpacing: -0.33,
//                                     color: const Color(0xff858D93)),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                 const SizedBox(
//                   height: 16,
//                 ),

//                 Form(
//                   key: viewModel.formKey,
//                   // autovalidateMode: AutovalidateMode.onUserInteraction,

//                   autovalidateMode: !viewModel.isSet
//                       ? AutovalidateMode.onUserInteraction
//                       : AutovalidateMode.disabled,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 16, right: 16),
//                     child: Column(
//                       children: [
//                         TextFormField(
//                           focusNode: viewModel.titleNode,

//                           textInputAction: TextInputAction.next,
//                           onFieldSubmitted: (_) =>
//                               FocusScope.of(context).nextFocus(),
//                           // onChanged: ((value) => viewModel.title = value),
//                           controller: viewModel.titleController,
//                           validator: (value) => Validation.fieldEmpty(value!),
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.w400,
//                               fontFamily: 'Raleway',
//                               fontSize: 12.0.sp),
//                           decoration: InputDecoration(
//                             hintText: 'Write a title..',
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 4.sp,
//                                 vertical:
//                                     Globlas.deviceType == 'phone' ? 8 : 12),
//                             focusedBorder: const UnderlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Color(0xFFD60505),
//                               ),
//                               //borderRadius: BorderRadius.circular(5),
//                             ),
//                             hintStyle: TextStyle(
//                                 color: const Color(0xff858D93),
//                                 fontWeight: FontWeight.w400,
//                                 fontSize:
//                                     Globlas.deviceType == 'phone' ? 15 : 25),
//                           ),
//                           onSaved: (value) => viewModel.title = value!,
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               left: 16, right: 16, top: 10),
//                           child: TextFormField(
//                             focusNode: viewModel.messageNode,
//                             controller: viewModel.msgController,
//                             validator: (value) => Validation.fieldEmpty(value!),
//                             textAlignVertical: TextAlignVertical.top,
//                             maxLines: 2,
//                             // onChanged: ((value) => viewModel.msg = value),
//                             decoration: InputDecoration(
//                               contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 10, horizontal: 12),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(6),
//                                 borderSide: BorderSide(
//                                   width: 1,
//                                   color:
//                                       const Color(0xff858D93).withOpacity(0.5),
//                                 ),
//                               ),
//                               disabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(6),
//                                 borderSide: BorderSide(
//                                   width: 1,
//                                   color:
//                                       const Color(0xff858D93).withOpacity(0.5),
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(6),
//                                 borderSide: BorderSide(
//                                   width: 1,
//                                   color:
//                                       const Color(0xff858D93).withOpacity(0.5),
//                                 ),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(6),
//                                 borderSide: BorderSide(
//                                   width: 1,
//                                   color:
//                                       const Color(0xff858D93).withOpacity(0.5),
//                                 ),
//                               ),
//                               hintText: 'Write a message..',
//                               hintStyle: TextStyle(
//                                   fontFamily: 'Inter-Regular',
//                                   fontSize:
//                                       Globlas.deviceType == "phone" ? 14 : 24,
//                                   fontStyle: FontStyle.normal,
//                                   fontWeight: FontWeight.w400,
//                                   letterSpacing: -0.33,
//                                   color: const Color(0xff858D93)),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Text(
//                 //   'Lorem ipsum is a placeholder text commonly',
//                 //   style: TextStyle(
//                 //       fontFamily: 'Raleway',
//                 //       fontSize: Globlas.deviceType == "phone" ? 14 : 24,
//                 //       fontStyle: FontStyle.normal,
//                 //       fontWeight: FontWeight.w300,
//                 //       letterSpacing: -0.33,
//                 //       color: const Color(0xff1B1D1E)),
//                 // ),
//                 // const SizedBox(
//                 //   height: 20,
//                 // ),
//                 // const Divider(
//                 //   height: 1,
//                 //   color: Color(0xff858D93),
//                 // ),
//                 // const SizedBox(
//                 //   height: 20,
//                 // ),
//                 // TextField(
//                 //   textAlignVertical: TextAlignVertical.top,
//                 //   maxLines: 2,
//                 //   decoration: InputDecoration(
//                 //       contentPadding: const EdgeInsets.symmetric(
//                 //           vertical: 10, horizontal: 12),
//                 //       border: OutlineInputBorder(
//                 //         borderRadius: BorderRadius.circular(6),
//                 //         borderSide: BorderSide(
//                 //           width: 1,
//                 //           color: const Color(0xff858D93).withOpacity(0.5),
//                 //         ),
//                 //       ),
//                 //       disabledBorder: OutlineInputBorder(
//                 //         borderRadius: BorderRadius.circular(6),
//                 //         borderSide: BorderSide(
//                 //           width: 1,
//                 //           color: const Color(0xff858D93).withOpacity(0.5),
//                 //         ),
//                 //       ),
//                 //       focusedBorder: OutlineInputBorder(
//                 //         borderRadius: BorderRadius.circular(6),
//                 //         borderSide: BorderSide(
//                 //           width: 1,
//                 //           color: const Color(0xff858D93).withOpacity(0.5),
//                 //         ),
//                 //       ),
//                 //       enabledBorder: OutlineInputBorder(
//                 //         borderRadius: BorderRadius.circular(6),
//                 //         borderSide: BorderSide(
//                 //           width: 1,
//                 //           color: const Color(0xff858D93).withOpacity(0.5),
//                 //         ),
//                 //       ),
//                 //       hintText: 'Write a massage..',
//                 //       hintStyle: TextStyle(
//                 //           fontFamily: 'Inter-Regular',
//                 //           fontSize: Globlas.deviceType == "phone" ? 14 : 24,
//                 //           fontStyle: FontStyle.normal,
//                 //           fontWeight: FontWeight.w400,
//                 //           letterSpacing: -0.33,
//                 //           color: const Color(0xff858D93))),
//                 // ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     FocusScope.of(context).unfocus();
//                     new TextEditingController().clear();

//                     viewModel.onSendButtonClick(productId, viewModel.rate);

//                     viewModel.notifyListeners();
//                   },
//                   child: ButtonWidget(
//                     isBusy: false,
//                     buttonTitle: 'Send',
//                     containerWidth: 130.0.h,
//                     containerHeigth: 38.h,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//               ],
//             ),
//           );
//   }

  bodyWidget(QuotationDetailViewModel viewModel, context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding:
          EdgeInsets.only(left: 16.h, right: 16.h, top: 16.h, bottom: 50.h),
      children: [
        detailWidget(viewModel),
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
        const SizedBox(
          height: 20,
        ),
        // viewModel.isBusy
        //     ? Container()
        //     : Padding(
        //         padding: EdgeInsets.only(left: 16, right: 16),
        //         child: InkWell(
        //           onTap: () {
        //             viewModel.onAcceptButtonClick();
        //           },
        //           child: ButtonWidget(
        //             buttonTitle: 'Accept & Pay',
        //             containerWidth: double.infinity,
        //             containerHeigth: 58.h,
        //           ),
        //         ),
        //       )
      ],
    );
  }
}
