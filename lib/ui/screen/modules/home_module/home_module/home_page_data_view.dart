import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/double_icon_widget.dart';
import 'package:powagroup/helper_widget/popup_menu_widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/services/api_client.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/home_page_data_module.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/blog_detail.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/home_option.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/projects.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/review_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/videos.dart';
import 'package:powagroup/util/constant.dart';
import 'package:readmore/readmore.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_category_module/response_model/product_categories_response.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../helper_widget/network_error widget.dart';

class HomePageDataView extends StatelessWidget {
  List<Category>? subCategoryList;
  HomePageDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomePageDataViewModel>.reactive(
      viewModelBuilder: () {
        return HomePageDataViewModel();
      },
      onViewModelReady: (viewModel) async {
        viewModel.getLoginToken();
        viewModel.homeOptionList.add(HomeOption(
            'Get your Powagroup Account!', 'Get personalised Pricing etc. '));
        viewModel.homeOptionList
            .add(HomeOption('REQUEST YOUR CATALOGUE TODAY!', ''));
        viewModel.homeOptionList
            .add(HomeOption('GET A FREE POWAGROUP BEANIE', ''));
        bool isConnected = await AppUtil.checkNetwork();
        if (isConnected != null && isConnected) {
          viewModel.getContentSlider(true);
          viewModel.getProductCategories(true);
          viewModel.getBlogsDetails(true);
          viewModel.getVideos(true);
          viewModel.getDeliveyMethodsItems(true);
        }

        // viewModel.getCustomerReviews();
        // if (subCategoryList != null){

        // }
      },
      builder: (context, viewModel, child) => Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: AppBarWidget(
              title: '',
              backIcon: null,
              actionIcon: IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                padding: EdgeInsets.only(right: 20.h),
                icon: Icon(
                  PowaGroupIcon.search_icon,
                  size: 24.h,
                  color: const Color(0xff36393C),
                ),
                onPressed: () {
                  viewModel.onSearchIconClick(context);
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
                          viewModel.categoriesList.isNotEmpty &&
                          viewModel.sliderContentList.isNotEmpty) {
                        return bodyWidget(viewModel, context);
                      } else {
                        if (!viewModel.isAlreadyCalled) {
                          // if (viewModel.sliderContentList.isEmpty) {
                          //   viewModel.getContentSlider(false);
                          // }

                          // viewModel.categoriesList = viewModel.categoriesList
                          //     .where((element) => element.parentId == false)
                          //     .toList();

                          // if (viewModel.categoriesList.isEmpty) {
                          //   viewModel.getProductCategories(false);
                          // }

                          // // viewModel.getProjects();
                          // viewModel.getBlogsDetails();

                          // viewModel.getVideos();

                          // viewModel.getCustomerReviews();
                          // viewModel.getNewProducts();
                        }
                      }
                      return child;
                    } else if (!connected) {
                      if (!viewModel.isLocalDBAlreadyCalled ||
                          !viewModel.isLocalforblocAlreadyCalled ||
                          !viewModel.isLocalforReviewAlreadyCalled ||
                          !viewModel.isLocalforProductAlreadyCalled) {
                        viewModel.categoriesList = viewModel.categoriesList
                            .where((element) => element.parentId == false)
                            .toList();

                        try {
                          Future.delayed(const Duration(milliseconds: 2), () {
                            //viewModel.getLocalDataForProductCategories();
                            // viewModel.getLoacalDataForBlogsDetail();
                            // viewModel.getLoacalDataForCustomerReviewDetail();
                            // viewModel.getLocalDataForNewProduct();
                          });
                        } catch (error) {
                          //viewModel.getLocalDataForProductCategories();
                          // viewModel.getLoacalDataForBlogsDetail();
                          // viewModel.getLoacalDataForCustomerReviewDetail();
                          // viewModel.getLocalDataForNewProduct();
                        }
                      }
                      if (viewModel.categoriesList.isNotEmpty &&
                          viewModel.sliderContentList.isNotEmpty) {
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
                    // return bodyWidget(viewModel, context);
                    return Container();
                  }),
                  child: child,
                )
              : NetworkError(
                  content: 'Products Not Found!!',
                  subContant: 'No data, Please try again later.',
                  icon: 'assets/icon/network_error.png',
                  viewModel: viewModel,
                )),
      disposeViewModel: false, // Prevent disposing of the ViewModel
      // Ensures the ViewModel is created immediately
    );
  }

  //return body
  bodyWidget(HomePageDataViewModel viewModel, BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 5.h),
      children: [
        sloganWidget(),
        SizedBox(
          height: 16.h,
        ),
        sliderContentCarouselSlider(viewModel),
        SizedBox(
          height: 16.h,
        ),
        carouselWidget(viewModel),
        // SizedBox(
        //   height: 16.h,
        // ),
        // viewModel.sliderContentList.isNotEmpty
        //     ? loginOptionWidget(viewModel)
        //     : Container(),
        SizedBox(
          height: 16.h,
        ),
        !viewModel.isBusy &&
                viewModel.newProductList != null &&
                viewModel.newProductList.isEmpty
            ? Container(
                height: 0,
                width: 0,
              )
            : newProductWidget(viewModel, context),
        !viewModel.isBusy &&
                viewModel.newProductList != null &&
                viewModel.newProductList.isEmpty
            ? Container()
            : SizedBox(
                height: 16.h,
              ),
        // !viewModel.isBusy &&
        //         viewModel.customerReviewList != null &&
        //         viewModel.customerReviewList.isEmpty
        //     ? Container(
        //         height: 0,
        //         width: 0,
        //       )

        //     :
        // customerReviewWidget(viewModel),
        SizedBox(
          height: 16.h,
        ),

        // viewModel.projectsList != null && viewModel.projectsList.isNotEmpty
        //     ? projectsWidget(viewModel, context)
        //     : Container(
        //         height: 0,
        //         width: 0,
        //       ),
        viewModel.blogsList != null && viewModel.blogsList.isNotEmpty
            ? blogsWidget(viewModel)
            : Container(
                height: 0,
                width: 0,
              ),
        SizedBox(
          height: 16.h,
        ),
        viewModel.videosList != null && viewModel.videosList.isNotEmpty
            ? videosWidget(viewModel, context)
            : Container(
                height: 0,
                width: 0,
              ),
        // viewModel.blogsList != null && viewModel.blogsList.isNotEmpty
        //     ? blogsWidget(viewModel)
        //     : Container(
        //         height: 0,
        //         width: 0,
        //       ),
        // tabBarWidget(viewModel),
      ],
    );
  }

  // Return Login Option Widget
  Widget loginOptionWidget(HomePageDataViewModel viewModel) {
    return CarouselSlider.builder(
      itemCount: viewModel.sliderContentList.length,
      options: CarouselOptions(
        padEnds: false,
        autoPlay: true,
        enableInfiniteScroll: true,
        disableCenter: false,
        viewportFraction: 0.9,
        aspectRatio: 5.h,
        reverse: false,
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.height,
      ),
      itemBuilder: (context, index, realIdx) {
        return Container(
            width: double.infinity,
            padding: EdgeInsets.only(
                left: 16.w, right: 16.w, top: 10.h, bottom: 10.h),
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: const Color(0xff33A3E4)),
            child: InkWell(
              onTap: () {
                if (index == 0) {
                  viewModel.onCreateAccountClick();
                } else if (index == 1) {
                  AppUtil.launchURL(Constants.CATALOGUE_PAGE_URL);
                } else if (index == 2) {
                  AppUtil.launchURL(Constants.BEANIE_PAGE_URL);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    viewModel.sliderContentList[index].title,
                    style: TextStyle(
                      fontFamily: 'Raleway-Mixed',
                      fontSize: Globlas.deviceType == "phone" ? 12 : 22,
                      color: const Color(0xffFFFFFF),
                      letterSpacing: 0.33,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  viewModel.sliderContentList[index].subtitle != ''
                      ? Expanded(
                          child: Text(
                            // 'jkl',
                            viewModel.sliderContentList[index].subtitle == false
                                ? ''
                                : viewModel.sliderContentList[index].subtitle
                                    .toString(),
                            style: TextStyle(
                              fontFamily: 'Raleway-Mixed',
                              fontSize: Globlas.deviceType == "phone" ? 11 : 21,
                              color: const Color(0xffFFFFFF),
                              letterSpacing: 0.33,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ));
      },
    );
  }

  // Return Blogs Widget
  Widget blogsWidget(HomePageDataViewModel viewModel) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Powanews',
            style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: Globlas.deviceType == "phone" ? 16 : 26,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.33,
                color: const Color(0xff1B1D1E)),
          ),
          SizedBox(
            height: 20.h,
          ),
          !viewModel.isBlogAPICalling &&
                  viewModel.blogsList != null &&
                  viewModel.blogsList.isEmpty
              ? Container(
                  height: 0,
                  width: 0,
                )
              : userBlogWidget(viewModel)
        ]);
  }

  // Return Projects Widget
  Widget projectsWidget(HomePageDataViewModel viewModel, BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headingWidget('Blog Posts', viewModel, context, 2),
          // Text(
          //   'Projects',
          //   style: TextStyle(
          //       fontFamily: 'Raleway',
          //       fontSize: Globlas.deviceType == "phone" ? 16 : 26,
          //       fontStyle: FontStyle.normal,
          //       fontWeight: FontWeight.bold,
          //       letterSpacing: -0.33,
          //       color: const Color(0xff1B1D1E)),
          // ),
          SizedBox(
            height: 20.h,
          ),
          !viewModel.isProjectAPICalling &&
                  viewModel.projectsList != null &&
                  viewModel.projectsList.isEmpty
              ? Container(
                  height: 0,
                  width: 0,
                )
              : projectItemWidget(viewModel)
        ]);
  }

  // Return Videos Widget
  Widget videosWidget(HomePageDataViewModel viewModel, BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headingWidget("Videos", viewModel, context, 3),
          SizedBox(
            height: 20.h,
          ),
          !viewModel.isVideoAPICalling &&
                  viewModel.videosList != null &&
                  viewModel.videosList.isEmpty
              ? Container(
                  height: 0,
                  width: 0,
                )
              : videoItemWidget(viewModel)
        ]);
  }

  // Return User Blog Widget
  Widget videoItemWidget(HomePageDataViewModel viewModel) {
    return Container(
      height: Globlas.deviceType == 'phone'
          ? AppUtil.getDeviceHeight() * 0.30.h
          : AppUtil.getDeviceHeight() * 0.18.h,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: viewModel.isVideoAPICalling
              ? 10
              : viewModel.videosList != null
                  ? viewModel.videosList.length <= 4
                      ? viewModel.videosList.length
                      : 4
                  : 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return viewModel.isVideoAPICalling
                ? ShimmerLoading(
                    isLoading: true,
                    child: Container(
                      margin: const EdgeInsets.only(right: 4),
                      width: AppUtil.getDeviceWidth() * 0.8,
                      height: 140.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100],
                      ),
                    ))
                : videoItem(viewModel, index, viewModel.videosList, context);
          }),
    );
  }

  // Return User Blog Widget
  Widget projectItemWidget(HomePageDataViewModel viewModel) {
    return Container(
      height: Globlas.deviceType == 'phone'
          ? AppUtil.getDeviceHeight() * 0.30.h
          : AppUtil.getDeviceHeight() * 0.18.h,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: viewModel.isProjectAPICalling
              ? 10
              : viewModel.projectsList != null
                  ? viewModel.projectsList.length
                  : 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return viewModel.isProjectAPICalling
                ? ShimmerLoading(
                    isLoading: true,
                    child: Container(
                      margin: const EdgeInsets.only(right: 4),
                      width: AppUtil.getDeviceWidth() * 0.8,
                      height: 140.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100],
                      ),
                    ))
                : projectItem(
                    viewModel, index, viewModel.projectsList, context);
          }),
    );
  }

  // return Project Item Widget
  Widget videoItem(HomePageDataViewModel viewModel, int index,
      List<Video>? videoList, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: AppUtil.getDeviceWidth() * 0.8,
      padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 16),
      decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              FutureBuilder<String>(
                future: AppUtil.getThumbnailFile(videoList![index].videoUrl),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: Globlas.deviceType == 'phone'
                          ? AppUtil.getDeviceHeight() * 0.20.h
                          : AppUtil.getDeviceHeight() * 0.08.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 140.h,
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
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                height: Globlas.deviceType == 'phone'
                    ? AppUtil.getDeviceHeight() * 0.20.h
                    : AppUtil.getDeviceHeight() * 0.08.h,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      const Color(0xffFFFFFF).withOpacity(0.0),
                      const Color(0xff1A1B1D).withOpacity(0.56)
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        topLeft: Radius.circular(16))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            viewModel.onVideoItemClick(
                                videoList[index], context);
                          },
                          child: Container(
                            //padding: EdgeInsets.all(16),
                            alignment: Alignment.center,
                            width: 55,
                            decoration: BoxDecoration(
                                color: const Color(0xffD60505),
                                // boxShadow: const [
                                //   BoxShadow(
                                //       blurRadius: 32,
                                //       offset: Offset(1, 3),
                                //       color: Color.fromRGBO(236, 14, 0, 0.63))
                                // ],
                                borderRadius: BorderRadius.circular(8)),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          // child: Container(
                          //   width: 40.w,
                          //   height: 25.w,
                          //   alignment: Alignment.center,
                          //   decoration: BoxDecoration(
                          //       color: const Color(0xffD60505),
                          //       boxShadow: const [
                          //         BoxShadow(
                          //             blurRadius: 32,
                          //             offset: Offset(1, 3),
                          //             color: Color.fromRGBO(236, 14, 0, 0.63))
                          //       ],
                          //       borderRadius: BorderRadius.circular(6)),
                          //   child: Text(
                          //     'Shop Now',
                          //     style: TextStyle(
                          //         fontFamily: 'Raleway',
                          //         fontSize: Globlas.deviceType == "phone" ? 12 : 22,
                          //         fontStyle: FontStyle.normal,
                          //         fontWeight: FontWeight.w500,
                          //         letterSpacing: -0.2,
                          //         color: const Color(0xffFFFFFF)),
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // YoutubePlayer(
          //   controller: viewModel.controller,
          //   onReady: (() {
          //     viewModel.controller.addListener(viewModel.listener);
          //   }),
          //   showVideoProgressIndicator: false,
          // ),
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(10),
          //   child: CachedNetworkImage(
          //     // imageUrl:
          //     //     'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
          //     imageUrl: ApiClient.BASE_URL + projectList![index].imageUrl,
          //     fit: BoxFit.cover,
          //     width: double.infinity,
          //     height: 140.h,
          //     errorWidget: ((context, url, error) {
          //       return Image.asset(
          //         'assets/icon/dummy.png',
          //         width: double.infinity,
          //         height: double.infinity,
          //         fit: BoxFit.cover,
          //       );
          //     }),
          //   ),
          // ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Wrap(
              children: [
                Text(
                  videoList[index].name != null &&
                          videoList[index].name.isNotEmpty
                      ? videoList[index].name.toString()
                      : '',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: Globlas.deviceType == "phone" ? 13 : 23,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.33,
                      color: const Color(0xff1B1D1E)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 3),
              child: SingleChildScrollView(
                child: ReadMoreText(
                  videoList[index].description != null &&
                          videoList[index].description!.isNotEmpty
                      ? videoList[index].description.toString()
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
            ),
          )
        ],
      ),
    );
  }

  // return Project Item Widget
  Widget projectItem(HomePageDataViewModel viewModel, int index,
      List<Project>? projectList, BuildContext context) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: AppUtil.getDeviceWidth() * 0.8,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 3, bottom: 16),
        decoration: BoxDecoration(
            color: const Color(0xffFFFFFF),
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                // imageUrl:
                //     'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
                imageUrl: ApiClient.BASE_URL + projectList![index].imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 140.h,
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
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Wrap(
                children: [
                  Text(
                    projectList[index].name != null &&
                            projectList[index].name.isNotEmpty
                        ? projectList[index].name.toString()
                        : '',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: Globlas.deviceType == "phone" ? 13 : 23,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.33,
                        color: const Color(0xff1B1D1E)),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 8.h,
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 8, bottom: 3),
            //   child: Text(
            //     projectList[index].postDate != null &&
            //             blogPosts[index].postDate!.isNotEmpty
            //         ? AppUtil.getDate(blogPosts[index].postDate)
            //         : '',
            //     style: TextStyle(
            //         fontFamily: 'Raleway',
            //         fontSize: Globlas.deviceType == "phone" ? 11 : 21,
            //         fontStyle: FontStyle.normal,
            //         fontWeight: FontWeight.w400,
            //         letterSpacing: -0.33,
            //         color: const Color(0xff36393C)),
            //   ),
            // ),
          ],
        ),
      ),
      onTap: () {
        viewModel.onProjectItemClick(viewModel.projectsList[index], context);
      },
    );
  }

  // Return User Blog Widget
  Widget userBlogWidget(HomePageDataViewModel viewModel) {
    return Container(
      height: Globlas.deviceType == 'phone'
          ? AppUtil.getDeviceHeight() * 0.32.h
          : AppUtil.getDeviceHeight() * 0.20.h,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: viewModel.isBlogAPICalling
              ? 10
              : viewModel.blogsList != null
                  ? viewModel.blogsList.length
                  : 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return viewModel.isBlogAPICalling
                ? ShimmerLoading(
                    isLoading: true,
                    child: Container(
                      margin: const EdgeInsets.only(right: 4),
                      width: AppUtil.getDeviceWidth() * 0.8,
                      height: 140.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100],
                      ),
                    ))
                : blogItem(viewModel, index, viewModel.blogsList, context);
          }),
    );
  }

  Widget sloganWidget() {
    return Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: AnimatedTextKit(
          repeatForever: true,
          animatedTexts: [
            TyperAnimatedText(
              Constants.slogan,
              textStyle: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: Globlas.deviceType == "phone" ? 16 : 26,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.33,
                  color: const Color(0xff1B1D1E)),
            ),
          ],
        ));
  }

  // Return Tab bar widget
  Widget tabBarWidget(HomePageDataViewModel viewModel) {
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
                    // viewModel.onTabItemClicked();
                  },
                  child: Container(
                    height: 40.h,
                    alignment: Alignment.center,
                    decoration: viewModel.isResourcesClicked
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: const Color(0xffD60505))
                        : null,
                    child: Text(
                      'Resources & Videos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          letterSpacing: -0.33,
                          fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                          fontStyle: FontStyle.normal,
                          fontWeight: viewModel.isResourcesClicked
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: viewModel.isResourcesClicked
                              ? const Color(0xffFFFFFF)
                              : const Color(0xff36393C)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    // viewModel.onTabItemClicked();
                  },
                  child: Container(
                    height: 40.h,
                    alignment: Alignment.center,
                    // decoration: viewModel.isAllProductClicked
                    //     ? BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10.r),
                    //         color: const Color(0xffD60505))
                    //     : null,
                    child: Text(
                      'Projects',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Raleway',
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
                    // viewModel.onTabItemClicked();
                  },
                  child: Container(
                    height: 40.h,
                    alignment: Alignment.center,
                    decoration: viewModel.isAllProductClicked
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffD60505))
                        : null,
                    child: Text(
                      'About US',
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
              )
              // tabItem('All Products', viewModel),
              // tabItem('Job Product List', viewModel),
            ],
          ),
        ));
  }

  // return Blog Item Widget
  Widget blogItem(HomePageDataViewModel viewModel, int index,
      List<BlogPost>? blogPosts, BuildContext context) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: AppUtil.getDeviceWidth() * 0.8,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 3, bottom: 16),
        decoration: BoxDecoration(
            color: const Color(0xffFFFFFF),
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                // imageUrl:
                //     'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
                imageUrl: ApiClient.BASE_URL + blogPosts![index].imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 140.h,
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
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Wrap(
                children: [
                  Text(
                    blogPosts[index].name != null &&
                            blogPosts[index].name!.isNotEmpty
                        ? blogPosts[index].name.toString()
                        : '',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: Globlas.deviceType == "phone" ? 13 : 23,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.33,
                        color: const Color(0xff1B1D1E)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 3),
              child: Text(
                blogPosts[index].postDate != null &&
                        blogPosts[index].postDate!.isNotEmpty
                    ? AppUtil.getDate(blogPosts[index].postDate)
                    : '',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: Globlas.deviceType == "phone" ? 11 : 21,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.33,
                    color: const Color(0xff36393C)),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        viewModel.onBlogItemClick(viewModel.blogsList[index], context);
      },
    );
  }

  // Return Customer Review Widget
  // Widget customerReviewWidget(HomePageDataViewModel viewModel) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(top: 4.0),
  //         child: Text(
  //           'Customer Reviews',
  //           style: TextStyle(
  //               fontFamily: 'Raleway',
  //               fontSize: Globlas.deviceType == "phone" ? 16 : 26,
  //               fontStyle: FontStyle.normal,
  //               fontWeight: FontWeight.bold,
  //               letterSpacing: -0.33,
  //               color: const Color(0xff1B1D1E)),
  //         ),
  //       ),
  //       SizedBox(
  //         height: 20.h,
  //       ),
  //       !viewModel.isCustomerApiCalling &&
  //               viewModel.reviewList != null &&
  //               viewModel.reviewList.isEmpty
  //           ? Container(
  //               height: 0,
  //               width: 0,
  //             )
  //           : reviewWidget(viewModel)
  //     ],
  //   );
  // }

  // Return Review Widget
  // Widget reviewWidget(HomePageDataViewModel viewModel) {
  //   return Container(
  //     height: Globlas.deviceType == 'phone'
  //         ? AppUtil.getDeviceHeight() * 0.20.h
  //         : AppUtil.getDeviceHeight() * 0.12.h,
  //     child: ListView.builder(
  //         shrinkWrap: true,
  //         itemCount: viewModel.isCustomerApiCalling
  //             ? 10
  //             : viewModel.reviewList != null
  //                 ? viewModel.reviewList.length
  //                 : 0,
  //         scrollDirection: Axis.horizontal,
  //         itemBuilder: (BuildContext context, int index) {
  //           return viewModel.isCustomerApiCalling
  //               ? ShimmerLoading(
  //                   isLoading: true,
  //                   child: Container(
  //                     margin: const EdgeInsets.only(right: 4),
  //                     width: AppUtil.getDeviceWidth() * 0.8,
  //                     height: Globlas.deviceType == 'phone' ? 140.h : 90.h,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(10),
  //                       color: Colors.grey[100],
  //                     ),
  //                   ))
  //               : reviewItem(viewModel, index, viewModel.reviewList);
  //         }),
  //   );
  // }

  // Return Review Model
  // Widget reviewItem(
  //     HomePageDataViewModel viewModel, int index, List<UserReview>? reviews) {
  //   return Container(
  //     margin: const EdgeInsets.only(right: 12),
  //     width: AppUtil.getDeviceWidth() * 0.8,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //         color: const Color(0xffFFFFFF),
  //         borderRadius: BorderRadius.circular(10)),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Icon(
  //           PowaGroupIcon.double_inverted,
  //           size: 24.h,
  //           color: const Color(0xff858D93).withOpacity(0.4),
  //         ),
  //         SizedBox(
  //           // reviews![index].review != null && reviews[index].review!.isNotEmpty
  //           height: 12.h, //reviews[index].review.toString()
  //         ),
  //         Expanded(
  //           child: SingleChildScrollView(
  //             child: ReadMoreText(
  //               reviews![index].review != null &&
  //                       reviews[index].review!.isNotEmpty
  //                   ? reviews[index].review.toString()
  //                   : '',
  //               trimLines: 2,
  //               colorClickableText: Colors.black,
  //               trimMode: TrimMode.Line,
  //               style: TextStyle(
  //                   fontFamily: 'Raleway-Mixed',
  //                   fontSize: Globlas.deviceType == "phone" ? 13 : 23,
  //                   fontStyle: FontStyle.normal,
  //                   fontWeight: FontWeight.w400,
  //                   letterSpacing: -0.33,
  //                   color: const Color(0xff36393C)),
  //               trimCollapsedText: 'Read more',
  //               trimExpandedText: 'Show less',
  //               lessStyle: TextStyle(
  //                   fontSize: Globlas.deviceType == "phone" ? 13 : 19,
  //                   fontWeight: FontWeight.bold),
  //               moreStyle: TextStyle(
  //                   fontSize: Globlas.deviceType == "phone" ? 13 : 19,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 12.h,
  //         ),
  //         Text(
  //           reviews[index].title != null && reviews[index].title!.isNotEmpty
  //               ? reviews[index].title.toString()
  //               : '',
  //           // viewModel.customerReviewList[index].title!.isNotEmpty
  //           //     ? viewModel.customerReviewList[index].title!
  //           //     : 'Terry V.',
  //           style: TextStyle(
  //               fontFamily: 'Raleway-Mixed',
  //               fontSize: Globlas.deviceType == "phone" ? 13 : 23,
  //               fontStyle: FontStyle.normal,
  //               fontWeight: FontWeight.w400,
  //               letterSpacing: -0.33,
  //               color: const Color(0xff36393C)),
  //         ),
  //         SizedBox(
  //           height: 2.h,
  //         ),
  //         Text(
  //           reviews[index].reviewedBy != null &&
  //                   reviews[index].reviewedBy!.company != null &&
  //                   reviews[index].reviewedBy!.company!.isNotEmpty
  //               ? reviews[index].reviewedBy!.company.toString()
  //               : '',
  //           // viewModel.customerReviewList[index].reviewedBy!.company!.isNotEmpty
  //           //     ? viewModel.customerReviewList[index].reviewedBy!.company!
  //           //     : 'Elite Heating & Cooling',
  //           style: TextStyle(
  //               fontFamily: 'Raleway-Mixed',
  //               fontSize: Globlas.deviceType == "phone" ? 12 : 22,
  //               fontStyle: FontStyle.normal,
  //               fontWeight: FontWeight.w300,
  //               letterSpacing: -0.33,
  //               color: const Color(0xff36393C)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Return New Product Widget
  Widget newProductWidget(
      HomePageDataViewModel viewModel, BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headingWidget("Popular Products", viewModel, context, 1),
          SizedBox(
            height: 20.h,
          ),
          productGridWidget(viewModel)
        ]);
  }

  // Return Product Grid Widget
  Widget productGridWidget(HomePageDataViewModel viewModel) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: AppUtil.getDeviceHeight() * 0.20,
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 12),
        itemCount: viewModel.isNewProductAPICalling
            ? 10
            : viewModel.newProductList != null
                ? viewModel.newProductList.length <= 4
                    ? viewModel.newProductList.length
                    : 4
                : 0,
        itemBuilder: (BuildContext context, int index) {
          return productItem(viewModel, index, context);
        });
  }

  // Return Product Item Widget
  Widget productItem(
      HomePageDataViewModel viewModel, int index, BuildContext context) {
    return InkWell(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.only(bottom: 10, right: 10),
            child: Container(
              //padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Stack(
                // alignment: Alignment.topRight,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image.asset('assets/icon/image 10.jpg'),
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: viewModel.isNewProductAPICalling
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
                              : CachedNetworkImage(
                                  imageUrl: viewModel.newProductList[index]
                                                  .mainImageUrl !=
                                              null &&
                                          viewModel.newProductList[index]
                                              .mainImageUrl!.isNotEmpty
                                      ? ApiClient.BASE_URL +
                                          viewModel.newProductList[index]
                                              .mainImageUrl!
                                      : ApiClient.BASE_URL +
                                          "/web/image/product.product/11760/image_1024",
                                  fit: BoxFit.cover,
                                  width: 155.h,
                                  height: 100.h,
                                ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        viewModel.isNewProductAPICalling
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ShimmerLoading(
                                    isLoading: true,
                                    child: Container(
                                      width: double.infinity,
                                      height: 15.h,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    )),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: Text(
                                  viewModel.newProductList[index].name !=
                                              null &&
                                          viewModel.newProductList[index].name!
                                              .isNotEmpty
                                      ? viewModel.newProductList[index].name!
                                      : '',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: Globlas.deviceType == "phone"
                                          ? 13
                                          : 23,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.33,
                                      color: const Color(0xff36393C)),
                                ),
                              ),
                      ],
                    ),
                  ),
                  // viewModel.isNewProductAPICalling
                  //     ? Container()
                  //     : Align(
                  //         alignment: Alignment.topRight,
                  //         child: PopupWidget(id: '14510'))
                ],
              ),
            ),
          ),
          viewModel.isNewProductAPICalling
              ? Container()
              : Positioned(
                  bottom: 1.sp,
                  right: 1.sp,
                  child: Container(
                    width: 30.sp,
                    height: 30.sp,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Color(0xffEFF1F2), shape: BoxShape.circle),
                    child: Container(
                      width: 25.sp,
                      height: 25.sp,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xffD60505)),
                      child: Icon(Icons.add,
                          color: const Color(0xffFFFFFF), size: 20.sp),
                    ),
                  ),
                )
        ],
      ),
      onTap: () {
        // viewModel.onProjectItemClick(viewModel.newProductList[index], context);
      },
    );
  }

  // Return Heading Widget
  Widget headingWidget(String title, HomePageDataViewModel viewModel,
      BuildContext context, int value) {
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
                fontWeight: FontWeight.bold,
                letterSpacing: -0.33,
                color: const Color(0xff1B1D1E)),
          ),
        ),
        InkWell(
          onTap: () {
            if (value == 1) {
              viewModel.onClickSeeAllPopularProducts(context);
            } else if (value == 2) {
              viewModel.onClickSeeAllProject(context);
            } else if (value == 3) {
              viewModel.onClickSeeAllViedeos(context);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              SizedBox(
                width: 5.w,
              ),
              doubleIcon(),
            ],
          ),
        ),
      ],
    );
  }

  // Return Carousel Slider List
  Widget carouselWidget(HomePageDataViewModel viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Products',
          style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: Globlas.deviceType == "phone" ? 16 : 26,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.33,
              color: const Color(0xff1B1D1E)),
        ),
        SizedBox(
          height: 16,
        ),
        CarouselSlider.builder(
          itemCount: viewModel.isBusy ? 10 : viewModel.categoriesList.length,
          options: CarouselOptions(
            padEnds: false,
            autoPlay: false,
            enableInfiniteScroll: false,
            disableCenter: false,
            viewportFraction: 0.8,
            aspectRatio: 1.5.h,
            reverse: false,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
          ),
          itemBuilder: (context, index, realIdx) {
            return viewModel.isBusy
                ? ShimmerLoading(
                    isLoading: true,
                    child: Container(
                      margin: const EdgeInsets.only(right: 4),
                      width: double.infinity,
                      height: 100.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100],
                      ),
                    ))
                : InkWell(
                    onTap: () {
                      viewModel.onProductCategoryItemClick(
                          viewModel.categoriesList[index], index, context);
                    },
                    child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(right: 4),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                // imageUrl:
                                //     'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
                                imageUrl: ApiClient.BASE_URL +
                                    viewModel.categoriesList[index].imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
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
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        const Color(0xffFFFFFF)
                                            .withOpacity(0.0),
                                        const Color(0xff1A1B1D)
                                            .withOpacity(0.56)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    viewModel.categoriesList[index].name !=
                                                null &&
                                            viewModel.categoriesList[index]
                                                .name!.isNotEmpty
                                        ? viewModel.categoriesList[index].name!
                                        : '',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: Globlas.deviceType == "phone"
                                          ? 14
                                          : 24,
                                      color: const Color(0xffFFFFFF),
                                      letterSpacing: 0.33,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          viewModel.onProductCategoryItemClick(
                                              viewModel.categoriesList[index],
                                              index,
                                              context);
                                        },
                                        child: Container(
                                          //width: 80.w,
                                          //eight: 25.w,
                                          padding: EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                              top: 8,
                                              bottom: 8),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffD60505),
                                              boxShadow: const [
                                                BoxShadow(
                                                    blurRadius: 32,
                                                    offset: Offset(1, 3),
                                                    color: Color.fromRGBO(
                                                        236, 14, 0, 0.63))
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Text(
                                            'Shop Now',
                                            style: TextStyle(
                                                fontFamily: 'Raleway',
                                                fontSize: Globlas.deviceType ==
                                                        "phone"
                                                    ? 12
                                                    : 22,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: -0.2,
                                                color: const Color(0xffFFFFFF)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                  );
          },
        ),
      ],
    );
  }

  // Return Content Slider Carousel Slider
  Widget sliderContentCarouselSlider(HomePageDataViewModel viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        viewModel.isBusy
            ? ShimmerLoading(
                isLoading: true,
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  width: double.infinity,
                  height: 100.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[100],
                  ),
                ))
            : viewModel.sliderContentList.isNotEmpty
                ? CarouselSlider.builder(
                    itemCount: viewModel.sliderContentList.length,
                    options: CarouselOptions(
                      padEnds: false,
                      onPageChanged: ((index, reason) {
                        viewModel.currentPageValue = index;
                      }),
                      autoPlay: true,
                      enableInfiniteScroll: true,
                      disableCenter: false,
                      viewportFraction: 0.9,
                      aspectRatio: 1.5.h,
                      reverse: false,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                    ),
                    itemBuilder: (context, index, realIdx) {
                      return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(right: 4),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: ApiClient.BASE_URL +
                                      viewModel
                                          .sliderContentList[index].imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
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
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          const Color(0xffFFFFFF)
                                              .withOpacity(0.0),
                                          const Color(0xff1A1B1D)
                                              .withOpacity(0.56)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      viewModel.sliderContentList[index]
                                                      .title !=
                                                  null &&
                                              viewModel.sliderContentList[index]
                                                  .title.isNotEmpty
                                          ? viewModel
                                              .sliderContentList[index].title
                                          : '',
                                      style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: Globlas.deviceType == "phone"
                                            ? 14
                                            : 24,
                                        color: const Color(0xffFFFFFF),
                                        letterSpacing: 0.33,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (index == 0) {
                                              viewModel.onCreateAccountClick();
                                            } else {
                                              AppUtil.launchURL(ApiClient
                                                      .BASE_URL +
                                                  viewModel
                                                      .sliderContentList[index]
                                                      .buttonUrl);
                                            }
                                          },
                                          child: Container(
                                            //width: 80.w,
                                            //height: 25.w,
                                            padding: EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 8,
                                                bottom: 8),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: const Color(0xffD60505),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      blurRadius: 32,
                                                      offset: Offset(1, 3),
                                                      color: Color.fromRGBO(
                                                          236, 14, 0, 0.63))
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: Column(
                                              children: [
                                                Text(
                                                  viewModel
                                                                  .sliderContentList[
                                                                      index]
                                                                  .buttonText !=
                                                              null &&
                                                          viewModel
                                                              .sliderContentList[
                                                                  index]
                                                              .buttonText
                                                              .isNotEmpty
                                                      ? viewModel
                                                          .sliderContentList[
                                                              index]
                                                          .buttonText
                                                      : '',
                                                  style: TextStyle(
                                                      fontFamily: 'Raleway',
                                                      fontSize:
                                                          Globlas.deviceType ==
                                                                  "phone"
                                                              ? 12
                                                              : 22,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: -0.2,
                                                      color: const Color(
                                                          0xffFFFFFF)),
                                                ),
                                                Text(
                                                  // 'jkl',
                                                  viewModel
                                                              .sliderContentList[
                                                                  index]
                                                              .subtitle ==
                                                          false
                                                      ? ''
                                                      : viewModel
                                                          .sliderContentList[
                                                              index]
                                                          .subtitle
                                                          .toString(),
                                                  style: TextStyle(
                                                    fontFamily: 'Raleway-Mixed',
                                                    fontSize:
                                                        Globlas.deviceType ==
                                                                "phone"
                                                            ? 11
                                                            : 21,
                                                    color:
                                                        const Color(0xffFFFFFF),
                                                    letterSpacing: 0.33,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ));
                    },
                  )
                : Container(),
        SizedBox(
          height: viewModel.sliderContentList.isNotEmpty ? 16 : 0,
        ),
        viewModel.sliderContentList.isNotEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: viewModel.sliderContentList.map(
                  (image) {
                    int index = viewModel.sliderContentList.indexOf(image);
                    return viewModel.currentPageValue == index
                        ? Container(
                            width: 16.0,
                            height: 6.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4)),
                          )
                        : Container(
                            width: 8.0,
                            height: 6.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(0, 0, 0, 0.4)),
                          );
                  },
                ).toList(), // this was the part the I had to add
              )
            : Container(
                height: 0,
                width: 0,
              ),
      ],
    );
  }
}
