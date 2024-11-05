import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/add_cart_widget.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/network_error%20widget.dart';
import 'package:powagroup/helper_widget/notification_truck.dart';
import 'package:powagroup/helper_widget/popup_menu_job.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/services/api_client.dart';
import 'package:powagroup/services/globals.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/all_product_module/favorite_view_model.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/create_job_list_selected_model.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/response_model/joblist_hive_model.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_job_list_module/create_job_list_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_model.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';

import 'package:stacked/stacked.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> counter = ValueNotifier<int>(0);
    return ViewModelBuilder<FavoriteViewModel>.reactive(
      viewModelBuilder: () => FavoriteViewModel(),
      onViewModelReady: (viewModel) async {
        bool isConnected = await AppUtil.checkNetwork();
        viewModel.showPricing = await AppUtil.getShowPricing();
        if (isConnected != null && isConnected) {
          viewModel.getAllFavouriteProduct(viewModel.value, true);
          viewModel.getAllFavouriteProductWithPrice(viewModel.value, true);
        } else if (!isConnected) {
          if (!viewModel.isLocalDBAlreadyCalled) {
            viewModel.getLocalDataList();
          }
        }

        viewModel.getJobProductList();
        viewModel.getBedgeCount();
        viewModel.notifyListeners();
      },
      builder: (context, viewModel, child) => Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.h),
            child: AppBarWidget(
              title: '',
              backIcon: null,
              // actionIcon: NotificationTruck(
              //     key: key,
              //     notificationCount: viewModel.itemCount,
              //     viewModel: viewModel,
              //     bottomBar: false),
            ),
          ),
          backgroundColor: const Color(0xffEFF1F2),
          body: Padding(
            padding: EdgeInsets.all(16.0.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                tabBarWidget(viewModel),
                SizedBox(
                  height: 16.h,
                ),
                viewModel.isAllProductClicked
                    ? viewModel.isAPIError
                        ? NetworkError(
                            content: 'Products Not Found!!',
                            subContant: 'No data, Please try again later.',
                            icon: 'assets/icon/network_error.png',
                            viewModel: viewModel,
                          )
                        : allProductList(viewModel, context, child)
                    : jobProductList(viewModel, context)
              ],
            ),
          )),
    );
  }

  // Return Tab bar widget
  Widget tabBarWidget(FavoriteViewModel viewModel) {
    return Padding(
        padding: EdgeInsets.only(top: 0.h),
        child: Container(
          width: double.infinity,
          height: 52.h,
          padding: EdgeInsets.all(6.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: const Color(0xffFFFFFF)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    viewModel.onTabItemClicked();
                  },
                  child: Container(
                    height: 40.h,
                    alignment: Alignment.center,
                    decoration: viewModel.isAllProductClicked
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: const Color(0xffD60505))
                        : null,
                    child: Text(
                      'Favourites',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: viewModel.isAllProductClicked
                              ? 'Raleway'
                              : 'Raleway',
                          letterSpacing: -0.33,
                          fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                          fontStyle: FontStyle.normal,
                          fontWeight: viewModel.isAllProductClicked
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: viewModel.isAllProductClicked
                              ? const Color(0xffFFFFFF)
                              : const Color(0xff36393C)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    viewModel.onTabItemClicked();
                  },
                  child: Container(
                    height: 40.h,
                    alignment: Alignment.center,
                    decoration: viewModel.isJobProductClicked
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffD60505))
                        : null,
                    child: Text(
                      'Job Product List',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: viewModel.isJobProductClicked
                              ? 'Raleway'
                              : 'Raleway',
                          letterSpacing: -0.33,
                          fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                          fontStyle: FontStyle.normal,
                          fontWeight: viewModel.isJobProductClicked
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: viewModel.isJobProductClicked
                              ? const Color(0xffFFFFFF)
                              : const Color(0xff36393C)),
                    ),
                  ),
                ),
              )
              // tabItem('All Products', viewModel),
              // tabItem('Job Product List', viewModel),
            ],
          ),
        ));
  }

  Widget buildSegment(String text, FavoriteViewModel viewModel) {
    return Container(
        alignment: Alignment.center,
        height: 35.h,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: viewModel.isJobProductClicked ? 'Raleway' : 'Raleway',
            letterSpacing: -0.33,
            fontSize: Globlas.deviceType == "phone" ? 14 : 24,
            fontStyle: FontStyle.normal,
            fontWeight: viewModel.isJobProductClicked
                ? FontWeight.w600
                : FontWeight.w400,
            // color: const Color(0xff36393C)
          ),
        ));
  }

  // // Return Tab Item
  // Widget tabItem(String title, FavoriteViewModel viewModel) {
  //   return Expanded(
  //     child: InkWell(
  //       onTap: () {
  //         viewModel.onTabItemClicked();
  //       },
  //       child: Container(
  //         height: 40,
  //         alignment: Alignment.center,
  //         decoration: viewModel.isAllProductClicked
  //             ? BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10),
  //                 color: const Color(0xffD60505))
  //             : null,
  //         child: Text(
  //           title,
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //               fontFamily: 'Raleway',
  //               letterSpacing: -0.33,
  //               fontSize: ScreenUtil().setSp(14),
  //               fontStyle: FontStyle.normal,
  //               fontWeight: FontWeight.w600,
  //               color: const Color(0xffFFFFFF)),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Return Job Product List
  Widget jobProductList(FavoriteViewModel viewModel, context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStatecheck) {
      return Expanded(
        child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 140.h,
                crossAxisCount: 2,
                crossAxisSpacing: 12.h,
                mainAxisSpacing: 12.h),
            itemCount:
                viewModel.jobList.isNotEmpty ? viewModel.jobList.length + 1 : 1,
            itemBuilder: (BuildContext context, int index) {
              return jobProductItem(context, viewModel, index, setStatecheck);
            }),
      );
    });
  }

  // Return Job Product Item
  Widget jobProductItem(context, FavoriteViewModel viewModel, int index,
      StateSetter setStatecheck) {
    return InkWell(
      onTap: () async {
        index == 0
            ? await Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) => CreateJoblistView(
                      key: key,
                      title: 'title',
                    )))
            : viewModel.onJobProductItemClick(
                viewModel.jobList[index - 1],
                viewModel.jobList[index - 1].productsList,
                viewModel.jobList[index - 1].jobName!,
                viewModel.jobList[index - 1].jobDate ?? '',
                context);
        viewModel.jobList = await AppUtil.getJobProductList();
        viewModel.notifyListeners();
      },
      child: Container(
        padding: EdgeInsets.all(8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.white,
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  index == 0
                      ? Container(
                          height: 45.h,
                          width: 45.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.r),
                              border: Border.all(
                                color: const Color(0xff858D93),
                              )),
                          child: Icon(Icons.add,
                              color: const Color(0xffD60505), size: 40.h),
                        )
                      : Text(
                          viewModel.jobList[index - 1].jobName == null
                              ? 'Plumbing Material'
                              : viewModel.jobList[index - 1].jobName.toString(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Raleway-Bold',
                              //fontSize: 13.0.sp,
                              fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                              letterSpacing: -0.33,
                              color: const Color(0xff1B1D1E)),
                        ),
                  const SizedBox(
                    height: 8,
                  ),
                  index == 0
                      ? Text(
                          'New Job List',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Raleway',
                              //fontSize: 13.0.sp,
                              fontSize: Globlas.deviceType == "phone" ? 12 : 22,
                              letterSpacing: -0.33,
                              color: const Color(0xff1B1D1E)),
                        )
                      : Text(
                          viewModel.jobList[index - 1].description == null
                              ? 'N/A'
                              : viewModel.jobList[index - 1].description
                                  .toString(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Raleway-Regular',
                              //fontSize: 13.0.sp,
                              fontSize: Globlas.deviceType == "phone" ? 12 : 22,
                              letterSpacing: -0.33,
                              color: const Color(0xff1B1D1E)),
                        ),
                  index == 0
                      ? Text(
                          '',
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            viewModel.jobList[index - 1].jobDate == null
                                ? 'N/A'
                                : viewModel.jobList[index - 1].jobDate
                                    .toString(),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontFamily: 'Raleway-Regular',
                                //fontSize: 13.0.sp,
                                fontSize:
                                    Globlas.deviceType == "phone" ? 12 : 22,
                                letterSpacing: -0.33,
                                color: const Color(0xff1B1D1E)),
                          ),
                        )
                ],
              ),
            ),
            index != 0
                ? PopupWidgetForJobs(
                    viewModel: viewModel,
                    index: index,
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  // Return Product Categories List
  Widget allProductList(
      FavoriteViewModel viewModel, BuildContext context, Widget? child) {
    return Expanded(
      child: !viewModel.isBusy &&
              viewModel.allProductList.length == 0 &&
              viewModel.allProductList.isEmpty
          ? NetworkError(
              content: 'Products Not Found!!',
              subContant: 'No data, Please try again later.',
              icon: 'assets/icon/network_error.png',
              viewModel: viewModel,
            )
          : getProductList(viewModel),
    );
  }

  Widget getProductList(FavoriteViewModel viewModel) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        // itemCount: 5,
        itemCount: viewModel.isBusy
            ? 5
            : viewModel.allProductList.isNotEmpty
                ? viewModel.allProductList.length
                : 0,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.only(
                top: 2.0,
              ),
              child: Slidable(
                  key: ValueKey(index),
                  closeOnScroll: false,
                  endActionPane: ActionPane(
                    extentRatio: 0.2,
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: const Color(0xffD60505),
                        icon: PowaGroupIcon.delete,
                        onPressed: (BuildContext context) {
                          // viewModel.deleteProduct(
                          //   viewModel.allProductList[index],
                          //   viewModel,
                          // );
                          viewModel.removeFromFavorite(
                              viewModel.allProductList[index].id);
                        },
                      ),
                    ],
                  ),
                  child: allProductItem(viewModel, index)));
        });
  }

  // Return Product Category Item by index
  Widget allProductItem(FavoriteViewModel viewModel, int index) {
    return InkWell(
      onTap: () {
        viewModel
            .onProductSubCategoryItemClick(viewModel.allProductList[index]);
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 16.sp,
          right: 16.sp,
          bottom: 16.h,
        ),
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.white,
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Positioned(
              top: 8,
              child: IconButton(
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    viewModel
                        .removeFromFavorite(viewModel.allProductList[index].id);
                  },
                  icon: Icon(PowaGroupIcon.delete,
                      size: 22.h, color: const Color(0xff36393C))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: viewModel.isBusy
                          ? ShimmerLoading(
                              isLoading: true,
                              child: Container(
                                width: 100.w,
                                height: 100.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[100],
                                ),
                              ))
                          : CachedNetworkImage(
                              imageUrl: ApiClient.BASE_URL +
                                  viewModel.allProductList[index].mainImageUrl
                                      .toString(),
                              fit: BoxFit.cover,
                              width: 100.w,
                              height: 100.h,
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16.h,
                          ),
                          viewModel.isBusy
                              ? ShimmerLoading(
                                  isLoading: true,
                                  child: Container(
                                    width: double.infinity,
                                    height: 15.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[100],
                                    ),
                                  ))
                              : Text(
                                  viewModel.allProductList[index].name !=
                                              null &&
                                          viewModel.allProductList[index].name!
                                              .isNotEmpty
                                      ? viewModel.allProductList[index].name!
                                      : "",
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: Globlas.deviceType == 'phone'
                                          ? 13
                                          : 23,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.33,
                                      color: const Color(0xff1B1D1E)),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              viewModel.showPricing
                                  ? viewModel.isBusy
                                      ? ShimmerLoading(
                                          isLoading: true,
                                          child: Container(
                                            width: 200.h,
                                            height: 15.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey[100],
                                            ),
                                          ))
                                      : RichText(
                                          text: TextSpan(
                                              // text: viewModel
                                              //             .allProductList[index]
                                              //             .priceUntaxed !=
                                              //         null
                                              //     ? '\$${viewModel.allProductList[index].priceUntaxed.toString()}'
                                              //     : 'N/A',
                                              text: viewModel
                                                          .allProductList[index]
                                                          .priceTotal !=
                                                      null
                                                  ? '\$${viewModel.allProductList[index].priceTotal.toString()}'
                                                  : 'N/A',
                                              style: TextStyle(
                                                  fontFamily: 'Raleway',
                                                  letterSpacing: -0.33,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal,
                                                  color:
                                                      const Color(0xff000000),
                                                  fontSize:
                                                      Globlas.deviceType ==
                                                              'phone'
                                                          ? 14
                                                          : 26),
                                              children: [
                                                TextSpan(
                                                    text: "  Per Unit",
                                                    style: TextStyle(
                                                        fontFamily: 'Raleway',
                                                        fontSize:
                                                            Globlas.deviceType ==
                                                                    'phone'
                                                                ? 10
                                                                : 20,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        letterSpacing: -0.33,
                                                        color: const Color(
                                                            0xff36393C)))
                                              ]),
                                        )
                                  : Container(
                                      height: 0,
                                      width: 0,
                                    ),

                              InkWell(
                                  onTap: () async {
                                    AppUtil.showSnackBar(
                                        'Please wait, we are adding your product to cart');
                                    String loginToken =
                                        await AppUtil.getLoginToken();

                                    if (loginToken != null &&
                                        loginToken.isNotEmpty) {
                                      ProductData productItem =
                                          viewModel.allProductList[index];

                                      ProductSubDetailModel data =
                                          await viewModel.getItemPrice(
                                        viewModel.allProductList[index].id,
                                      );

                                      if (data != null) {
                                        productItem.priceUntaxed =
                                            data.productResult != null
                                                ? data.productResult!.product!
                                                    .priceUntaxed
                                                : data.product!.priceUntaxed;

                                        productItem.priceTax = data
                                                    .productResult !=
                                                null
                                            ? double.parse(data
                                                .productResult!.delivery_tax!
                                                .toString())
                                            : double.parse(
                                                data.delivery_tax!.toString());

                                        productItem.deliveryTax = data
                                                    .productResult !=
                                                null
                                            ? double.parse(data
                                                .productResult!.delivery_tax!
                                                .toString())
                                            : double.parse(
                                                data.delivery_tax!.toString());

                                        productItem.deliveryEx =
                                            data.productResult != null
                                                ? data
                                                    .productResult!.delivery_ex!
                                                : data.delivery_ex!;

                                        productItem.price = data
                                                    .productResult !=
                                                null
                                            ? data.productResult!.product!.price
                                                    .toString() ??
                                                ""
                                            : data.product!.price.toString() ??
                                                "";
                                        ;
                                        productItem.priceByQty =
                                            data.productResult! != null
                                                ? data.productResult!.product!
                                                        .priceByQty
                                                        .toString() ??
                                                    ""
                                                : data.product!.priceByQty
                                                        .toString() ??
                                                    "";

                                        productItem.qtyBreaks =
                                            data.productResult != null
                                                ? data.productResult!.product!
                                                    .qtyBreaks
                                                : data.product!.qtyBreaks;
                                      }

                                      AppUtil.onAddToTruckClick(
                                          viewModel.allProductList[index],
                                          false,
                                          viewModel);
                                      viewModel.notifyListeners();
                                    } else {
                                      AppUtil.showLoginMessageDialog(
                                          AppUtil.getContext(),
                                          'Please Sign In/Register to purchase products');
                                    }
                                  },
                                  child: viewModel.isBusy
                                      ? Container()
                                      : AddTruckWidget())
                              // )
                              // const Spacer(
                              //   flex: 1,
                              // ),
                              // viewModel.isBusy
                              //     ? Container()
                              //     :
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
