import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/add_cart_widget.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/network_error%20widget.dart';
import 'package:powagroup/helper_widget/popup_menu_widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/services/api_client.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_category_module/response_model/product_categories_response.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/product_subcategory_item_view_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/sort_list_item_model.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';

class ProductSubCategoryItemView extends StatefulWidget {
  Category? subCategoryObj;
  String? path;

  ProductSubCategoryItemView({Key? key, this.subCategoryObj, this.path})
      : super(key: key);

  @override
  State<ProductSubCategoryItemView> createState() =>
      _ProductSubCategoryItemViewState();
}

class _ProductSubCategoryItemViewState
    extends State<ProductSubCategoryItemView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductSubCategoryItemViewModel>.reactive(
      viewModelBuilder: () => ProductSubCategoryItemViewModel(),
      onViewModelReady: (viewModel) async {
        if (widget.path != null &&
            widget.path!.isNotEmpty != null &&
            widget.subCategoryObj != null) {
          await viewModel.getProductSubCategoriesItemsWithoutPrice(
              widget.path, true);
          viewModel.getProductSubCategoriesItemsOnlyPrice(widget.path, true);
          viewModel.subCategoryId = widget.path!;
        }
        viewModel.showPricing = await AppUtil.getShowPricing();

        viewModel.getBedgeCount();
      },
      builder: (
        context,
        viewModel,
        child,
      ) =>
          Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(60.h),
                child: AppBarWidget(
                  title: '',
                  backIcon: IconButton(
                    padding: const EdgeInsets.only(left: 5),
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
              body: OfflineBuilder(
                connectivityBuilder: (BuildContext context,
                    ConnectivityResult connectivity, Widget child) {
                  final bool connected =
                      connectivity != ConnectivityResult.none;

                  if (connected) {
                    if (!viewModel.isLoading &&
                        viewModel.productList.isNotEmpty &&
                        viewModel.productList != null) {
                      return bodyWidget(viewModel);
                    }

                    return child;
                  } else if (!connected) {
                    if (!viewModel.isLocalDBAlreadyCalled) {
                      viewModel.getLocalDataList(widget
                          .subCategoryObj!.parentPath!
                          .replaceFirst("/", "-"));
                    }

                    if (viewModel.productList.isNotEmpty &&
                        viewModel.productList != null) {
                      return bodyWidget(viewModel);
                    } else {
                      return Center(
                        child: NetworkError(
                          content: 'Network Error',
                          subContant: 'The network connection is lost',
                          icon: 'assets/icon/mobile_network_error.png',
                          viewModel: viewModel,
                        ),
                      );
                    }
                  }
                  return child;
                },
                builder: ((context) {
                  return bodyWidget(viewModel);
                }),
                child: child,
              )),
    );
  }

  // Make a Body Widget
  Widget bodyWidget(ProductSubCategoryItemViewModel viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !viewModel.isLoading && viewModel.productList.isEmpty
            ? Container()
            : logoWidget(),
        !viewModel.isLoading && viewModel.productList.isEmpty
            ? Container()
            : SizedBox(
                height: 12.h,
              ),
        !viewModel.isLoading && viewModel.productList.isEmpty
            ? Container()
            : Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 12.h),
                child: Align(
                    alignment: Alignment.topRight, child: sortBy(viewModel)),
              ),
        productCategoriesList(viewModel),
      ],
    );
  }

  Widget sortBy(ProductSubCategoryItemViewModel viewModel) => InkWell(
        child: Container(
            height: 30.h,
            width: 90.h,
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              border: Border.all(
                color: const Color(0xff1A94FF),
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(PowaGroupIcon.sort,
                    color: const Color(0xff1A94FF), size: 22.h),
                Text('Sort by',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: Globlas.deviceType == 'phone' ? 13.0 : 20.0,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        // letterSpacing: -0.33,
                        color: const Color(0xff1A94FF)))
              ],
            )),
        onTap: () {
          showModal(AppUtil.getContext(), viewModel.dropdownItems, viewModel);
        },
      );

  // Return Product Categories List
  Widget productCategoriesList(ProductSubCategoryItemViewModel viewModel) {
    return viewModel.isLoading
        ? Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 16,
                  bottom: 16,
                  right: 16,
                ),
                itemCount:
                    viewModel.isLoading ? 5 : viewModel.productList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: ShimmerLoading(
                        isLoading: true,
                        child: Container(
                          width: double.infinity,
                          height: 200.h,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10)),
                        )),
                  );
                }))
        : viewModel.productList.length == 0 && !viewModel.isLoading
            ? Expanded(
                child: Center(
                  child: NetworkError(
                    content: 'Products Not Found!!',
                    subContant: 'No data, Please try again later.',
                    icon: 'assets/icon/network_error.png',
                    viewModel: viewModel,
                  ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                    itemCount:
                        viewModel.isLoading ? 10 : viewModel.productList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return viewModel.isLoading
                          ? ShimmerLoading(
                              isLoading: true,
                              child: Container(
                                width: double.infinity,
                                height: 15.h,
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10)),
                              ))
                          : productCategoryItem(viewModel, index, context);
                    }),
              );
  }

  // Return Product Category Item by index
  Widget productCategoryItem(
      ProductSubCategoryItemViewModel viewModel, int index, context) {
    return InkWell(
      onTap: () {
        if (viewModel.productList.length > 0 &&
            viewModel.productList[index].yashValue != null &&
            viewModel.productList[index].yashValue!.isNotEmpty) {
          viewModel.onProductSubCategoryItemClick(
              viewModel.productList[index], context);
        }
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 12),
        margin: const EdgeInsets.only(bottom: 16),
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
                  borderRadius: BorderRadius.circular(15),
                  child: viewModel.isLoading
                      ? ShimmerLoading(
                          isLoading: true,
                          child: Container(
                            width: 105.h,
                            height: 100.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[100],
                            ),
                          ))
                      : Hero(
                          tag:
                              "*PO* Fluidmaster 242UK063 Standard Replacement Seal",
                          // '${viewModel.productList[index].name} $index',
                          child: CachedNetworkImage(
                            imageUrl: viewModel
                                            .productList[index].mainImageUrl !=
                                        null &&
                                    viewModel.productList[index].mainImageUrl!
                                        .isNotEmpty
                                ? ApiClient.BASE_URL +
                                    viewModel.productList[index].mainImageUrl!
                                : '',
                            fit: BoxFit.cover,
                            width: 105.h,
                            height: 100.h,
                            errorWidget: ((context, url, error) {
                              return Image.asset(
                                'assets/icon/dummy.png',
                                width: 105.h,
                                height: 100.h,
                                fit: BoxFit.cover,
                              );
                            }),
                          ),
                        ),
                ),
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
                        padding: EdgeInsets.only(
                          right: 30.h,
                        ),
                        child: viewModel.isLoading
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
                                viewModel.productList[index].name != null &&
                                        viewModel
                                            .productList[index].name!.isNotEmpty
                                    ? viewModel.productList[index].name!
                                    : "",
                                style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize:
                                        Globlas.deviceType == "phone" ? 13 : 23,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.33,
                                    color: const Color(0xff1B1D1E)),
                              ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (viewModel.isLoading)
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: ShimmerLoading(
                              isLoading: true,
                              child: Container(
                                width: double.infinity,
                                height: 15.h,
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10)),
                              )),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            viewModel.showPricing
                                ? RichText(
                                    text: TextSpan(
                                        // text: viewModel.productList[index]
                                        //             .priceUntaxed !=
                                        //         null
                                        //     ? "\$${viewModel.productList[index].priceUntaxed!.toStringAsFixed(2)}"
                                        //     : 'N/A',
                                        text: viewModel.productList[index]
                                                    .priceTotal !=
                                                null
                                            ? "\$${viewModel.productList[index].priceTotal!.toStringAsFixed(2)}"
                                            : 'N/A',
                                        style: TextStyle(
                                            fontFamily: 'Raleway',
                                            letterSpacing: -0.33,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            color: const Color(0xff000000),
                                            fontSize:
                                                Globlas.deviceType == "phone"
                                                    ? 16
                                                    : 26),
                                        children: [
                                          TextSpan(
                                              text: "  Per Unit",
                                              style: TextStyle(
                                                  fontFamily: 'Raleway',
                                                  fontSize:
                                                      Globlas.deviceType ==
                                                              "phone"
                                                          ? 10
                                                          : 20,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: -0.33,
                                                  color:
                                                      const Color(0xff36393C)))
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
                                      loginToken.isNotEmpty &&
                                      viewModel.productList != null &&
                                      viewModel.productList.isNotEmpty) {
                                    ProductData productItem =
                                        viewModel.productList[index];

                                    ProductSubDetailModel data =
                                        await viewModel.getItemPrice(
                                      viewModel.productList[index].id,
                                    );

                                    if (data != null) {
                                      productItem.priceUntaxed =
                                          data.productResult != null
                                              ? data.productResult!.product!
                                                  .priceUntaxed
                                              : data.product!.priceUntaxed;

                                      productItem.priceTax =
                                          data.productResult != null
                                              ? double.parse(data.productResult!
                                                  .product!.priceTax
                                                  .toString())
                                              : double.parse(data
                                                  .product!.priceTax!
                                                  .toString());

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
                                              ? data.productResult!.delivery_ex!
                                              : data.delivery_ex!;

                                      productItem.price = data.productResult !=
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
                                        productItem, false, viewModel);

                                    viewModel.notifyListeners();
                                  } else {
                                    AppUtil.showLoginMessageDialog(
                                        AppUtil.getContext(),
                                        'Please Sign In/Register to purchase products');
                                  }
                                },
                                child: AddTruckWidget())
                          ],
                        )
                    ],
                  ),
                ),
              ],
            ),
            !viewModel.isLoading &&
                    viewModel.productList.length > 0 &&
                    viewModel.productList.isNotEmpty
                ? PopupWidget(
                    productData: viewModel.productList[index],
                    id: viewModel.productList[index].id.toString(),
                    viewModel: viewModel,
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  // Return top logo widget
  Widget logoWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 5, right: 16),
      child: Text(
        widget.subCategoryObj != null &&
                widget.subCategoryObj!.name != null &&
                widget.subCategoryObj!.name!.isNotEmpty
            ? widget.subCategoryObj!.name!
            : '',
        style: TextStyle(
            fontFamily: 'Raleway',
            fontStyle: FontStyle.normal,
            letterSpacing: -0.33,
            fontSize: Globlas.deviceType == "phone" ? 20 : 30,
            fontWeight: FontWeight.w800,
            color: const Color(0xff1B1D1E)),
      ),
    );
  }

  void showModal(BuildContext context, List<ListItem> dropdownItems,
      ProductSubCategoryItemViewModel viewModel) {
    showMaterialModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: 280.h,
            padding: const EdgeInsets.all(0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32.0),
                  topLeft: Radius.circular(32.0),
                )),
            alignment: Alignment.bottomLeft,
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 15.0),
                  child: Text("Sort By",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          letterSpacing: -0.33,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: const Color(0xff000000),
                          fontSize: Globlas.deviceType == "phone" ? 20 : 30)),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(5),
                    itemCount: dropdownItems.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: InkWell(
                            child: Container(
                              height: 49.h,
                              color: viewModel.dropdownItems[index].name
                                      .contains(viewModel.getIndexOFlist)
                                  ? const Color(0xFFD60505)
                                  : Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 9.0,
                                  ),
                                  child: Text(dropdownItems[index].name,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontFamily: 'Raleway',
                                          letterSpacing: -0.33,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          color: viewModel
                                                  .dropdownItems[index].name
                                                  .contains(
                                                      viewModel.getIndexOFlist)
                                              ? Colors.white
                                              : const Color(0xff000000),
                                          fontSize:
                                              Globlas.deviceType == "phone"
                                                  ? 15
                                                  : 28)),
                                ),
                              ),
                            ),
                            onTap: () {
                              viewModel.getIndexOFlist =
                                  dropdownItems[index].name;
                              viewModel.getSortList(
                                  viewModel.dropdownItems[index].name);
                              viewModel.notifyListeners();
                              //viewModel.navigationService.back();
                              Navigator.pop(context);
                            }),
                      );
                    }),
              ],
            ),
          );
        });
  }
}
