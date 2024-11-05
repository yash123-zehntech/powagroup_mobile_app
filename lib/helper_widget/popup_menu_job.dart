// ignore_for_file: sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/response_model/joblist_hive_model.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_job_list_module/create_job_list_view.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/favorite_detail_model.dart';
import 'package:powagroup/util/globleData.dart';
import '../ui/screen/modules/favorite_module/all_product_module/favorite_view_model.dart';
import '../ui/screen/modules/favorite_module/create_jobList_dropdown model/create_job_list_selected_model.dart';

class PopupWidgetForJobs extends StatefulWidget {
  FavoriteViewModel viewModel;
  int index;

  PopupWidgetForJobs({
    Key? key,
    required this.index,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<PopupWidgetForJobs> createState() => _PopupWidgetForJobsState();
}

class _PopupWidgetForJobsState extends State<PopupWidgetForJobs>
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
                PowaGroupIcon.edit_icon,
                color: const Color(0xff858D93),
                size: 24.h,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Edit",
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
                PowaGroupIcon.delete,
                color: const Color(0xff858D93),
                size: 22.h,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                " Delete ",
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
          await Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) => CreateJoblistView(
                    index: 1,
                    jobList: widget.viewModel.jobList[widget.index - 1],
                    // key: key,
                    title: 'title',
                  )));

          widget.viewModel.notifyListeners();
          // widget.viewModel.navigationService.back();
        } else if (value == 2) {
          widget.viewModel.notifyListeners();
          widget.viewModel
              .deleteJobList(widget.viewModel.jobList[widget.index - 1].id);
        }
      },
    );
  }
}
