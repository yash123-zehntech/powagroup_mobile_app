import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/services/api_client.dart';
import 'package:powagroup/services/globals.dart';
import 'package:powagroup/ui/screen/modules/blog_module/blog_detail_view_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/blog_detail.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/projects.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/videos.dart';
import 'package:powagroup/ui/screen/modules/video_module/video_player/video_player_view_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerView extends StatefulWidget {
  Video? video;

  VideoPlayerView({
    Key? key,
    this.video,
  }) : super(key: key);

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView>
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
    return ViewModelBuilder<VideoPlayerViewModel>.reactive(
      viewModelBuilder: () => VideoPlayerViewModel(),
      onViewModelReady: (viewModel) async {
        viewModel.initialiseVideoController(widget.video!);

        _controller = AnimationController(
          vsync: this,
          duration: const Duration(
            milliseconds: 500,
          ),
          lowerBound: 0.0,
          upperBound: 0.1,
        );
      },
      onDispose: ((viewModel) {
        viewModel.controller!.dispose();
      }),
      builder: (context, viewModel, child) => WillPopScope(
        onWillPop: () async {
          if (viewModel.controller != null &&
              viewModel.controller!.value.isFullScreen) {
            viewModel.controller!.toggleFullScreenMode();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
            appBar: viewModel.controller != null &&
                    !viewModel.controller!.value.isFullScreen
                ? PreferredSize(
                    preferredSize: Size.fromHeight(60.h),
                    child: AppBarWidget(
                      title: widget.video != null
                          ? widget.video!.name != null &&
                                  widget.video!.name.isNotEmpty
                              ? widget.video!.name.toString()
                              : ''
                          : '',
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
                  )
                : PreferredSize(
                    child: Container(
                      width: 0,
                      height: 0,
                    ),
                    preferredSize: Size.fromHeight(0)),
            backgroundColor: Colors.white,
            body: parentWidget(viewModel)),
      ),
    );
  }

//Return Body widget
  Widget parentWidget(VideoPlayerViewModel viewModel) {
    return ListView(
      children: [
        videoPlayerWidget(viewModel),
        viewModel.controller != null &&
                !viewModel.controller!.value.isFullScreen
            ? videoNameWidget(viewModel)
            : Container(
                width: 0,
                height: 0,
              )
      ],
    );
  }

  // Make video name widget
  Widget videoNameWidget(VideoPlayerViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 3, right: 16, top: 8),
      child: Text(
        widget.video != null
            ? widget.video!.name != null && widget.video!.name.isNotEmpty
                ? widget.video!.name.toString()
                : ''
            : '',
        style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: Globlas.deviceType == "phone" ? 15 : 25,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.33,
            color: const Color(0xff1B1D1E)),
      ),
    );
  }

  // Video Player Widget
  videoPlayerWidget(VideoPlayerViewModel viewModel) {
    return Container(
      height: viewModel.controller != null &&
              viewModel.controller!.value.isFullScreen
          ? MediaQuery.of(context).size.height
          : 220,
      width: double.infinity,
      child: YoutubePlayer(
        controller: viewModel.controller!,
        aspectRatio: 16 / 9,
        onReady: (() {
          viewModel.controller!.addListener(viewModel.listener);
        }),
        showVideoProgressIndicator: false,
      ),
    );
  }
}
