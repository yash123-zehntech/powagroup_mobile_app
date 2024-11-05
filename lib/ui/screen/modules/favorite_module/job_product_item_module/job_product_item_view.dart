import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/add_cart_widget.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/helper_widget/end_quantity_widget.dart';
import 'package:powagroup/helper_widget/notification_truck.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/services/api_client.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/confirmation_module/confirmation_view.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/response_model/joblist_hive_model.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/response_model/joblist_hive_model.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/job_product_item_module/job_product_item_view_model.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';

import 'package:stacked/stacked.dart';
import '../../../../../helper_widget/network_error widget.dart';
import '../../home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_subcategory_response.dart';

class JobProductItemView extends StatefulWidget {
  JobListData? jobList;
  List<JobListProduct>? productsList;
  String? jobName;
  String? jobDate;

  JobProductItemView(
      {Key? key, this.jobList, this.productsList, this.jobName, this.jobDate})
      : super(key: key);

  @override
  State<JobProductItemView> createState() => _JobProductItemViewState();
}

class _JobProductItemViewState extends State<JobProductItemView> {
  int count = 0;
  List<JobListProduct>? productsList = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<JobProductItemViewModel>.reactive(
      viewModelBuilder: () => JobProductItemViewModel(),
      onViewModelReady: (viewModel) async {
        viewModel.showPricing = await AppUtil.getShowPricing();
        productsList = widget.productsList;
        viewModel.getBedgeCount();
      },
      builder: (context, viewModel, child) => Scaffold(
          bottomSheet: InkWell(
              onTap: () {
                viewModel.onYesButtonActionClick(context);
                // Navigator.of(context).push(PageRouteBuilder(
                //     opaque: false,
                //     pageBuilder: (BuildContext context, _, __) =>
                //         ConfirmationView()));
              },
              child: buttonWidget(viewModel, context)),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarWidget(
              title: '',
              backIcon: IconButton(
                padding: EdgeInsets.only(left: 5.h),
                icon: Icon(
                  PowaGroupIcon.back,
                  size: 24.h,
                  color: const Color(0xff36393C),
                ),
                onPressed: () {
                  viewModel.onBackActionClick(context);
                  // viewModel.navigationService.back();
                  // Navigator.pop(context);
                },
              ),
              // actionIcon: NotificationTruck(
              //     key: key,
              //     notificationCount: viewModel.itemCount,
              //     viewModel: viewModel,
              //     bottomBar: false),
            ),
          ),
          backgroundColor: const Color(0xffEFF1F2),
          body: Stack(
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
                  : logoWidget(),
              Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.07),
                  child:
                      productCategoriesList(viewModel, context, productsList)),
            ],
          )),
    );
  }

  // Return Button Widget
  Widget buttonWidget(JobProductItemViewModel viewModel, BuildContext context) {
    return
        // productsList!.isEmpty
        //     ? Container(
        //         height: 0.1,
        //         width: 0.1,
        //       )
        //     :
        Padding(
      padding: EdgeInsets.only(left: 16.h, bottom: 30.h, right: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonWidget(
            isBusy: false,
            buttonTitle: 'Add More Products',
            containerWidth: double.infinity,
            containerHeigth: 52.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          InkWell(
            onTap: (() {
              viewModel.addJobListToCart(widget.productsList, context);
            }),
            child: Container(
              width: double.infinity,
              height: 52.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: const Color(0xffD60505),
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 32,
                        offset: Offset(1, 3),
                        color: Color.fromRGBO(222, 179, 175, 0.72))
                  ],
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                'Add Job List To Truck',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    color: const Color(0xffFFFFFF)),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Return Product Categories List
  Widget productCategoriesList(JobProductItemViewModel viewModel,
      BuildContext context, List<JobListProduct>? productsList) {
    return productsList!.isEmpty
        ? Center(
            child: NetworkError(
              content: 'No products added.',
              subContant: 'Search a product below.',
              icon: 'assets/icon/network_error.png',
              viewModel: viewModel,
            ),
          )
        : ListView.builder(
            reverse: productsList.length >= 3 ? true : false,
            controller: viewModel.scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(left: 16.h, bottom: 150.h, right: 16.h),
            itemCount: productsList.length,
            itemBuilder: (BuildContext context, int index) {
              return Slidable(
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
                          viewModel.deleteProduct(widget.jobList,
                              productsList[index], viewModel, context, index);
                        },
                      ),
                    ],
                  ),
                  child: productCategoryItem(
                      viewModel, context, productsList, index));
            });
  }

  // Return Product Category Item by index
  Widget productCategoryItem(JobProductItemViewModel viewModel,
      BuildContext context, List<JobListProduct> productsList, int index) {
    return InkWell(
      onTap: () {
        viewModel.onProductSubCategoryItemClick(productsList[index], context);
      },
      child: Container(
        padding: EdgeInsets.all(16.h),
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: viewModel.isBusy
                        ? ShimmerLoading(
                            isLoading: true,
                            child: Container(
                              width: 60.h,
                              height: 60.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                            ))
                        : CachedNetworkImage(
                            imageUrl: ApiClient.BASE_URL +
                                productsList![index].mainImageUrl!,
                            fit: BoxFit.cover,
                            width: 100.w,
                            height: 100.h,
                            errorWidget: ((context, url, error) {
                              return Image.asset(
                                'assets/icon/dummy.png',
                                width: 105.w,
                                height: 100.h,
                                fit: BoxFit.cover,
                              );
                            }),
                          )),
                // Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(15.r),
                //     ),
                //     child: Image.asset(
                //       'assets/icon/Subtract3.png',
                //       fit: BoxFit.fill,
                //     )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          productsList![index].name == null ||
                                  productsList[index].name!.isEmpty
                              ? 'N/A'
                              : productsList[index].name.toString(),
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: Globlas.deviceType == "phone" ? 13 : 23,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.33,
                              color: const Color(0xff1B1D1E)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productsList[index].saleUom == null
                                  ? ""
                                  : "per ${productsList[index].saleUom}",
                              style: TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  fontSize:
                                      Globlas.deviceType == "phone" ? 14 : 24,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.33,
                                  color: const Color(0xff000000)),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            InkWell(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 32.h,
                                    width: 120.w,
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        width: 0.4,
                                        color: const Color(0xff858D93)
                                            .withOpacity(0.5),
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('Qty : ',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize:
                                                  Globlas.deviceType == "phone"
                                                      ? 14
                                                      : 24,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: -0.33,
                                              color: const Color(0xff858D93),
                                            )),
                                        Container(
                                          height: 25.h,
                                          width: 20.w,
                                          child: TextFormField(
                                            onChanged: (value) {
                                              productsList[index].yashValue =
                                                  value;
                                              viewModel.debouncer.run(() {
                                                viewModel
                                                    .updateControllerValue1(
                                                        widget.jobList,
                                                        index,
                                                        productsList[index]
                                                            .yashValue!,
                                                        AppUtil
                                                            .getQtyPriceByMultiply(
                                                                productsList[
                                                                        index]
                                                                    .yashValue!,
                                                                productsList[
                                                                        index]
                                                                    .qtyBreaks!),
                                                        // productsList[index]
                                                        //     .price,
                                                        productsList,
                                                        widget.jobName,
                                                        widget.jobDate);
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        new FocusNode());
                                              });
                                            },
                                            onTap: () {
                                              productsList[index]
                                                  .controllerForJobList!
                                                  .clear();

                                              viewModel.notifyListeners();
                                            },
                                            cursorColor: Colors.black,
                                            controller: productsList[index]
                                                .controllerForJobList,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                fontSize: Globlas.deviceType ==
                                                        "phone"
                                                    ? 18
                                                    : 28,
                                                color: const Color(0xff36393C),
                                                letterSpacing: -0.33),
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          constraints:
                                              const BoxConstraints.expand(
                                                  height: 20, width: 20),
                                          child: PopupMenuButton<QtyBreak>(
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(0),
                                            tooltip: " ",
                                            iconSize: 20,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            splashRadius: 12,
                                            itemBuilder:
                                                (BuildContext context) {
                                              return productsList[index]
                                                  .qtyBreaks!
                                                  .map((QtyBreak choice) {
                                                return PopupMenuItem<QtyBreak>(
                                                  onTap: () {
                                                    viewModel
                                                        .updateControllerValue1(
                                                            widget.jobList,
                                                            index,
                                                            choice.qty
                                                                .toString(),
                                                            choice.price,
                                                            productsList,
                                                            widget.jobName,
                                                            widget.jobDate);

                                                    viewModel.notifyListeners();
                                                  },
                                                  value: choice,
                                                  child: Container(
                                                      width: 20.w,
                                                      child: Text(
                                                          //choice.qty.toString()
                                                          AppUtil.getQTYValueForMenu(
                                                              choice.qty
                                                                  .toString()))),
                                                );
                                              }).toList();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                              ? RichText(
                                  text: TextSpan(
                                      text: productsList[index].priceTotal !=
                                              null
                                          ? '\$${productsList[index].priceTotal!.toStringAsFixed(2)}'
                                          : 'N/A',
                                      style: TextStyle(
                                        fontFamily: 'Raleway',
                                        letterSpacing: -0.33,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        color: const Color(0xff000000),
                                        fontSize: Globlas.deviceType == "phone"
                                            ? 16
                                            : 26,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: "  Per Unit",
                                            style: TextStyle(
                                                fontFamily: 'Raleway',
                                                fontSize: Globlas.deviceType ==
                                                        "phone"
                                                    ? 10
                                                    : 20,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: -0.33,
                                                color: const Color(0xff36393C)))
                                      ]),
                                )
                              : Container(
                                  height: 0,
                                  width: 0,
                                ),
                          const Spacer(
                            flex: 1,
                          ),
                          InkWell(
                              onTap: () async {
                                AppUtil.showSnackBar(
                                    'Please wait, we are adding your product to cart');
                                String loginToken =
                                    await AppUtil.getLoginToken();

                                if (loginToken != null &&
                                    loginToken.isNotEmpty) {
                                  ProductSubDetailModel data =
                                      await viewModel.getItemPrice(
                                    productsList[index].id,
                                  );

                                  viewModel.deliveryEX =
                                      (data.productResult!.delivery_ex)
                                          .toDouble();

                                  int userId = await AppUtil.getUserId();

                                  ProductData productData = ProductData(
                                      userId: userId,
                                      description:
                                          productsList[index].description,
                                      yashValue: productsList[index].yashValue != null &&
                                              productsList[index]
                                                  .yashValue!
                                                  .isNotEmpty
                                          ? productsList[index].yashValue
                                          : productsList[index]
                                                  .qtyBreaks!
                                                  .isNotEmpty
                                              ? productsList[index]
                                                  .qtyBreaks![0]
                                                  .qty!
                                                  .replaceAll(".0", "")
                                                  .toString()
                                              : '',
                                      extraImages:
                                          productsList[index].extraImages,
                                      id: productsList[index].id,
                                      isFav: productsList[index].isFav,
                                      mainImageUrl:
                                          productsList[index].mainImageUrl,
                                      name: productsList[index].name,
                                      price: productsList[index].price,
                                      priceByQty:
                                          productsList[index].priceByQty,
                                      priceTax: data.productResult != null
                                          ? double.parse(data.productResult!.product!.priceTax
                                              .toString())
                                          : double.parse(data.product!.priceTax!
                                              .toString()),
                                      priceUntaxed: data != null && data.productResult != null && data.productResult!.product != null
                                          ? data.productResult!.product!
                                              .priceUntaxed
                                          : 0.0,
                                      qtyBreaks: data.productResult != null
                                          ? data
                                              .productResult!.product!.qtyBreaks
                                          : data.product!.qtyBreaks,
                                      saleUom: productsList[index].saleUom,
                                      sku: productsList[index].sku,
                                      deliveryEx: data != null &&
                                              data.productResult != null &&
                                              data.productResult != null
                                          ? data.productResult!.delivery_ex
                                          : 0.0,
                                      deliveryInc: productsList[index].deliveryInc,
                                      deliveryTax: data != null && data.productResult != null && data.productResult != null ? data.productResult!.delivery_tax : productsList[index].deliveryTax,
                                      priceTotal: productsList[index].qtyBreaks == null || productsList[index].qtyBreaks!.isEmpty ? productsList[index].priceTotal : productsList[index].qtyBreaks![0].price,
                                      controllerForCart: TextEditingController(text: productsList[index].yashValue));
                                  AppUtil.onAddToTruckClick(
                                      productData, false, viewModel);
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
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            IconButton(
                constraints: BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () {
                  viewModel.deleteProduct(widget.jobList, productsList[index],
                      viewModel, context, index);
                },
                icon: Icon(PowaGroupIcon.delete,
                    size: 22.h, color: const Color(0xff36393C))),
          ],
        ),
      ),
    );
  }

  // Return top logo widget
  Widget logoWidget() {
    return Container(
      height: 70,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 5),
                child: Text(
                  widget.jobName != null && widget.jobName!.isNotEmpty
                      ? widget.jobName!
                      : 'N/A',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.33,
                      fontSize: Globlas.deviceType == "phone" ? 20 : 30,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xff1B1D1E)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
