import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/user_module/profile/response_model.dart/user_profile_model.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/shared_preference.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UserProfileViewModel extends BaseViewModel {
  UserObject? userDetails;
  SharedPre sharedPre = SharedPre();
  final navigationService = locator<NavigationService>();
  Api apiCall = locator<Api>();

  HiveDbServices<UserObject> _localDb = HiveDbServices(Constants.user_data);

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // get User Data from local db
  void getUserData() async {
    UserObject? _userData = await _localDb.get();
    String loginToken = await AppUtil.getLoginToken();

    if (loginToken != null && loginToken.isNotEmpty) {
      if (_userData == null) {
        setBusy(true);
      } else {
        userDetails = _userData;
        setUserData();
      }

      UserProfile? userProfileData = await apiCall.getUserObject();

      switch (userProfileData.statusCode) {
        case Constants.sucessCode:
          await _localDb.clear();
          if (userProfileData != null && userProfileData.user != null) {
            userDetails = userProfileData.user;
            _localDb.putData(Constants.user_data, userDetails);
          }

          _userData = await _localDb.get();

          userDetails = _userData;

          setUserData();

          break;
        case Constants.wrongError:
          AppUtil.showDialogbox(AppUtil.getContext(),
              userProfileData.error ?? 'Oops Something went wrong');

          break;
        case Constants.networkErroCode:
          AppUtil.showDialogbox(AppUtil.getContext(),
              userProfileData.error ?? 'Oops Something went wrong');
          break;
        default:
          {
            if (userProfileData.error != null &&
                userProfileData.error!.isNotEmpty) {
              //isAPIError = true;
              AppUtil.showDialogbox(AppUtil.getContext(),
                  userProfileData.error ?? 'Oops Something went wrong');
            }
          }
          break;
      }
      setBusy(false);
    } else {
      AppUtil.showLoginMessageDialog(AppUtil.getContext(),
          'Please Sign In/Register to view your personal details');
    }
  }

  // Set User data to view
  setUserData() {
    nameController.text = userDetails!.name!;
    emailController.text = userDetails!.email!;
    addressController.text =
        '${userDetails!.street1}, ${userDetails!.city}, ${userDetails!.state}, ${userDetails!.country}';
    phoneController.text = userDetails!.phone!.isNotEmpty
        ? userDetails!.phone!
        : userDetails!.mobile!.isNotEmpty
            ? userDetails!.mobile!
            : 'N/A';
  }
}
