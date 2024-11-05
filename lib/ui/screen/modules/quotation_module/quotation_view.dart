import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/network_error%20widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/ui/screen/modules/quotation_module/quotation_view_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';

class QuotationView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuotationViewViewState();
  }
}

class _QuotationViewViewState extends State<QuotationView>
    with TickerProviderStateMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuotationViewModel>.reactive(
      viewModelBuilder: () => QuotationViewModel(),
      onDispose: (viewModel) {
        viewModel.controller.asMap().forEach((index, element) {
          viewModel.controller[index]!.dispose();
        });
      },
      onViewModelReady: (viewModel) async {
        viewModel.tickerProvider = this;
        bool isConnected = await AppUtil.checkNetwork();
        if (isConnected != null && isConnected) {
          viewModel.getQuotations(true);
        }
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
                          viewModel.quotationOrdersList.isNotEmpty) {
                        return bodyWidget(viewModel);
                      } else {
                        // if (!viewModel.isAlreadyCalled) {
                        //   viewModel.getQuotations(false);
                        // }
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
                      if (viewModel.quotationOrdersList.isNotEmpty) {
                        return bodyWidget(viewModel);
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
                    return bodyWidget(viewModel);
                  }),
                  child: child,
                )
              : Center(
                  child: NetworkError(
                    content: 'Quotations Not Found!!',
                    subContant: 'No data, Please try again later.',
                    icon: 'assets/icon/network_error.png',
                    viewModel: viewModel,
                  ),
                )),
    );
  }

  Widget bodyWidget(QuotationViewModel viewModel) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: viewModel.isBusy ? 10 : viewModel.quotationOrdersList.length,
        padding: EdgeInsets.only(left: 16.h, right: 16.h, top: 16.h),
        itemBuilder: (BuildContext context, int index) {
          return quotationItem(viewModel, index, context);
        });
  }

  // Return Sales Order Item Widget
  Widget quotationItem(QuotationViewModel viewModel, int index, context) {
    return Container(
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
          viewModel.isBusy
              ? ShimmerLoading(
                  isLoading: true,
                  child: Container(
                    width: double.infinity,
                    height: 100.h,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10)),
                  ))
              : Container(
                  height: !viewModel.isBusy &&
                          viewModel.quotationOrdersList != null &&
                          viewModel.quotationOrdersList[index].isExpand!
                      ? 50
                      : 50,
                  child: ListTile(
                    title: viewModel.isBusy
                        ? ShimmerLoading(
                            isLoading: true,
                            child: Container(
                              width: double.infinity,
                              height: 15.h,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10)),
                            ))
                        : RichText(
                            text: TextSpan(
                                text: 'Quotation# : ',
                                style: TextStyle(
                                    fontFamily: 'Raleway',
                                    letterSpacing: -0.33,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                    color: const Color(0xff858D93),
                                    fontSize: Globlas.deviceType == "phone"
                                        ? 13
                                        : 23),
                                children: [
                                  TextSpan(
                                      text: viewModel.quotationOrdersList[index]
                                                      .name !=
                                                  null &&
                                              viewModel
                                                  .quotationOrdersList[index]
                                                  .name!
                                                  .isNotEmpty
                                          ? viewModel
                                              .quotationOrdersList[index].name
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Raleway',
                                          fontSize:
                                              Globlas.deviceType == "phone"
                                                  ? 14
                                                  : 24,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.33,
                                          color: const Color(0xff1D1B1E)))
                                ]),
                          ),
                    trailing: IconButton(
                        onPressed: () {
                          viewModel.onExpandClick(
                              index, viewModel.quotationOrdersList[index].id);
                          // viewModel.animateView(viewModel.controller[index],
                          //     viewModel.animation[index],index);
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          size: 24.h,
                          color: const Color(0xff36393C).withOpacity(0.7),
                        )),
                    onTap: () {
                      viewModel.onQuotationItemClick(
                          viewModel.quotationOrdersList[index].id, context);
                    },
                  ),
                ),
          // !viewModel.isBusy && viewModel.quotationOrdersList[index].isExpand!
          //     ?
          !viewModel.isBusy && viewModel.animation.length > 0
              ? SizeTransition(
                  sizeFactor: viewModel.animation[index]!,
                  axis: Axis.vertical,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 16.h, right: 16.h, bottom: 20.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            !viewModel.isBusy &&
                                    viewModel.quotationOrdersList != null
                                ? quotationDetailWidget(
                                    'Quotation Date',
                                    viewModel.quotationOrdersList[index]
                                                    .orderDate !=
                                                null &&
                                            viewModel.quotationOrdersList[index]
                                                .orderDate!.isNotEmpty
                                        ? AppUtil.getFormattedDate(
                                            viewModel.quotationOrdersList[index]
                                                .orderDate!
                                                .toString(),
                                            false)
                                        : "",
                                  )
                                : quotationDetailWidget('Quotation Date', ''),
                            Container(
                                margin: const EdgeInsets.only(right: 30),
                                child: !viewModel.isBusy &&
                                        viewModel.quotationOrdersList != null
                                    ? quotationDetailWidget(
                                        'Valid Until',
                                        viewModel.quotationOrdersList[index]
                                                        .orderDate !=
                                                    null &&
                                                viewModel
                                                    .quotationOrdersList[index]
                                                    .orderDate!
                                                    .isNotEmpty
                                            ? viewModel
                                                        .quotationOrdersList[
                                                            index]
                                                        .expiryDate ==
                                                    false
                                                ? "NA"
                                                : AppUtil.getFormattedDate(
                                                    viewModel
                                                        .quotationOrdersList[
                                                            index]
                                                        .expiryDate,
                                                    true)
                                            : "NA")
                                    : quotationDetailWidget(
                                        'Valid Until', 'NA')),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        viewModel.isBusy
                            ? ShimmerLoading(
                                isLoading: true,
                                child: Container(
                                  width: double.infinity,
                                  height: 15.h,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10)),
                                ))
                            : RichText(
                                text: TextSpan(
                                    text: 'Total : ',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      letterSpacing: -0.33,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      color: const Color(0xff858D93),
                                      fontSize: Globlas.deviceType == "phone"
                                          ? 13
                                          : 23,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: viewModel
                                                          .quotationOrdersList[
                                                              index]
                                                          .total !=
                                                      null &&
                                                  viewModel
                                                      .quotationOrdersList[
                                                          index]
                                                      .total
                                                      .toString()
                                                      .isNotEmpty
                                              ? '\$${viewModel.quotationOrdersList[index].total!.toStringAsFixed(2)}'
                                              : "",
                                          style: TextStyle(
                                              fontFamily: 'Raleway',
                                              fontSize:
                                                  Globlas.deviceType == "phone"
                                                      ? 14
                                                      : 24,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: -0.33,
                                              color: const Color(0xff1D1B1E)))
                                    ]),
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

  // Return Quotation Details Widget
  Widget quotationDetailWidget(String title, String value) {
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
              fontWeight: FontWeight.w600,
              letterSpacing: -0.33,
              color: const Color(0xff858D93)),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: Globlas.deviceType == "phone" ? 14 : 24,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.33,
              color: const Color(0xff1B1D1E)),
        ),
      ],
    );
  }
}
