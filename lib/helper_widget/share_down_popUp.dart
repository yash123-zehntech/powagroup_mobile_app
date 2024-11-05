import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/custom_fonts/my_flutter_app_icons.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/download_service.dart';
import 'package:powagroup/services/hive_db_services.dart';

import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/response_model/joblist_hive_model.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_job_list_module/create_job_list_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_category_module/response_model/product_categories_response.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_subcategory_response.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/favorite_detail_model.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';

import '../ui/screen/modules/favorite_module/create_jobList_dropdown model/create_job_list_selected.dart';
import '../ui/screen/modules/favorite_module/create_jobList_dropdown model/create_job_list_selected_model.dart';
import '../ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import '../ui/screen/modules/product_detail_module.dart/response_model/product_detail_by_id.dart';

class PopupWidgetForShare extends StatefulWidget {
  dynamic viewModel;

  PopupWidgetForShare({
    Key? key,
    this.viewModel,
  }) : super(key: key);

  @override
  State<PopupWidgetForShare> createState() => _PopupWidgetForShareState();
}

class _PopupWidgetForShareState extends State<PopupWidgetForShare>
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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
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
              left: 0,
              top: 0,
              // bottom: 30,
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
          Icons.more_vert,
          size: 20.h,
          color: const Color(0xff858D93),
          // key: widget.productData!.isFav!
          //     ? const ValueKey("icon1")
          //     : const ValueKey("icon2")
        ),
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
                PowaGroupIcon.download,
                color: const Color(0xff858D93),
                size: 20.h,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Download",
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
          child: Row(
            children: [
              Icon(
                Icons.share,
                color: const Color(0xff858D93),
                size: 24.h,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                " Share ",
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
      ],
      offset: Globlas.deviceType == "phone" ? Offset(0, 30) : Offset(0, 50),
      color: const Color(0xffffffff),
      elevation: 5,
      // on selected we show the dialog box
      onSelected: (value) async {
        // if value 1 show dialog
        if (value == 1) {
          if (widget.viewModel.orderData.pdfUrl != null &&
              widget.viewModel.orderData.pdfUrl!.isNotEmpty) {
            DownloadService downloadService = MobileDownloadService();
            await downloadService.download(
                url: widget.viewModel.orderData.pdfUrl!, isShare: false);
          } else {}
          widget.viewModel.notifyListeners();
          // widget.viewModel.navigationService.back();
        } else if (value == 2) {
          if (widget.viewModel.orderData.pdfUrl != null &&
              widget.viewModel.orderData.pdfUrl!.isNotEmpty) {
            DownloadService downloadService = MobileDownloadService();
            await downloadService.download(
                url: widget.viewModel.orderData.pdfUrl!, isShare: true);
          }

          widget.viewModel.notifyListeners();
        }
      },
    );
  }
}
