import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/helper_widget/double_icon_widget.dart';
import 'package:powagroup/helper_widget/end_quantity_widget.dart';
import 'package:powagroup/helper_widget/network_error%20widget.dart';
import 'package:powagroup/helper_widget/popup_menu_widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/services/api_client.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/review_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/product_detail_view_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:readmore/readmore.dart';
import 'package:stacked/stacked.dart';
import '../../../../util/validator.dart';
import '../favorite_module/all_product_module/favorite_view.dart';

class ProductDetialView extends StatefulWidget {
  ProductData? productObj;
  bool? fromFav;
  // dynamic productObj;

  ProductDetialView({Key? key, this.productObj, this.fromFav})
      : super(key: key);

  @override
  State<ProductDetialView> createState() => _ProductDetialViewState();
}

class _ProductDetialViewState extends State<ProductDetialView>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductDetailViewModel>.reactive(
      viewModelBuilder: () => ProductDetailViewModel(),
      onViewModelReady: (viewModel) async {
        viewModel.itemCount = await AppUtil.getCartProductLength();
        viewModel.showPricing = await AppUtil.getShowPricing();
        viewModel.subCategoryId = widget.productObj!.id!;

        // bool isConnected = await AppUtil.checkNetwork();
        // if (isConnected != null && isConnected) {
        //   if (widget.productObj != null && widget.productObj!.id != null) {
        //     viewModel.subCategoryId = widget.productObj!.id!;

        //     viewModel.getTopComments(
        //         widget.productObj!.id, viewModel.itemPerPage, true);
        //   }
        // }

        _controller = AnimationController(
          vsync: this,
          duration: const Duration(
            milliseconds: 500,
          ),
          lowerBound: 0.0,
          upperBound: 0.1,
        );
      },
      builder: (context, viewModel, child) => Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.h),
            child: AppBarWidget(
              title: 'View Details',
              backIcon: IconButton(
                padding: const EdgeInsets.only(left: 5),
                icon: Icon(
                  PowaGroupIcon.back,
                  size: 24.h,
                  color: const Color(0xff36393C),
                ),
                onPressed: () {
                  //viewModel.navigationService.back();
                  // lkjkljhlk
                  // Navigator.pop(context);
                  if (widget.fromFav == true) {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: FavoriteView(),
                    );
                  } else {
                    Navigator.pop(context);
                  }
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
          body: !viewModel.isAPIError
              ? OfflineBuilder(
                  connectivityBuilder: (BuildContext context,
                      ConnectivityResult connectivity, Widget child) {
                    final bool connected =
                        connectivity != ConnectivityResult.none;
                    if (connected) {
                      if (!viewModel.isBusy &&
                          viewModel.productDetails.id != null) {
                        return parentWidget(viewModel, context);
                      } else {
                        if (!viewModel.isAlreadyCalled) {
                          if (widget.productObj != null &&
                              widget.productObj!.id != null) {
                            // viewModel.getMethodForQueryParamsIn();
                            viewModel.getProductDeatilsItems(false);
                            // viewModel.getProductDeatilsItemsOnlyPrice(false);
                          }

                          viewModel.getTopComments(widget.productObj!.id,
                              viewModel.itemPerPage, false);
                        }
                      }
                      return child;
                    } else if (!connected) {
                      if (!viewModel.isLocalDBAlreadyCalled ||
                          !viewModel.isLocalDBAlreadyCalledForCustomerReview) {
                        viewModel.getLocalDataList(widget.productObj!.id);
                        viewModel
                            .getLocalDataListComments(widget.productObj!.id);
                      }
                      if (viewModel.productDetails == null ||
                          viewModel.userReviews.length == 0) {
                        return NetworkError(
                          content: 'Network Error',
                          subContant: 'The network connection is lost',
                          icon: 'assets/icon/mobile_network_error.png',
                          viewModel: viewModel,
                        );
                      } else {
                        return parentWidget(viewModel, context);
                      }
                    }
                    return child;
                  },
                  builder: ((context) {
                    return parentWidget(viewModel, context);
                  }),
                  child: child,
                )
              : NetworkError(
                  content: 'Product Details Not Found!!',
                  subContant: 'No data, Please try again later.',
                  icon: 'assets/icon/network_error.png',
                  viewModel: viewModel,
                )),
    );
  }

