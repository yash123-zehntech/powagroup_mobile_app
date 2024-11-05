import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/services/api_client.dart';
import 'package:powagroup/services/globals.dart';
import 'package:powagroup/ui/screen/modules/blog_module/blog_detail_view_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/blog_detail.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/projects.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';

class ProjectDetailView extends StatefulWidget {
  Project? project;

  ProjectDetailView({
    Key? key,
    this.project,
  }) : super(key: key);

  @override
  State<ProjectDetailView> createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<ProjectDetailView>
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
    return ViewModelBuilder<BlogDetailViewModel>.reactive(
      viewModelBuilder: () => BlogDetailViewModel(),
      onViewModelReady: (viewModel) async {
        // viewModel.itemCount = await AppUtil.getCartProductLength();
        // bool isConnected = await AppUtil.checkNetwork();
        // if (isConnected != null && isConnected) {
        //   if (widget.blogPost != null && widget.blogPost!.id != null) {
        //     viewModel.getBlogDetailPageItems(widget.blogPost!.id.toString());
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
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: parentWidget(viewModel)),
    );
  }

//Return Body widget
  Widget parentWidget(BlogDetailViewModel viewModel) {
    return ListView(
      children: [
        productDetailBox(viewModel),
        //titleWidget(viewModel),
        discriptionWidget(viewModel),
        //metaKeywordWidget(viewModel)
      ],
    );
  }

  // Return Product Details box
  Widget productDetailBox(BlogDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Wrap(children: [
        // viewModel.isBusy || viewModel.productDetails.id == null
        //     ? Padding(
        //         padding: const EdgeInsets.only(left: 8, bottom: 3, right: 8),
        //         child: ShimmerLoading(
        //             isLoading: true,
        //             child: Container(
        //               width: double.infinity,
        //               height: 200.h,
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(10),
        //                 color: Colors.grey[100],
        //               ),
        //             )),
        //       )
        //     :
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            // imageUrl:
            //     'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
            imageUrl: ApiClient.BASE_URL + widget.project!.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 190.h,
            errorWidget: ((context, url, error) {
              return Image.asset(
                'assets/icon/dummy.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              );
            }),
          ),
        ),
        // Container(
        //     width: double.infinity,
        //     height: 190.h,
        //     decoration: const BoxDecoration(
        //         color: Color(0xffFFFFFF),
        //         image: DecorationImage(
        //             image: AssetImage('assets/icon/product_image.png'),
        //             fit: BoxFit.fill),
        //         borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(10),
        //             topRight: Radius.circular(10))),
        //   ),
        const SizedBox(
          height: 9,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 13.0),
          child:
              // viewModel.isBusy || viewModel.productDetails.id == null
              //     ? Padding(
              //         padding: const EdgeInsets.only(left: 8, bottom: 3, right: 8),
              //         child: ShimmerLoading(
              //             isLoading: true,
              //             child: Container(
              //               width: 300.w,
              //               height: 13.h,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(10),
              //                 color: Colors.grey[100],
              //               ),
              //             )),
              //       )
              //     :
              Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Wrap(
              children: [
                Text(
                  widget.project!.name != null &&
                          widget.project!.name.isNotEmpty
                      ? widget.project!.name.toString()
                      : '',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: Globlas.deviceType == "phone" ? 18 : 28,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.33,
                      color: const Color(0xff1B1D1E)),
                ),
              ],
            ),
          ),
        ),
        // SizedBox(
        //   height: 8.h,
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 10.0),
        //   child:
        //   viewModel.isBusy || viewModel.productDetails.id == null
        //       ? Padding(
        //           padding: const EdgeInsets.only(left: 8, bottom: 3, right: 8),
        //           child: ShimmerLoading(
        //               isLoading: true,
        //               child: Container(
        //                 width: 200.w,
        //                 height: 13.h,
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(10),
        //                   color: Colors.grey[100],
        //                 ),
        //               )),
        //         )
        //       :
        //       Padding(
        //           padding: const EdgeInsets.only(left: 8, bottom: 3),
        //           child: Text(
        //             viewModel.productDetails.postDate != null &&
        //                     viewModel.productDetails.postDate!.isNotEmpty
        //                 ? AppUtil.getDate(viewModel.productDetails.postDate)
        //                 : '',
        //             style: TextStyle(
        //                 fontFamily: 'Raleway',
        //                 fontSize: Globlas.deviceType == "phone" ? 11 : 21,
        //                 fontStyle: FontStyle.normal,
        //                 fontWeight: FontWeight.w400,
        //                 letterSpacing: -0.33,
        //                 color: const Color(0xff36393C)),
        //           ),
        //         ),
        // ),
      ]),
    );
  }

  // Widget titleWidget(BlogDetailViewModel viewModel) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 16.0, top: 1),
  //     child: viewModel.isBusy || viewModel.productDetails.id == null
  //         ? Padding(
  //             padding: const EdgeInsets.only(left: 8, bottom: 3, right: 8),
  //             child: ShimmerLoading(
  //                 isLoading: true,
  //                 child: Container(
  //                   width: 200.w,
  //                   height: 13.h,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(10),
  //                     color: Colors.grey[100],
  //                   ),
  //                 )),
  //           )
  //         : Padding(
  //             padding: const EdgeInsets.only(left: 8, bottom: 3, right: 8),
  //             child: Text(
  //               viewModel.productDetails.metaTitle != null &&
  //                       viewModel.productDetails.metaTitle!.isNotEmpty
  //                   ? viewModel.productDetails.metaTitle.toString()
  //                   : '',
  //               style: TextStyle(
  //                   fontFamily: 'Raleway',
  //                   fontSize: Globlas.deviceType == "phone" ? 15 : 25,
  //                   fontStyle: FontStyle.normal,
  //                   fontWeight: FontWeight.w600,
  //                   letterSpacing: -0.33,
  //                   color: const Color(0xff1B1D1E)),
  //             ),
  //           ),
  //   );
  // }

  Widget discriptionWidget(BlogDetailViewModel viewModel) {
    return
        // viewModel.isBusy || viewModel.productDetails.id == null
        //     ? Padding(
        //         padding:
        //             const EdgeInsets.only(left: 24, bottom: 3, top: 5, right: 8),
        //         child: ShimmerLoading(
        //             isLoading: true,
        //             child: Container(
        //               width: 200.w,
        //               height: 13.h,
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(10),
        //                 color: Colors.grey[100],
        //               ),
        //             )),
        //       )
        //     :
        Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 3, top: 5, right: 8),
      child: Text(
        widget.project!.description != null &&
                widget.project!.description.isNotEmpty
            ? widget.project!.description.toString()
            : '',
        style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: Globlas.deviceType == "phone" ? 14 : 24,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.33,
            color: const Color(0xff1B1D1E)),
      ),
    );
  }

  // Widget metaKeywordWidget(BlogDetailViewModel viewModel) {
  //   return viewModel.isBusy || viewModel.productDetails.id == null
  //       ? Padding(
  //           padding:
  //               const EdgeInsets.only(left: 24, bottom: 3, top: 5, right: 8),
  //           child: ShimmerLoading(
  //               isLoading: true,
  //               child: Container(
  //                 width: 200.w,
  //                 height: 13.h,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   color: Colors.grey[100],
  //                 ),
  //               )),
  //         )
  //       : Padding(
  //           padding:
  //               const EdgeInsets.only(left: 24, bottom: 3, top: 5, right: 8),
  //           child: Text(
  //             viewModel.productDetails.metaKeywords != null &&
  //                     viewModel.productDetails.metaKeywords!.isNotEmpty
  //                 ? viewModel.productDetails.metaKeywords.toString()
  //                 : '',
  //             style: TextStyle(
  //                 fontFamily: 'Raleway',
  //                 fontSize: Globlas.deviceType == "phone" ? 13 : 23,
  //                 fontStyle: FontStyle.normal,
  //                 fontWeight: FontWeight.w500,
  //                 letterSpacing: -0.33,
  //                 color: const Color(0xff1B1D1E)),
  //           ),
  //         );
  // }
}
