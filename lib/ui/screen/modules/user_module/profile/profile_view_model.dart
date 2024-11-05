import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/helper_widget/navigation_widget.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/prefrence_module/communication_references_module/communication_view.dart';
import 'package:powagroup/ui/screen/modules/prefrence_module/help_contect_module/help_contect_view.dart';
import 'package:powagroup/ui/screen/modules/quotation_module/quotation_view.dart';
import 'package:powagroup/ui/screen/modules/return_module/return_view.dart';
import 'package:powagroup/ui/screen/modules/rewards_module/rewards_view.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/sales_order_view.dart';
import 'package:powagroup/ui/screen/modules/user_module/profile/response_model.dart/user_profile_model.dart';
import 'package:powagroup/ui/screen/modules/user_module/user_profile/user_profile_screen.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/shared_preference.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileViewModel extends BaseViewModel {
  UserObject? userDetails;
  SharedPre sharedPre = SharedPre();
  final navigationService = locator<NavigationService>();
  Api apiCall = locator<Api>();

  HiveDbServices<UserObject> _localDb = HiveDbServices(Constants.user_data);

  List<String> profileSectionList = [
    "Quotations",
    "Sales Orders",
    //"Invoices/Bills",
    "About Us/Help/Contact",
    "Powabuddy/Powarewards",
    "Returns",
    "Delivery Addresses/Contacts",
    //"Communication References",
    "Delete Account"
  ];

  // on login buttion clik
  onProfileFeaturesClick(int index, context) {
    if (index == 0) {
      navigate(QuotationView(), Routes.quotationView, context);
    } else if (index == 1) {
      navigate(SalesOrderView(), Routes.salesOrderView, context);
    } else if (index == 2) {
      navigate(const HelpContectView(), Routes.helpContectView, context);
    } else if (index == 3) {
      navigate(const RewardsView(), Routes.rewardsView, context);
    } else if (index == 4) {
      navigate(const ReturnView(), Routes.returnView, context);
    } else if (index == 5) {
      navigate(const UserProfileScreen(), Routes.returnView, context);
    } else if (index == 6) {
      AppUtil.launchURL(Constants.Mail_URL);
    }
    // else if (index == 7) {
    //   navigate(const CommunicationRefrencesView(),
    //       Routes.communicationRefrencesView, context);
    // } else if (index == 8) {
    // }
    else if (index == 9) {
      SharedPre.clearAll();
      AppUtil.clearCartData();
      AppUtil.clearFavouritesData();
      AppUtil.clearJoblistData();
      navigationService.pushNamedAndRemoveUntil(Routes.loginView);
    }
  }

  // Clear hive records
  void clearHiveRecords() async {
    var appDir = await getApplicationDocumentsDirectory();
    var hiveDb = Directory('${appDir.path}');
    hiveDb.delete(recursive: true);
  }

  // get User Data from local db
  void getUserData() async {
    UserObject? _userData = await _localDb.get();
    String loginToken = await AppUtil.getLoginToken();

    if (loginToken != null && loginToken.isNotEmpty) {
      if (_userData == null) {
        setBusy(true);
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
        userDetails = _userData;
      }
    } else {
      AppUtil.showLoginMessageDialog(AppUtil.getContext(),
          'Please Sign In/Register to view your personal details');
    }
  }
}
