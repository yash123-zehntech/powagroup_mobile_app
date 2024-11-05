// ignore_for_file: sort_child_properties_last
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/custom_fonts/my_flutter_app_icons.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/response_model/joblist_hive_model.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_job_list_module/create_job_list_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/favorite_detail_model.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import '../ui/screen/modules/favorite_module/create_jobList_dropdown model/create_job_list_selected.dart';
import '../ui/screen/modules/favorite_module/create_jobList_dropdown model/create_job_list_selected_model.dart';

class PopupWidget extends StatefulWidget {
  ProductData? productData;
  String? title;
  String id;
  dynamic viewModel;

  PopupWidget({
    Key? key,
    this.title,
    required this.id,
    this.viewModel,
    this.productData,
  }) : super(key: key);

  @override
  State<PopupWidget> createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget>
    with SingleTickerProviderStateMixin {
  Api apiCall = locator<Api>();
  CreateJobListSelectedModel createJobListSelectedModel =
      CreateJobListSelectedModel();
  List<JobListData> jobList = List.empty(growable: true);
  FavoriteResponseModel? favoriteResponseModel;
  AnimationController? _controller;
  Animation<double>? _animation;
  bool _isCalling = false;

  bool get isCalling => _isCalling;
  set isCalling(bool isCalling) {
    _isCalling = isCalling;
    widget.viewModel.notifyListeners();
  }

  @override
  void initState() {
    getJobProductList();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      position: PopupMenuPosition.over,
      padding: Globlas.deviceType == 'phone'
          ? const EdgeInsets.only(
              left: 23,
              top: 0,
              bottom: 30,
            )
          : const EdgeInsets.all(0),
      icon: AnimatedSwitcher(
        transitionBuilder: (child, anim) => ScaleTransition(
          scale: child.key == const ValueKey('icon1')
              ? Tween<double>(begin: 0.75, end: 1.2).animate(anim)
              : Tween<double>(begin: 0.75, end: 1.2).animate(anim),
          child: FadeTransition(opacity: anim, child: child),
        ),
        child: Icon(
            widget.productData!.isFav!
                ? PowaGroupIcon.heart3
                : PowaGroupIcon.heart,
            size: 20.h,
            color: widget.productData!.isFav!
                ? const Color(0xffD60505)
                : const Color(0xff858D93),
            key: widget.productData!.isFav!
                ? const ValueKey("icon1")
                : const ValueKey("icon2")),
        duration: const Duration(milliseconds: 300),
      ),
      itemBuilder: (context) => [
        // PopupMenuItem 1
        PopupMenuItem(
          value: 1,
          // row with 2 children
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
              widget.productData!.isFav!
                  ? Text(
                      "Remove from favourite",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.33,
                        fontSize: Globlas.deviceType == "phone" ? 15 : 20,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff1B1D1E),
                      ),
                    )
                  : Text(
                      "Add to favourite",
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
        // PopupMenuItem 2
        PopupMenuItem(
          value: 2,
          // row with two children
          child: InkWell(
            onTap: () async {
              jobList = await AppUtil.getJobProductList();
              if (jobList.isEmpty || jobList.length == []) {
                await Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) =>
                        CreateJoblistView(
                          productData: widget.productData,
                          index: 0,
                        )));
              } else {
                await Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) =>
                        CreateJoblistSelected(
                          productData: widget.productData,
                        )));
              }
              Navigator.of(context).pop();
              jobList = await AppUtil.getJobProductList();
            },
            child: Row(
              children: [
                // Container(
                //   height: 25.h,
                //   width: 25.h,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(25.r),
                //       border: Border.all(
                //         color: const Color(0xff858D93),
                //       )),
                //   child:
                //       Icon(Icons.add, color: const Color(0xffD60505), size: 20.h),
                // ),
                Icon(
                  MyFlutterApp.list_alt,
                  color: const Color(0xff858D93),
                  size: 24.h,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  " Job Lists ",
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
      offset: Globlas.deviceType == "phone" ? Offset(0, 30) : Offset(0, 50),
      color: const Color(0xffffffff),
      elevation: 5,
      // on selected we show the dialog box
      onSelected: (value) async {
        // if value 1 show dialog
        if (value == 1) {
          isCalling ? null : addFavorite(widget.id);
        } else if (value == 2) {
          jobList.clear();
          jobList = await AppUtil.getJobProductList();
          if (jobList.isEmpty || jobList.length == []) {
            await Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) => CreateJoblistView(
                      productData: widget.productData,
                      //key: key,
                      //title: 'title',
                    )));
          } else {
            await Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) =>
                    CreateJoblistSelected(
                      productData: widget.productData,
                    )));
          }
          Navigator.of(context).pop();
          jobList = await AppUtil.getJobProductList();
          // createJobListSelectedModel!.createJobList =
          //     await Navigator.of(context).push(PageRouteBuilder(
          //         opaque: false,
          //         pageBuilder: (BuildContext context, _, __) =>
          //             CreateJoblistSelected(
          //               productData: widget.productData,
          //             )));
        }
      },
    );
  }

  addFavorite(var subCategoryId) async {
    isCalling = true;

    widget.viewModel.notifyListeners();
    var body;

    !widget.productData!.isFav!
        ? body = {
            "fav": "True",
          }
        : body = {
            "fav": "False",
          };
    favoriteResponseModel =
        await apiCall.checkFavoritePorduct(jsonEncode(body), subCategoryId);
    isCalling = false;

    switch (favoriteResponseModel!.statusCode) {
      case Constants.sucessCode:
        if (widget.productData!.isFav!) {
          widget.productData!.isFav = false;
          AppUtil.showSnackBar("Remove From Favourite");
        } else {
          widget.productData!.isFav = true;
          AppUtil.showSnackBar("Added to Favourite");
        }

        widget.viewModel.notifyListeners();

        break;
      case Constants.wrongError:
        AppUtil.showDialogbox(AppUtil.getContext(),
            favoriteResponseModel!.error ?? "Something Went Wrong");

        widget.viewModel.notifyListeners();

        break;
      case Constants.networkErroCode:
        AppUtil.showDialogbox(AppUtil.getContext(),
            favoriteResponseModel!.error ?? "Something Went Wrong");
        // AppUtil.showToast(loginResp.error ?? '');
        break;
      default:
        {
          if (favoriteResponseModel!.error != null &&
              favoriteResponseModel!.error!.isNotEmpty) {}
        }
        break;
    }

    widget.viewModel.notifyListeners();
  }

  getJobProductList() async {
    jobList = await AppUtil.getJobProductList();
  }
}