//Return Body widget
  Widget parentWidget(ProductDetailViewModel viewModel, BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 60),
      children: [
        productImageWidget(viewModel),
        const SizedBox(
          height: 10,
        ),
        productDetailBox(viewModel),
        const SizedBox(
          height: 10,
        ),
        commentSectionQuantity(
            viewModel.productDetails.qtyBreaks,
            viewModel.productDetails.saleUom,
            viewModel,
            'Add To Truck',
            'ProductDetialView',
            context),
        const SizedBox(
          height: 10,
        ),
        viewModel.productDetails.description == "<p><br></p>"
            ? Container()
            : productDescriptionBox(viewModel),
        viewModel.productDetails.alternativeProducts != null &&
                viewModel.productDetails.alternativeProducts!.length != 0
            ? const SizedBox(
                height: 20,
              )
            : const SizedBox(
                height: 10,
              ),
        alterNativeProductWidget(viewModel),
        viewModel.productDetails.alternativeProducts != null &&
                viewModel.productDetails.alternativeProducts!.length != 0
            ? const SizedBox(
                height: 20,
              )
            : Container(),
        accessoriesProductWidget(viewModel),
        viewModel.productDetails.accessoryProducts != null &&
                viewModel.productDetails.accessoryProducts!.length != 0
            ? const SizedBox(
                height: 20,
              )
            : Container(),
        commentSectionWidget(viewModel),
      ],
    );
  }

  // Return Comment Section Widget
  Widget commentSectionWidget(ProductDetailViewModel viewModel) {
    return Container(
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
                viewModel.isBusy || viewModel.productDetails.id == null
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
                        'Leave Comment',
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
                            child: viewModel.isBusy ||
                                    viewModel.productDetails.id == null
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
                                          viewModel.productDetails, context);
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
                                viewModel.onSeeAllClick(
                                    viewModel.productDetails, context);
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
              itemCount: viewModel.isBusy || widget.productObj!.id != null
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
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: RatingBar(
                initialRating: viewModel.rate.toDouble(),
                itemSize: 20,
                minRating: viewModel.rate.toDouble(),
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                    full: const Icon(Icons.star, color: Color(0xffFD521C)),
                    half: const Icon(
                      Icons.star_half,
                      color: Color(0xffFD521C),
                    ),
                    empty: const Icon(
                      Icons.star_outline,
                      color: Colors.grey,
                    )),
                onRatingUpdate: (rating) {
                  setState(() {
                    viewModel.rate = rating.toInt();

                    viewModel.notifyListeners();
                  });
                }),
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

                  viewModel.onSendButtonClick(
                      widget.productObj!.id, viewModel.rate);
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

  // Return Accsssories Product Widget
  Widget accessoriesProductWidget(ProductDetailViewModel viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewModel.productDetails.accessoryProducts != null &&
                viewModel.productDetails.accessoryProducts!.length != 0
            ? headingWidget("Accessories products")
            : Container(),
        viewModel.productDetails.accessoryProducts != null &&
                viewModel.productDetails.accessoryProducts!.length != 0
            ? const SizedBox(
                height: 16,
              )
            : Container(),
        viewModel.productDetails.accessoryProducts != null &&
                viewModel.productDetails.accessoryProducts!.length != 0
            ? productGridWidget(viewModel)
            : Container(),
      ],
    );
  }

  // Return Alternative Product Widget
  Widget alterNativeProductWidget(ProductDetailViewModel viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewModel.productDetails.alternativeProducts != null &&
                viewModel.productDetails.alternativeProducts!.length != 0
            //viewModel.isAlertnativeListEmpty == false
            ? headingWidget("Alternative product")
            : Container(),
        viewModel.productDetails.alternativeProducts != null &&
                viewModel.productDetails.alternativeProducts!.length != 0
            ? const SizedBox(
                height: 16,
              )
            : Container(),
        viewModel.productDetails.alternativeProducts != null &&
                viewModel.productDetails.alternativeProducts!.length != 0
            ? productGridWidgetforAlternative(viewModel)
            : Container(),
      ],
    );
  }

  // Return Product Grid Widget
  Widget productGridWidget(ProductDetailViewModel viewModel) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: Globlas.deviceType == "phone" ? 180.h : 220.h,
            crossAxisCount: 2,
            crossAxisSpacing: 9.h,
            mainAxisSpacing: 9.h),
        itemCount: viewModel.isBusy
            ? 2
            : viewModel.productDetails.accessoryProducts != null
                ? viewModel.productDetails.accessoryProducts!.length
                : 0,
        itemBuilder: (BuildContext context, int index) {
          return productItem(viewModel, index);
        });
  }

  // Return Product Item Widget
  Widget productItem(ProductDetailViewModel viewModel, int index) {
    return Container(
      padding: EdgeInsets.all(9.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.white,
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          PopupWidget(
            productData: viewModel.getProduct(),
            id: viewModel.getProduct().id.toString(),
            viewModel: viewModel,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                viewModel.isBusy ||
                        viewModel.productDetails.accessoryProducts != null &&
                            viewModel.productDetails.accessoryProducts!.isEmpty
                    ? ShimmerLoading(
                        isLoading: true,
                        child: Container(
                          width: 95.w,
                          height: 95.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[100],
                          ),
                        ))
                    : CachedNetworkImage(
                        imageUrl: ApiClient.BASE_URL +
                            viewModel.productDetails.accessoryProducts![index]
                                .mainImageUrl
                                .toString(),
                        fit: BoxFit.cover,
                        width: 83.w,
                        height: 89.h,
                        errorWidget: ((context, url, error) {
                          return Image.asset(
                            'assets/icon/dummy.png',
                            width: 90.w,
                            height: 100.h,
                            fit: BoxFit.cover,
                          );
                        }),
                      ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: viewModel.isBusy
                      ? ShimmerLoading(
                          isLoading: true,
                          child: Container(
                            width: 95.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[100],
                            ),
                          ))
                      : Text(
                          viewModel.productDetails.accessoryProducts![index]
                                          .name !=
                                      null &&
                                  viewModel
                                      .productDetails
                                      .accessoryProducts![index]
                                      .name!
                                      .isNotEmpty
                              ? viewModel.productDetails
                                  .accessoryProducts![index].name!
                                  .toString()
                              : '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: Globlas.deviceType == "phone" ? 13 : 23,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.33,
                              color: const Color(0xff36393C)),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Return Heading Widget
  Widget headingWidget(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: Globlas.deviceType == "phone" ? 16 : 26,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.33,
                color: const Color(0xff1B1D1E)),
          ),
        ),
        Text(
          'See All',
          style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: Globlas.deviceType == "phone" ? 12 : 22,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.33,
              color: const Color(0xff36393C)),
        ),
        const SizedBox(
          width: 5,
        ),
        doubleIcon()
      ],
    );
  }

  // Return Product Description Box
  Widget productDescriptionBox(ProductDetailViewModel viewModel) {
    return Container(
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
          viewModel.isBusy || viewModel.productDetails.id == null
              ? Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 10),
                  child: ShimmerLoading(
                      isLoading: true,
                      child: Container(
                        width: 60.w,
                        height: 9.h,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10)),
                      )),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    'Description',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: Globlas.deviceType == "phone" ? 18 : 28,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.33,
                        color: const Color(0xff1B1D1E)),
                  ),
                ),
          viewModel.isBusy || viewModel.productDetails.id == null
              ? ShimmerLoading(
                  isLoading: true,
                  child: Container(
                    width: double.infinity,
                    height: 150.h,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10)),
                  ))
              : Html(
                  data: viewModel.productDetails.description != null &&
                          viewModel.productDetails.description!.isNotEmpty
                      ? viewModel.productDetails.description!
                      : '',
                  shrinkWrap: true,
                  extensions: [
                    TagExtension(
                      tagsToExtend: {"flutter"},
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
    );
  }

  // Return Product Details box
  Widget productDetailBox(ProductDetailViewModel viewModel) {
    return Container(
      padding:
          EdgeInsets.only(left: 16.h, right: 20.h, top: 16.h, bottom: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: viewModel.isBusy || viewModel.productDetails.id == null
          ? ShimmerLoading(
              isLoading: true,
              child: Container(
                width: 155.h,
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                ),
              ))
          : Stack(alignment: Alignment.topRight, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: Text(
                            viewModel.productDetails.name != null &&
                                    viewModel.productDetails.name!.isNotEmpty
                                ? viewModel.productDetails.name
                                    .toString()
                                    .replaceAll("<p><b><br></b></p><p>", "")
                                    .replaceAll("<p><br></p>", "")
                                    .replaceAll("<p><b><br></b></p><p>", "")
                                : '',
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize:
                                    Globlas.deviceType == "phone" ? 17 : 27,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.33,
                                color: const Color(0xff1B1D1E)),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viewModel.productDetails.sku != null &&
                                      viewModel.productDetails.sku!.isNotEmpty
                                  ? 'Code : ${viewModel.productDetails.sku!}'
                                  : '',
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize:
                                      Globlas.deviceType == "phone" ? 14 : 24,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.33,
                                  color: const Color(0xff36393C)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            viewModel.showPricing
                                ? viewModel.isPriceLoading
                                    ? ShimmerLoading(
                                        isLoading: true,
                                        child: Container(
                                          width: 100,
                                          height: 15,
                                          decoration: BoxDecoration(
                                              color: Color(0xffF2F2F2),
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                        ))
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: RichText(
                                          text: TextSpan(
                                              text: viewModel.productDetails
                                                          .priceTotal !=
                                                      null
                                                  ? '\$${viewModel.productDetails.priceTotal!.toStringAsFixed(2)}'
                                                  : '',
                                              style: TextStyle(
                                                fontFamily: 'Raleway',
                                                letterSpacing: -0.33,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
                                                color: const Color(0xff33A3E4),
                                                fontSize: Globlas.deviceType ==
                                                        "phone"
                                                    ? 14
                                                    : 24,
                                              ),
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
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        letterSpacing: -0.33,
                                                        color: const Color(
                                                            0xff36393C)))
                                              ]),
                                        ),
                                      )
                                : Container(
                                    height: 0,
                                    width: 0,
                                  ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                viewModel.isBusy
                                    ? Container()
                                    : Text(
                                        // "${viewModel.productDetails.totalReviewCount.toString()} Reviews",
                                        viewModel.productDetails
                                                    .totalReviewCount !=
                                                null
                                            ? '${viewModel.productDetails.totalReviewCount} Reviews'
                                            : '',
                                        style: TextStyle(
                                            fontFamily: 'Poppins-Regular',
                                            fontSize:
                                                Globlas.deviceType == "phone"
                                                    ? 12
                                                    : 22,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: -0.33,
                                            color: const Color(0xff858D93)),
                                      ),
                                const SizedBox(
                                  height: 5,
                                ),
                                viewModel.isBusy
                                    ? Container()
                                    : RatingBar(
                                        ignoreGestures: true,
                                        initialRating:
                                            viewModel.productDetails == null ||
                                                    viewModel.productDetails
                                                            .reviewAvg ==
                                                        null
                                                ? 0
                                                : viewModel
                                                    .productDetails.reviewAvg!,
                                        itemSize: 20,
                                        minRating: viewModel.rate.toDouble(),
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        // itemCount: viewModel.productDetails
                                        //             .reviewAvg! ==
                                        //         Null
                                        //     ? 0
                                        //     : viewModel
                                        //         .productDetails.reviewAvg!
                                        //         .toInt(),
                                        ratingWidget: RatingWidget(
                                            full: const Icon(Icons.star,
                                                color: Color(0xffFD521C)),
                                            half: const Icon(
                                              Icons.star_half,
                                              color: Color(0xffFD521C),
                                            ),
                                            empty: const Icon(
                                              Icons.star_outline,
                                              color: Colors.grey,
                                            )),
                                        onRatingUpdate: (rating) {
                                          setState(() {
                                            viewModel.rate1 = viewModel
                                                .productDetails.reviewAvg!;

                                            viewModel.notifyListeners();
                                          });
                                        }),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              PopupWidget(
                productData: viewModel.getProduct(),
                id: viewModel.getProduct().id.toString(),
                viewModel: viewModel,
              )
            ]),
    );
  }

  // Return Product Image View
  Widget productImageWidget(ProductDetailViewModel viewModel) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.transparent),
      child: viewModel.isBusy || viewModel.productDetails.id == null
          ? ShimmerLoading(
              isLoading: true,
              child: Container(
                width: double.infinity,
                height: 220.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                ),
              ))
          : viewModel.productDetails.extraImages!.isNotEmpty
              ? viewModel.productDetails.extraImages!.length == 1
                  ? Hero(
                      tag: viewModel.productDetails.name.toString(),
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl: ApiClient.BASE_URL +
                                viewModel.productDetails.mainImageUrl
                                    .toString(),
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: 220,
                            errorWidget: ((context, url, error) {
                              return Image.asset(
                                'assets/icon/dummy.png',
                                width: double.infinity,
                                height: 220,
                                fit: BoxFit.cover,
                              );
                            }),
                          )))
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 3.0),
                          child: InkWell(
                            child: const Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.black,
                              size: 18,
                            ),
                            onTap: () {
                              viewModel.carouselController.previousPage();
                            },
                          ),
                        ),
                        Expanded(
                          child: CarouselSlider(
                            carouselController: viewModel
                                .carouselController, // Give the controller
                            options: CarouselOptions(
                              height: 220,

                              padEnds: false,
                              autoPlay: false,
                              enableInfiniteScroll: true,
                              disableCenter: false,
                              viewportFraction: 1,
                              // aspectRatio: 5.h,
                              reverse: false,
                              enlargeCenterPage: true,
                              enlargeStrategy: CenterPageEnlargeStrategy.height,

                              // autoPlay: true,
                            ),
                            items:
                                viewModel.featuredImages.map((featuredImage) {
                              return ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  child: CachedNetworkImage(
                                    imageUrl: ApiClient.BASE_URL +
                                        viewModel.productDetails.mainImageUrl
                                            .toString(),
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    height: 220,
                                    errorWidget: ((context, url, error) {
                                      return Image.asset(
                                        'assets/icon/dummy.png',
                                        width: double.infinity,
                                        height: 220,
                                        fit: BoxFit.cover,
                                      );
                                    }),
                                  ));

                              // );
                            }).toList(),
                          ),
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 18,
                            ),
                          ),
                          onTap: () {
                            viewModel.carouselController.nextPage();
                          },
                        ),
                      ],
                    )
              : ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl: ApiClient.BASE_URL +
                        viewModel.productDetails.mainImageUrl.toString(),
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: 220,
                    errorWidget: ((context, url, error) {
                      return Image.asset(
                        'assets/icon/dummy.png',
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      );
                    }),
                  )),
    );
  }

  userComments(ProductDetailViewModel viewModel, int index,
      List<UserReview> customerReviewLis) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              viewModel.isBusy || viewModel.productDetails.id == null
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
                        customerReviewLis[index].reviewedBy != null &&
                                customerReviewLis[index].reviewedBy!.name ==
                                    null
                            ? ''
                            : customerReviewLis[index]
                                .reviewedBy!
                                .name![0]
                                .toUpperCase(),
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
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  viewModel.isBusy || viewModel.productDetails.id == null
                      ? ShimmerLoading(
                          isLoading: true,
                          child: Container(
                            width: 120.w,
                            height: 10.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[100],
                            ),
                          ))
                      : Row(
                          children: [
                            Text(
                              customerReviewLis[index].title!.isEmpty
                                  ? ''
                                  : customerReviewLis[index].title.toString(),
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: customerReviewLis.isNotEmpty &&
                                        customerReviewLis[index].rating! > 0
                                    ? customerReviewLis[index].rating! > 0 &&
                                            customerReviewLis[index].rating! <=
                                                2
                                        ? const Color(0xffD60505)
                                        : customerReviewLis[index].rating! == 3
                                            ? const Color(0xffFF9900)
                                            : const Color(0xff407937)
                                    : Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 5, top: 1),
                                    child: Text(
                                      customerReviewLis[index].rating! == null
                                          ? ''
                                          : customerReviewLis[index]
                                              .rating
                                              .toString(),
                                      style: TextStyle(
                                          fontFamily: 'Inter-Medium',
                                          fontSize:
                                              Globlas.deviceType == "phone"
                                                  ? 14
                                                  : 18,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: -0.33,
                                          color: Colors.white),
                                    ),
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
                  viewModel.isBusy || viewModel.productDetails.id == null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: ShimmerLoading(
                              isLoading: true,
                              child: Container(
                                width: 170.w,
                                height: 10.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[100],
                                ),
                              )),
                        )
                      : Text(
                          AppUtil.getDate2(customerReviewLis[index].date != null
                              ? customerReviewLis[index].date.toString()
                              : ''),
                          // 'Published on August 11th 2022, 11:00 PM',
                          style: TextStyle(
                              fontFamily: 'Inter-Regular',
                              fontSize: Globlas.deviceType == "phone" ? 12 : 22,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.33,
                              color: const Color(0xff858D93)),
                        ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          viewModel.isBusy || viewModel.productDetails.id == null
              ? ShimmerLoading(
                  isLoading: true,
                  child: Container(
                    width: double.infinity,
                    height: 10.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[100],
                    ),
                  ))
              : Padding(
                  padding: EdgeInsets.only(
                      left: Globlas.deviceType == "phone" ? 30.h : 40.h),
                  child: ReadMoreText(
                    customerReviewLis[index].review != null &&
                            customerReviewLis[index].review!.isNotEmpty
                        ? customerReviewLis[index].review.toString()
                        : '',
                    trimLines: 2,
                    colorClickableText: Colors.black,
                    trimMode: TrimMode.Line,
                    style: TextStyle(
                        fontFamily: 'Raleway-Mixed',
                        fontSize: Globlas.deviceType == "phone" ? 13 : 23,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.33,
                        color: const Color(0xff36393C)),
                    trimCollapsedText: 'Read more',
                    trimExpandedText: 'Show less',
                    lessStyle: TextStyle(
                        fontSize: Globlas.deviceType == "phone" ? 13 : 19,
                        fontWeight: FontWeight.bold),
                    moreStyle: TextStyle(
                        fontSize: Globlas.deviceType == "phone" ? 13 : 19,
                        fontWeight: FontWeight.bold),
                  ),
                ),
        ],
      ),
    );
  }

  productGridWidgetforAlternative(ProductDetailViewModel viewModel) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: Globlas.deviceType == "phone" ? 180.h : 220.h,
            crossAxisCount: 2,
            crossAxisSpacing: 9.h,
            mainAxisSpacing: 9.h),
        itemCount: viewModel.isBusy
            ? 2
            : viewModel.productDetails.alternativeProducts != null
                ? viewModel.productDetails.alternativeProducts!.length
                : 0,
        itemBuilder: (BuildContext context, int index) {
          return productItemForAlternative(viewModel, index);
        });
  }

  // Return Product Item Widget
  Widget productItemForAlternative(
      ProductDetailViewModel viewModel, int index) {
    return Container(
      padding: EdgeInsets.all(9.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.white,
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          PopupWidget(
            productData: viewModel.getProduct(),
            id: viewModel.getProduct().id.toString(),
            viewModel: viewModel,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                viewModel.isBusy ||
                        viewModel.productDetails.alternativeProducts != null &&
                            viewModel
                                .productDetails.alternativeProducts!.isEmpty
                    ? ShimmerLoading(
                        isLoading: true,
                        child: Container(
                          width: 95.w,
                          height: 95.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[100],
                          ),
                        ))
                    : CachedNetworkImage(
                        imageUrl: ApiClient.BASE_URL +
                            viewModel.productDetails.alternativeProducts![index]
                                .mainImageUrl
                                .toString(),
                        fit: BoxFit.cover,
                        width: 83.w,
                        height: 89.h,
                        errorWidget: ((context, url, error) {
                          return Image.asset(
                            'assets/icon/dummy.png',
                            width: 90.w,
                            height: 100.h,
                            fit: BoxFit.cover,
                          );
                        }),
                      ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: viewModel.isBusy
                      ? ShimmerLoading(
                          isLoading: true,
                          child: Container(
                            width: 95.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[100],
                            ),
                          ))
                      : Text(
                          viewModel.productDetails.alternativeProducts![index]
                                          .name !=
                                      null &&
                                  viewModel
                                      .productDetails
                                      .alternativeProducts![index]
                                      .name!
                                      .isNotEmpty
                              ? viewModel.productDetails
                                  .alternativeProducts![index].name!
                              : '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: Globlas.deviceType == "phone" ? 13 : 23,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.33,
                              color: const Color(0xff36393C)),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
