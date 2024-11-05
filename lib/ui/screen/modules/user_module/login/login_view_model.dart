import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/model/user_model.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/auth_provider.dart';
import 'package:powagroup/ui/screen/modules/user_module/login/response_model/login_response.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/shared_preference.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../../services/globals.dart';

class LoginViewMode extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _passwordVisible = true;
  bool value = true;

  Api apiCall = locator<Api>();

  String get userName => _username;
  set userName(String userName) {
    _username = userName;
    notifyListeners();
  }

  String get password => _password;
  set password(String password) {
    _password = password;
    notifyListeners();
  }

  bool get passwordVisible => _passwordVisible;
  set passwordVisible(bool passwordVisible) {
    _passwordVisible = passwordVisible;
    notifyListeners();
  }

  // on login buttion clik
  onLoginButtonClick() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      callLoginApi();
    } else {}
  }

  onForgotPasswordClick() {
    navigationService.navigateTo(Routes.forgotPasswordView);
  }

  onCreateAccountClick() {
    navigationService.navigateTo(Routes.registerView);
  }

  onRequestForLoginClick() {
    navigationService.navigateTo(Routes.submitRegisterView);
  }

  //  send otp api calling
  callLoginApi() async {
    setBusy(true);

    var map = Map<String, dynamic>();
    map['email'] = emailController.text.toString();
    map['password'] = passwordController.text.toString();
    // "JhbGciOiJIUzI1";
    map['device_id'] = Globals.getDeviceId;
    map['push_token'] = Globals.getFCMToken;
    // map['utc_expiry_date'] = "2024-04-13 05:01:33";

    //passwordController.text.toString();

    LoginResponse loginResp = await apiCall.userLogin(map);

    switch (loginResp.statusCode) {
      case Constants.sucessCode:
        setToken(loginResp.token!);
        setTokenExpiryDate(loginResp.utcExpiryDate!);

        String firstTwoCharacters =
            emailController.text[0].toUpperCase() + emailController.text[1];

        setUserName(firstTwoCharacters);

        navigationService.pushNamedAndRemoveUntil(Routes.homePageView,
            arguments: HomePageViewArguments(number: 0, numberforCart: 0));

        break;
      case Constants.wrongError:
        AppUtil.showDialogbox(AppUtil.getContext(),
            loginResp.error ?? 'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        AppUtil.showDialogbox(AppUtil.getContext(),
            loginResp.error ?? 'Oops Something went wrong');

        break;
      default:
        {
          if (loginResp.error != null && loginResp.error!.isNotEmpty) {
            AppUtil.showDialogbox(AppUtil.getContext(),
                loginResp.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    setBusy(false);
  }

  // set token to shared prefrences after login successfully
  setToken(String token) async {
    await SharedPre.setStringValue(SharedPre.LOGIN_TOKEN, token);
  }

  setTokenExpiryDate(DateTime TokenExpiryDate) async {
    await SharedPre.setDateTimeValue(
        SharedPre.LOGIN_EXPIRY_DATE, TokenExpiryDate);
  }

  setUserName(String name) async {
    await SharedPre.setStringValue(SharedPre.USERNAME, name);
  }
}
