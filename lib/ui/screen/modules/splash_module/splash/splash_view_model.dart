import 'dart:async';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/ui/screen/modules/splash_module/splash/response_model/refresh_respose_model.dart';
import 'package:powagroup/util/shared_preference.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../../util/constant.dart';
import '../../../../../util/util.dart';

class SplashViewMode extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  Api apiCall = locator<Api>();

  // splash timer
  Future<void> checkAutoLogin() async {
    String? loginToken;
    loginToken = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    DateTime? tokenExpiryDate =
        await SharedPre.getDateTimeValue(SharedPre.LOGIN_EXPIRY_DATE);

    if (tokenExpiryDate != null && loginToken != null) {
      // Duration for refresh (e.g., 10 days)
      Duration refreshDuration = Duration(days: 10);
      // Calculate the date that is 10 days before the token expiry date
      DateTime refreshThreshold = tokenExpiryDate.subtract(refreshDuration);

      // Get the current date
      DateTime currentDate = DateTime.now();
      // DateTime newDate = currentDate.add(Duration(days: 80));
      // currentDate = newDate;
      // Check if the current date is equal to or after the refresh threshold
     
      if (currentDate.isAfter(refreshThreshold) ||
          currentDate.isAtSameMomentAs(refreshThreshold)) {
        callRefreshApi();
     
        // Add your refresh logic here
      } else {}
      navigationService.pushNamedAndRemoveUntil(Routes.homePageView,
          arguments: HomePageViewArguments(number: 0, numberforCart: 0));
    } else {
      navigationService.pushNamedAndRemoveUntil(Routes.loginView);
    }
  }

  callRefreshApi() async {
    RefreshTokenResponse refreshResp = await apiCall.refreshToken();
    switch (refreshResp.statusCode) {
      case Constants.sucessCode:
        setToken(refreshResp.token!);
        setTokenExpiryDate(refreshResp.utcExpiryDate!);

        break;
      case Constants.wrongError:
        AppUtil.showDialogbox(AppUtil.getContext(),
            refreshResp.error ?? 'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        AppUtil.showDialogbox(AppUtil.getContext(),
            refreshResp.error ?? 'Oops Something went wrong');

        break;
      default:
        {
          if (refreshResp.error != null && refreshResp.error!.isNotEmpty) {
            AppUtil.showDialogbox(AppUtil.getContext(),
                refreshResp.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
  }

  // set token to shared prefrences after login successfully
  setToken(String token) async {
    await SharedPre.setStringValue(SharedPre.LOGIN_TOKEN, token);
  }

  setTokenExpiryDate(DateTime TokenExpiryDate) async {
    await SharedPre.setDateTimeValue(
        SharedPre.LOGIN_EXPIRY_DATE, TokenExpiryDate);
  }
}
