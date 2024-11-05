import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/custom_fonts/my_flutter_app_icons.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/notification_truck.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_page_module/home_page_view_model.dart';
import 'package:powagroup/util/app_data.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/shared_preference.dart';
import 'package:powagroup/util/util.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class HomePageView extends StatelessWidget {
  int number = 1;
  int numberforCart = 0;

  HomePageView({Key? key, required this.number, required this.numberforCart})
      : super(key: key);

  // final List<Widget> _history = [];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onViewModelReady: (viewModel) async => {
              viewModel.controller = PersistentTabController(),
              viewModel.hideNavBar = false,
              viewModel.index = number,
              numberforCart = numberforCart,

              viewModel.getUserData(),
              // Future.delayed(Duration(seconds: 5)),
              viewModel.itemCount = await AppUtil.getCartProductLength()
              // Future.delayed(Duration(seconds: 4)).then((_) {
              //   // Delay completed, proceed with the third method
              //   AppUtil.getCartProductLength().then((cartLength) {
              //     // Handle the result of the third method
              //   }).catchError((error) {
              //     // Handle any errors from the third method
              //   });
              // }),

              // viewModel.notifyListeners(),
              // viewModel.getUserName()
            },
        builder: (context, viewModel, child) {
          return Scaffold(
            body: PageTransitionSwitcher(
              duration: const Duration(seconds: 1),
              transitionBuilder:
                  (child, primaryAnimation, secondaryAnimation) =>
                      FadeThroughTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              ),
              //child: viewModel.getBody(viewModel.index, numberforCart),
              child: PersistentTabView(
                popAllScreensOnTapAnyTabs: true,

                // viewModel.buildScreens(viewModel.index, numberforCart) == 3
                //     ? false
                //     : true,
                context,
                controller: viewModel.controller,
                onItemSelected: (int index) {
                  // index will give you the index of the selected navbar item
                  viewModel.index = index;
                  // You can use this index for any further processing or navigation
                },
                stateManagement:
                    // false,
                    viewModel.index == 3 || viewModel.index == 2

                        // &&
                        // Provider.of<AppData>(context).itemCount >= 1
                        ? false
                        : true,

                screens: viewModel.buildScreens(viewModel.index, numberforCart),
                items: navBarsItems(viewModel, context),
                resizeToAvoidBottomInset: true,
                navBarHeight: 62.h,
                bottomScreenMargin:
                    MediaQuery.of(context).viewInsets.bottom == 0 ? 60 : 0,
                decoration: NavBarDecoration(
                    colorBehindNavBar: Colors.white,
                    adjustScreenBottomPaddingOnCurve: true,
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          blurRadius: 10,
                          offset: Offset(0, -1)),
                    ]),
                backgroundColor: Color(0xffFFFFFF),
                hideNavigationBar: false,
                screenTransitionAnimation: const ScreenTransitionAnimation(
                  animateTabTransition: true,
                ),

                handleAndroidBackButtonPress: true,
                hideNavigationBarWhenKeyboardShows: true,
                navBarStyle: NavBarStyle
                    .style8, // Choose the nav bar style with this property
              ),
            ),

            // bottomNavigationBar: BottomNavigationBar(
            //     unselectedIconTheme: const IconThemeData(
            //       color: Color(0xff36393C),
            //       size: 20,
            //     ),
            //     selectedIconTheme: const IconThemeData(
            //       color: Color(0xffD60505),
            //       size: 21,
            //     ),
            //     selectedLabelStyle: TextStyle(
            //       fontFamily: 'Raleway',
            //       fontStyle: FontStyle.normal,
            //       fontSize: Globlas.deviceType == "phone" ? 11 : 21,
            //       letterSpacing: -0.33,
            //       fontWeight: FontWeight.w600,
            //       // color: const Color(0xff1B1D1E)
            //     ),
            //     unselectedLabelStyle: TextStyle(
            //       fontFamily: 'Raleway',
            //       fontStyle: FontStyle.normal,
            //       fontSize: Globlas.deviceType == "phone" ? 10 : 20,
            //       letterSpacing: -0.33,
            //       fontWeight: FontWeight.w600,
            //       // color: const Color(0xff36393C)
            //     ),
            //     items: <BottomNavigationBarItem>[
            //       BottomNavigationBarItem(
            //         icon: Icon(PowaGroupIcon.home_line, size: 30.h),
            //         activeIcon: Icon(PowaGroupIcon.home_2, size: 30.h),
            //         label: 'Home',
            //       ),
            //       BottomNavigationBarItem(
            //         icon: Icon(PowaGroupIcon.products_icon, size: 30.h),
            //         activeIcon: Icon(PowaGroupIcon.Product_icon, size: 30.h),
            //         label: 'Products',
            //       ),
            //       BottomNavigationBarItem(
            //         icon: Icon(
            //           MyFlutterApp.list_alt,
            //           size: 30.h,
            //           color: Color(0xff36393C).withOpacity(0.7),
            //         ),
            //         activeIcon: Icon(MyFlutterApp.list_alt, size: 30.h),
            //         label: 'Job lists',
            //       ),
            //       BottomNavigationBarItem(
            //         icon: NotificationTruck(
            //             key: key,
            //             notificationCount:
            //                 Provider.of<AppData>(context).itemCount,
            //             viewModel: viewModel,
            //             bottomBar: true),
            //         activeIcon: Icon(PowaGroupIcon.truck_icon, size: 25.h),
            //         label: '    Truck',
            //       ),
            //       BottomNavigationBarItem(
            //           icon: profileImage(viewModel), label: ''),
            //     ],
            //     type: BottomNavigationBarType.fixed,
            //     currentIndex: viewModel.index,
            //     selectedItemColor: const Color(0xff1B1D1E),
            //     onTap: (index) {
            //       viewModel.index = index;
            //     },
            //     elevation: 5),
            backgroundColor: const Color(0xffEFF1F2),
          );
        });
  }

  // bottom bar Text Theme
  TextStyle getStyle() {
    return TextStyle(
      fontFamily: 'Raleway',
      fontStyle: FontStyle.normal,
      fontSize: Globlas.deviceType == "phone" ? 11 : 21,
      letterSpacing: -0.33,
      fontWeight: FontWeight.w600,
      // color: const Color(0xff1B1D1E)
    );
  }

  List<PersistentBottomNavBarItem> navBarsItems(
          HomeViewModel viewModel, BuildContext context) =>
      [
        PersistentBottomNavBarItem(
            icon: Icon(PowaGroupIcon.home_2, size: 30.h),
            title: "Home",
            inactiveIcon: Icon(PowaGroupIcon.home_line, size: 30.h),
            textStyle: getStyle(),
            activeColorPrimary: Color(0xffD60505),
            inactiveColorPrimary: Color(0xff1B1D1E)),
        PersistentBottomNavBarItem(
            icon: Icon(PowaGroupIcon.Product_icon, size: 30.h),
            inactiveIcon: Icon(PowaGroupIcon.products_icon, size: 30.h),
            title: "Products",
            textStyle: getStyle(),
            activeColorPrimary: Color(0xffD60505),
            inactiveColorPrimary: Color(0xff1B1D1E)),
        PersistentBottomNavBarItem(
            icon: Icon(MyFlutterApp.list_alt, size: 30.h),
            inactiveIcon: Icon(
              MyFlutterApp.list_alt,
              size: 30.h,
              color: Color(0xff36393C).withOpacity(0.7),
            ),
            title: "Job lists favourites",
            textStyle: getStyle(),
            activeColorPrimary: Color(0xffD60505),
            inactiveColorPrimary: Color(0xff1B1D1E)),
        PersistentBottomNavBarItem(
            icon: Icon(PowaGroupIcon.truck_1, size: 30.h),
            title: "Truck",
            inactiveIcon: NotificationTruck(
                key: key,
                notificationCount: Provider.of<AppData>(context).itemCount,
                viewModel: viewModel,
                bottomBar: true),
            textStyle: getStyle(),
            activeColorPrimary: Color(0xffD60505),
            inactiveColorPrimary: Color(0xff1B1D1E)),
        PersistentBottomNavBarItem(icon: profileImage(viewModel)),
      ];

  // Return Profile Image
  Widget profileImage(HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
          //padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xffD60505), width: 1.2),
            shape: BoxShape.circle,
            // borderRadius: BorderRadius.all(Radius.circular(30.r)
            //)
          ),
          child: viewModel.userDetails != null
              ? Center(
                  child: Text(
                    viewModel.userDetails != null &&
                            viewModel.userDetails!.name != null &&
                            viewModel.userDetails!.name!.isNotEmpty
                        ? '${viewModel.userDetails!.name![0].toUpperCase()}${viewModel.userDetails!.name!.split(' ')[1][0].toUpperCase()}'
                        : '',
                    style: TextStyle(
                        fontFamily: 'Inter-Medium',
                        fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.33,
                        color: const Color(0xff8B8B8B)),
                  ),
                )
              : Center(
                  child: Icon(
                    Icons.person,
                    size: 28,
                    color: Colors.grey.shade500,
                  ),
                )
          // Image.asset(
          //     'assets/icon/Ellipse 513.png',
          //     fit: BoxFit.fitWidth,
          //     height: 38.h,
          //     width: 38.h,
          //   ),
          ),
    );
  }
}
