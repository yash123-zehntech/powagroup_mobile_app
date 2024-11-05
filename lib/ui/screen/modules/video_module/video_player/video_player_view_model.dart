import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/model/user_model.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/auth_provider.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/videos.dart';
import 'package:powagroup/ui/screen/modules/user_module/login/response_model/login_response.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/shared_preference.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  YoutubePlayerController? controller;

  void listener() {
    if (_isPlayerReady && !controller!.value.isFullScreen) {
      //setState(() {
      _playerState = controller!.value.playerState;
      _videoMetaData = controller!.metadata;
      //});
      notifyListeners();
    }
  }

  // Initialise Video Player Controller
  initialiseVideoController(Video video) {
    String videoId = '';
    try {
      videoId = YoutubePlayer.convertUrlToId(video.videoUrl)!;
    } catch (e) {
      for (var exp in [
        RegExp(
            r"^http:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      ]) {
        Match? match = exp.firstMatch(video.videoUrl);
        if (match != null && match.groupCount >= 1) {
          videoId = match.group(1)!;
        }
      }
    }

    controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        controlsVisibleAtStart: false,
        showLiveFullscreenButton: false,
        loop: false,
        mute: false,
      ),
    );

    if (controller!.value.isFullScreen) {
      controller!.fitHeight(Size(double.infinity, double.infinity));
      controller!.fitWidth(Size(double.infinity, double.infinity));
    }
  }
}
