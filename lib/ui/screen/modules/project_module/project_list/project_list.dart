import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/network_error%20widget.dart';
import 'package:powagroup/services/api_client.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/projects.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/videos.dart';
import 'package:powagroup/ui/screen/modules/project_module/project_list/project_list_view_model.dart';
import 'package:powagroup/ui/screen/modules/video_module/video_player/video_player_view_model.dart';
import 'package:powagroup/ui/screen/modules/video_module/videos_list/video_list_view_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ProjectsListView extends StatefulWidget {
  List<Project>? projectList = List.empty(growable: true);

  ProjectsListView({
    Key? key,
    this.projectList,
  }) : super(key: key);

  @override
  State<ProjectsListView> createState() => _ProjectsListViewState();
}

class _ProjectsListViewState extends State<ProjectsListView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProjectsListViewModel>.reactive(
      viewModelBuilder: () => ProjectsListViewModel(),
      onViewModelReady: (viewModel) async {},
      builder: (context, viewModel, child) => Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(Globlas.deviceType == "phone" ? 30 : 50),
            child: AppBarWidget(
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
              title: '',
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
          body: Stack(
            children: [
              logoWidget(),
              SizedBox(
                height: 50.h,
              ),
              Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.07),
                  child: vidoesList(viewModel)),
            ],
          )),
    );
  }

  // Return Product Categories List
  Widget vidoesList(ProjectsListViewModel viewModel) {
    return widget.projectList == null || widget.projectList!.isEmpty
        ? Center(
            child: NetworkError(
              content: 'Videos Not Found!!',
              subContant: 'No data, Please try again later.',
              icon: 'assets/icon/network_error.png',
              viewModel: viewModel,
            ),
          )
        : GridView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(
              left: 12,
              bottom: 16,
              right: 12,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 170.h,
                crossAxisCount: 2,
                crossAxisSpacing: 12.h,
                mainAxisSpacing: 12.h),
            itemCount: widget.projectList!.length,
            itemBuilder: (BuildContext context, int index) {
              return videoItem(viewModel, index, context);
            });
  }

  // Return Product Category Item by index
  Widget videoItem(
      ProjectsListViewModel viewModel, int index, BuildContext context) {
    return InkWell(
      onTap: () {
        viewModel.onProjetItemClick(widget.projectList![index], index, context);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        // height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl:
                    ApiClient.BASE_URL + widget.projectList![index].imageUrl,
                fit: BoxFit.cover,
                width: 155.h,
                height: 100.h,
                errorWidget: ((context, url, error) {
                  return Image.asset(
                    'assets/icon/dummy.png',
                    width: 155.h,
                    height: 100.h,
                    fit: BoxFit.cover,
                  );
                }),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: Text(
                widget.projectList![index].name.isNotEmpty
                    ? widget.projectList![index].name
                    : '',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Raleway',
                    //fontSize: 13.0.sp,
                    fontSize: Globlas.deviceType == "phone" ? 12 : 22,
                    letterSpacing: -0.33,
                    color: const Color(0xff1B1D1E)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Return top logo widget
  Widget logoWidget() {
    return Container(
      // height: 100.h,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                ),
                child: Text(
                  "Blog Posts",
                  // 'Projects List',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.33,
                      fontSize: Globlas.deviceType == 'phone' ? 20 : 30,
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
