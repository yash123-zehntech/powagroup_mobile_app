import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/my_flutter_app_icons.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/network_error%20widget.dart';
import 'package:powagroup/helper_widget/searchbar_widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/services/api_client.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_model.dart';
import 'package:powagroup/ui/screen/modules/search_module/search_view_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      viewModelBuilder: () => SearchViewModel(),
      onViewModelReady: (viewModel) async {
        viewModel.searchTap = false;
        viewModel.notifyListeners();
        viewModel.getSearchLocaldata();
        bool isConnected = await AppUtil.checkNetwork();
        if (isConnected != null && isConnected) {
          viewModel.onItemChanged();
          viewModel.isNetworkConnected = true;

          viewModel.notifyListeners();
        } else if (!isConnected) {
          viewModel.isNetworkConnected = false;
          viewModel.connectivity.disposeStream();
          viewModel.notifyListeners();
        }
      },
      builder: (context, viewModel, child) => WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return true;
        },
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: SearchBarWidget(
                viewModel: viewModel,
                backIcon: Platform.isIOS
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(
                          PowaGroupIcon.back,
                          size: 24.h,
                          color: const Color(0xff36393C),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    : null,
              ),
            ),
            backgroundColor: const Color(0XFFEFF1F2),
            body: !viewModel.isAPIError
                ? viewModel.isNetworkConnected != null &&
                        viewModel.isNetworkConnected!
                    ? !viewModel.isBusy && viewModel.noDataFound
                        ? Center(
                            child: NetworkError(
                              content: 'Products Not Found!!',
                              subContant: 'No data, Please try again later.',
                              icon: 'assets/icon/network_error.png',
                              viewModel: viewModel,
                            ),
                          )
                        : viewModel.searchTap == true
                            ? ListView.builder(
                                itemCount: viewModel.isBusy
                                    ? 10
                                    : viewModel.searchProductResponse != null
                                        ? viewModel.searchProductResponse!
                                            .productResult!.products!.length
                                        : 0,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(16),
                                itemBuilder: (BuildContext context, int index) {
                                  return productView(viewModel, index, context);
                                })
                            : viewModel.searchList.isNotEmpty
                                ? Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, top: 16),
                                              child: Text(
                                                'Recent',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff36393C),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Raleway',
                                                  letterSpacing: -0.33,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize:
                                                      Globlas.deviceType ==
                                                              "phone"
                                                          ? 18
                                                          : 28,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16.0, top: 16),
                                                child: Text(
                                                  'Clear All',
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xffD60505),
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Raleway',
                                                    letterSpacing: -0.33,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize:
                                                        Globlas.deviceType ==
                                                                "phone"
                                                            ? 18
                                                            : 28,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                viewModel.clearLocalList();
                                              },
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount:
                                                  viewModel.searchList.length,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              padding: const EdgeInsets.all(16),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return recentData(
                                                    viewModel, index, context);
                                              }),
                                        ),
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: NetworkError(
                                      content: 'Search for products Above',
                                      subContant:
                                          'No data, Please try again later',
                                      icon: 'assets/icon/network_error.png',
                                      viewModel: viewModel,
                                    ),
                                  )
                    : Center(
                        child: NetworkError(
                          content: 'Network Error',
                          subContant: 'The network connection is lost',
                          icon: 'assets/icon/mobile_network_error.png',
                          viewModel: viewModel,
                        ),
                      )
                : Center(
                    child: NetworkError(
                      content: 'Products Not Found!!',
                      subContant: 'No data, Please try again later.',
                      icon: 'assets/icon/network_error.png',
                      viewModel: viewModel,
                    ),
                  )),
      ),
    );
  }

  Widget recentData(
      SearchViewModel viewModel, int index, BuildContext context) {
    return InkWell(
      onTap: () {
        viewModel.onItemClick(viewModel.searchList[index], context);
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: imageLocal(viewModel, index),
        title: Transform.translate(
          offset: const Offset(-10, 0),
          child: Text(
              viewModel.searchList[index].name != null &&
                      viewModel.searchList[index].name!.isNotEmpty
                  ? viewModel.searchList[index].name!
                  : '',
              style: TextStyle(
                color: const Color(0xff36393C),
                fontWeight: FontWeight.w500,
                fontFamily: 'Raleway',
                letterSpacing: -0.33,
                fontStyle: FontStyle.normal,
                fontSize: Globlas.deviceType == "phone" ? 15 : 25,
              )),
        ),

        subtitle: Transform.translate(
          offset: const Offset(-10, 0),
          child: Text(
              viewModel.searchList[index].sku != null &&
                      viewModel.searchList[index].sku!.isNotEmpty
                  ? viewModel.searchList[index].sku!
                  : '',
              style: TextStyle(
                  color: const Color(0xff36393C),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Raleway',
                  fontSize: Globlas.deviceType == 'phone' ? 15 : 20)),
        ),
        // selected: true,
        trailing: canacelIcon(viewModel, index),
      ),
    );
  }

  Widget imageLocal(SearchViewModel viewModel, int index) => ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl:
            ApiClient.BASE_URL + viewModel.searchList[index].mainImageUrl!,
        fit: BoxFit.cover,
        width: 60.h,
        height: 60.h,
        errorWidget: ((context, url, error) {
          return Image.asset(
            'assets/icon/dummy.png',
            width: 60.h,
            height: 60.h,
            fit: BoxFit.cover,
          );
        }),
      ));

  // Return Product View
  Widget productView(
      SearchViewModel viewModel, int index, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: InkWell(
          onTap: () {
            viewModel.onItemClick(
                viewModel
                    .searchProductResponse!.productResult!.products![index],
                context);
          },
          child: image(viewModel, index)),
      title: Transform.translate(
        offset: const Offset(-10, 0),
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
            : InkWell(
                onTap: () {
                  viewModel.onItemClick(
                      viewModel.searchProductResponse!.productResult!
                          .products![index],
                      context);
                },
                child: Text(
                    viewModel.searchProductResponse!.productResult!
                            .products![index].name!.isNotEmpty
                        ? viewModel.searchProductResponse!.productResult!
                            .products![index].name!
                        : '',
                    style: TextStyle(
                      color: const Color(0xff36393C),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Raleway',
                      letterSpacing: -0.33,
                      fontStyle: FontStyle.normal,
                      fontSize: Globlas.deviceType == "phone" ? 15 : 25,
                    )),
              ),
      ),
      trailing: viewModel.isBusy
          ? ShimmerLoading(
              isLoading: true,
              child: Container(
                width: 15.w,
                height: 15.h,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10)),
              ))
          : PopupMenuButton<int>(
              position: PopupMenuPosition.over,
              padding: Globlas.deviceType == 'phone'
                  ? const EdgeInsets.only(
                      left: 23,
                      top: 0,
                      bottom: 30,
                    )
                  : const EdgeInsets.all(0),
              icon: Icon(
                Icons.add,
                size: 26,
                color: Color(0xffD60505),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      viewModel.searchFieldFocus.unfocus();
                      viewModel.addFavorite(
                          viewModel.searchProductResponse!.productResult!
                              .products![index].id,
                          viewModel.searchProductResponse!.productResult!
                              .products![index]);
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Icon(
                            PowaGroupIcon.heart,
                            color: const Color(0xff858D93),
                            size: 26.h,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            !viewModel.searchProductResponse!.productResult!
                                    .products![index].isFav!
                                ? "Add to favourite"
                                : 'Remove from favourite',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.33,
                              fontSize: Globlas.deviceType == "phone" ? 15 : 20,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff1B1D1E),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // PopupMenuItem 2
                PopupMenuItem(
                  value: 2,
                  // row with two children
                  child: InkWell(
                    onTap: () {
                      addToJobList(context, viewModel, index);
                    },
                    child: Row(
                      children: [
                        Icon(
                          MyFlutterApp.list_alt,
                          color: const Color(0xff858D93),
                          size: 24.h,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Add to Job List",
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.33,
                            fontSize: Globlas.deviceType == "phone" ? 15 : 20,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff1B1D1E),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  // row with 2 children
                  child: InkWell(
                    onTap: () {
                      addTruck(context, viewModel, index);
                    },
                    child: Row(
                      children: [
                        Icon(
                          PowaGroupIcon.truck_1,
                          color: const Color(0xff858D93),
                          size: 26.h,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Add to Truck",
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.33,
                            fontSize: Globlas.deviceType == "phone" ? 15 : 20,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff1B1D1E),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
              offset:
                  Globlas.deviceType == "phone" ? Offset(0, 30) : Offset(0, 50),
              color: const Color(0xffffffff),
              elevation: 5,
              // on selected we show the dialog box
              onSelected: (value) async {
                if (value == 1) {
                  viewModel.searchFieldFocus.unfocus();
                  viewModel.addFavorite(
                      viewModel.searchProductResponse!.productResult!
                          .products![index].id,
                      viewModel.searchProductResponse!.productResult!
                          .products![index]);
                } else if (value == 2) {
                  addToJobList(context, viewModel, index);
                } else if (value == 3) {
                  addTruck(context, viewModel, index);
                }
              },
            ),
      subtitle: Transform.translate(
        offset: const Offset(-10, 0),
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
            : InkWell(
                onTap: () {
                  viewModel.onItemClick(
                      viewModel.searchProductResponse!.productResult!
                          .products![index],
                      context);
                },
                child: Text(
                    viewModel.searchProductResponse!.productResult!
                                    .products![index].sku !=
                                null &&
                            viewModel.searchProductResponse!.productResult!
                                .products![index].sku!.isNotEmpty
                        ? viewModel.searchProductResponse!.productResult!
                            .products![index].sku!
                        : '',
                    style: TextStyle(
                        color: const Color(0xff36393C),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Raleway',
                        fontSize: Globlas.deviceType == 'phone' ? 15 : 20)),
              ),
      ),
    );
  }

  // Add Product to truck
  addTruck(BuildContext context, SearchViewModel viewModel, int index) async {
    Navigator.pop(context);
    viewModel.searchFieldFocus.unfocus();

    ProductData productData =
        viewModel.searchProductResponse!.productResult!.products![index];

    ProductSubDetailModel data = await viewModel.getItemPrice(
      productData.id,
    );
    int userId = await AppUtil.getUserId();

    if (data != null) {
      productData.priceUntaxed = data.productResult!.product!.priceUntaxed;

      productData.priceTax = data.productResult != null
          ? double.parse(data.productResult!.product!.priceTax.toString())
          : double.parse(data.product!.priceTax!.toString());

      productData.deliveryEx = data.productResult!.delivery_ex;

      productData.priceTotal = data.productResult!.product!.priceTotal;
      productData.deliveryTax = data.productResult != null
          ? double.parse(data.productResult!.delivery_tax!.toString())
          : double.parse(data.delivery_tax!.toString());
      productData.qtyBreaks = data.productResult!.product!.qtyBreaks;
    }

    AppUtil.onAddToTruckClick(
        ProductData(
            userId: userId,
            description: productData.description,
            yashValue: productData.qtyBreaks != null &&
                    productData.qtyBreaks!.isNotEmpty
                ? productData.qtyBreaks![0].qty!.replaceAll(".0", "")
                : "1",
            extraImages: productData.extraImages,
            id: productData.id,
            isFav: productData.isFav,
            mainImageUrl: productData.mainImageUrl,
            name: productData.name,
            price:
                productData.price != null ? productData.price.toString() : "",
            priceByQty: productData.priceByQty.toString(),
            priceDelivery: productData.priceDelivery != null
                ? productData.priceDelivery
                : 0,
            priceTax: productData.priceTax,
            priceTotal:
                productData.qtyBreaks == null || productData.qtyBreaks!.isEmpty
                    ? productData.priceTotal
                    : productData.qtyBreaks![0].price,
            priceUntaxed: productData.priceUntaxed,
            qtyBreaks: productData.qtyBreaks,
            saleUom: productData.saleUom,
            sku: productData.sku,
            deliveryEx: data.productResult!.delivery_ex,
            deliveryInc: productData.deliveryInc,
            deliveryTax: productData.deliveryTax),
        false,
        viewModel);
  }

  Widget canacelIcon(SearchViewModel viewModel, int index) {
    return InkWell(
      child: Container(
        height: 20.0,
        width: 20,
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: const Color(0xff36393C)),
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(
              Radius.circular(7.0),
            )),
        child: Container(
            child: const Center(
                child: Icon(
          PowaGroupIcon.cross,
          size: 20,
          color: Color(0xff36393C),
        ))),
      ),
      onTap: () {
        viewModel.delete(viewModel.searchList[index]);
      },
    );
  }

  void addToJobList(
      BuildContext context, SearchViewModel viewModel, int index) async {
    ProductData productData =
        viewModel.searchProductResponse!.productResult!.products![index];

    ProductSubDetailModel data = await viewModel.getItemPrice(
      productData.id,
    );

    if (data != null) {
      productData.priceUntaxed = data.productResult!.product!.priceUntaxed;

      productData.priceTax = data.productResult != null
          ? double.parse(data.productResult!.product!.priceTax.toString())
          : double.parse(data.product!.priceTax!.toString());

      productData.deliveryEx = data.productResult!.delivery_ex;

      productData.priceTotal = data.productResult!.product!.priceTotal;
      productData.deliveryTax = data.productResult != null
          ? double.parse(data.productResult!.delivery_tax!.toString())
          : double.parse(data.delivery_tax!.toString());
      productData.qtyBreaks = data.productResult!.product!.qtyBreaks;
    }

    Navigator.pop(context);
    viewModel.searchFieldFocus.unfocus();
    viewModel.clickForJob(ProductData(
        description: productData.description,
        yashValue:
            productData.qtyBreaks != null && productData.qtyBreaks!.isNotEmpty
                ? productData.qtyBreaks![0].qty!.replaceAll(".0", "")
                : "1",
        extraImages: productData.extraImages,
        id: productData.id,
        isFav: productData.isFav,
        mainImageUrl: productData.mainImageUrl,
        name: productData.name,
        price: productData.price != null ? productData.price.toString() : "",
        priceByQty: productData.priceByQty.toString(),
        priceDelivery:
            productData.priceDelivery != null ? productData.priceDelivery : 0,
        priceTax: productData.priceTax,
        priceTotal:
            productData.qtyBreaks == null || productData.qtyBreaks!.isEmpty
                ? productData.priceTotal
                : productData.qtyBreaks![0].price,
        priceUntaxed: productData.priceUntaxed,
        qtyBreaks: productData.qtyBreaks,
        saleUom: productData.saleUom,
        sku: productData.sku,
        deliveryEx: productData.deliveryEx,
        deliveryInc: productData.deliveryInc,
        deliveryTax: productData.deliveryTax));
  }
}

//return image of list  contant
Widget image(SearchViewModel viewModel, int index) => ClipRRect(
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
                viewModel.searchProductResponse!.productResult!.products![index]
                    .mainImageUrl!,
            fit: BoxFit.cover,
            width: 60.h,
            height: 60.h,
            errorWidget: ((context, url, error) {
              return Image.asset(
                'assets/icon/dummy.png',
                width: 60.h,
                height: 60.h,
                fit: BoxFit.cover,
              );
            }),
          ));

Widget icon(SearchViewModel viewModel) => InkWell(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
          height: 22.h,
          width: 22.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xff858D93),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(7.r),
          ),
          child: Icon(PowaGroupIcon.cross,
              color: const Color(0XFF858D93), size: 20.h),
        ),
      ),
      onTap: () {
        viewModel.getSearchLocaldata();
      },
    );
