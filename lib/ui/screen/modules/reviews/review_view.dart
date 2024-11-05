import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/network_error%20widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/review_model.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_model.dart';
import 'package:powagroup/ui/screen/modules/reviews/review_view_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:readmore/readmore.dart';
import 'package:stacked/stacked.dart';

class CustomerReviewView extends StatefulWidget {
  ProductDetailsData? productObj;

  CustomerReviewView({
    Key? key,
    this.productObj,
  }) : super(key: key);

  @override
  State<CustomerReviewView> createState() => _CustomerReviewViewState();
}

class _CustomerReviewViewState extends State<CustomerReviewView>
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
    var key;
    return ViewModelBuilder<ReviewViewModel>.reactive(
      viewModelBuilder: () => ReviewViewModel(),
      //onDispose: (viewModel) => viewModel.controller.dispose(),
      onViewModelReady: (viewModel) async {
        viewModel.controller.addListener(viewModel.onScroll);
        bool isConnected = await AppUtil.checkNetwork();
        if (isConnected != null && isConnected) {
          // viewModel.getCustomerReviews(viewModel.offset, false);
          if (widget.productObj != null && widget.productObj!.id != null) {
            viewModel.productId = widget.productObj!.id;
            viewModel.getCustomerReviews(viewModel.offset, false);
          }
        }

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
              title: 'Comments',
              backIcon: IconButton(
                padding: const EdgeInsets.only(left: 5),
                icon: Icon(
                  PowaGroupIcon.back,
                  size: 24.h,
                  color: const Color(0xff36393C),
                ),
                onPressed: () {
                  // viewModel.navigationService.back();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          backgroundColor: const Color(0xffFFFFFF),
          body: !viewModel.isAPIError
              ? OfflineBuilder(
                  connectivityBuilder: (BuildContext context,
                      ConnectivityResult connectivity, Widget child) {
                    final bool connected =
                        connectivity != ConnectivityResult.none;
                    if (connected) {
                      if (!viewModel.isBusy &&
                          viewModel.commentsList.isNotEmpty) {
                        return parentWidget(viewModel);
                      } else {
                        // if (!viewModel.isAlreadyCalled) {
                        //   viewModel.getCustomerReviews(
                        //       viewModel.productId, viewModel.offset, false);
                        // }
                        // if (viewModel.currentPage > 0) {
                        //   viewModel.getCustomerReviews(widget.productObj!.id,
                        //       viewModel.currentPage, viewModel.itemsPerPage);
                        // }
                        // viewModel.getCustomerReviews(widget.productObj!.id,
                        //     viewModel.currentPage, viewModel.itemsPerPage);
                      }
                      return child;
                    } else if (!connected) {
                      if (!viewModel.isLocalDBAlreadyCalledForCustomerReview) {
                        viewModel
                            .getLocalDataListComments(widget.productObj!.id);
                      }
                      // if (viewModel.commentsList.isEmpty &&
                      //     viewModel.commentsList.length == 0) {
                      //   return NetworkError(
                      //     content: 'Network Error',
                      //     subContant: 'The network connection is lost',
                      //     icon: 'assets/icon/mobile_network_error.png',
                      //     viewModel: viewModel,
                      //   );
                      // }
                      else {
                        return parentWidget(viewModel);
                      }
                    }
                    return child;
                  },
                  builder: ((context) {
                    return parentWidget(viewModel);
                  }),
                  child: child,
                )
              : NetworkError(
                  content: 'Comments Not Found!!',
                  subContant: 'No data, Please try again later.',
                  icon: 'assets/icon/network_error.png',
                  viewModel: viewModel,
                )),
    );
  }

//Return Body widget
  Widget parentWidget(ReviewViewModel viewModel) {
    return commentSectionWidget(viewModel);
  }

  // Return Comment Section Widget
  Widget commentSectionWidget(ReviewViewModel viewModel) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      controller: viewModel.controller,
      separatorBuilder: (context, int) {
        return const Divider(
          height: 1,
          color: Color(0xff858D93),
        );
      },
      itemCount: viewModel.isBusy
          ? 10
          : viewModel.commentsList != null && viewModel.commentsList.isNotEmpty
              ? viewModel.hasMore
                  ? viewModel.commentsList.length + 1
                  : viewModel.commentsList.length
              : 0,
      itemBuilder: (context, index) {
        if (viewModel.offset != 0) {
          if (index >= viewModel.commentsList.length) {
            return Center(
              child: Container(
                padding: const EdgeInsets.only(top: 32, bottom: 32),
                child: const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey)),
                ),
              ),
            );
          }
        } else {
          return userComments(viewModel, index, viewModel.commentsList);
        }

        return userComments(viewModel, index, viewModel.commentsList);
      },
    );
  }

  userComments(ReviewViewModel viewModel, int index,
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
                              customerReviewLis[index].title!.isEmpty
                                  ? 'Rosie Elford'
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
                                    ? customerReviewLis[index].rating! <= 2
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
                          AppUtil.getDate2(customerReviewLis[index].date != null
                              ? customerReviewLis[index].date.toString()
                              : ''),
                          // customerReviewLis[index].date! == null
                          //     ? ''
                          //     : customerReviewLis[index].date.toString(),
                          // 'Published on ',

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
          viewModel.isBusy
              ? ShimmerLoading(
                  isLoading: true,
                  child: Container(
                    width: double.infinity,
                    height: 12.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[100],
                    ),
                  ))
              : Padding(
                  padding: EdgeInsets.only(
                    left: Globlas.deviceType == "phone" ? 30.h : 40.h,
                  ),
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
}
