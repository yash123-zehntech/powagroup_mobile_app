import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/custom_fonts/my_flutter_app_icons.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/notification_truck.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/globals.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/cart_module/cart_view.dart';

import 'package:powagroup/ui/screen/modules/favorite_module/all_product_module/favorite_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/home_page_data_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/product_subcategory_item_view.dart';
import 'package:powagroup/ui/screen/modules/user_module/profile/response_model.dart/user_profile_model.dart';
import 'package:powagroup/util/app_data.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/shared_preference.dart';
import 'package:powagroup/util/util.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_category_module/product_category_view.dart';
import 'package:powagroup/ui/screen/modules/user_module/profile/profile_view.dart';

class HomeViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  int _index = 0;
  int _itemCount = 0;
  PersistentTabController? controller;
  bool? hideNavBar;
  Api apiCall = locator<Api>();

  HiveDbServices<UserObject> _localDb = HiveDbServices(Constants.user_data);
  UserObject? userDetails;

  int get index => _index;

  set index(int index) {
    _index = index;
    notifyListeners();
  }

  int get itemCount => _itemCount;
  set itemCount(int itemCount) {
    _itemCount = itemCount;
    notifyListeners();
  }

  // Widget? getBody(int index, int numberforCart) {
  //   switch (index) {
  //     case 0:
  //       return HomePageDataView();
  //     case 1:
  //       return const ProductCategoryView();
  //     case 2:
  //       return const FavoriteView();
  //     case 3:
  //       return numberforCart == 3
  //           ? CartView(
  //               index: 3,
  //               value: Globals.cartBoardList[3],
  //             )
  //           : numberforCart == 2
  //               ? CartView(
  //                   index: 2,
  //                   value: Globals.cartBoardList[2],
  //                 )
  //               : numberforCart == 1
  //                   ? CartView(
  //                       index: 1,
  //                       value: Globals.cartBoardList[1],
  //                     )
  //                   : numberforCart == 0
  //                       ? CartView(
  //                           index: 0,
  //                           value: Globals.cartBoardList[0],
  //                         )
  //                       : CartView(
  //                           index: 0,
  //                           value: Globals.cartBoardList[
  //                               0]); //ReviewPage(value: Globals.cartBoardList[0]);
  //     case 4:
  //       return const ProfileView();
  //   }
  // }

  List<Widget> buildScreens(int bottomIndex, int numberforCart) {
    return [
      HomePageDataView(),
      ProductCategoryView(),
      FavoriteView(),
      bottomIndex == 3
          ? numberforCart == 3
              ? CartView(
                  index: 3,
                  value: Globals.cartBoardList[3],
                )
              : numberforCart == 2
                  ? CartView(
                      index: 2,
                      value: Globals.cartBoardList[2],
                    )
                  : numberforCart == 1
                      ? CartView(
                          index: 1,
                          value: Globals.cartBoardList[1],
                        )
                      : numberforCart == 0
                          ? CartView(
                              index: 0,
                              value: Globals.cartBoardList[0],
                            )
                          : CartView(index: 0, value: Globals.cartBoardList[0])
          : CartView(
              index: 0,
              value: Globals.cartBoardList[
                  0]), //ReviewPage(value: Globals.cartBoardList[0]);
      ProfileView()
    ];
  }

  // getBedgeCount() async {
  //   itemCount = await AppUtil.getCartProductLength();
  //   notifyListeners();
  // }

  // get User Data from local db
  // void getUserData() async {
  //   UserObject? _userData = await _localDb.get();

  //   if (_userData != null) {
  //     userDetails = _userData;
  //   }
  // }

  // get User Data from local db
  void getUserData() async {
    UserObject? _userData = await _localDb.get();
    String loginToken = await AppUtil.getLoginToken();

    if (loginToken != null && loginToken.isNotEmpty) {
      if (_userData == null) {
        setBusy(true);
      } else {
        userDetails = _userData;
        // setUserData();
      }

      UserProfile? userProfileData = await apiCall.getUserObject();

      switch (userProfileData.statusCode) {
        case Constants.sucessCode:
          await _localDb.clear();
          if (userProfileData != null && userProfileData.user != null) {
            userDetails = userProfileData.user;
            setUserID(userProfileData.user!.id!);
            _localDb.putData(Constants.user_data, userDetails);
          }

          _userData = await _localDb.get();

          userDetails = _userData;

          // setUserData();

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

  setUserID(int userId) async {
    await SharedPre.setIntValue(SharedPre.userId, userId);
  }
}
