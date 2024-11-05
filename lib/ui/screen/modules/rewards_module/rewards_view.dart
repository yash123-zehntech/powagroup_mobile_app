import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';

import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/ui/screen/modules/rewards_module/rewards_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:stacked/stacked.dart';

class RewardsView extends StatelessWidget {
  const RewardsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RewardsViewMode>.reactive(
        viewModelBuilder: () => RewardsViewMode(),
        onViewModelReady: (viewModel) => {},
        builder: (context, viewModel, child) => Scaffold(
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: InkWell(
                  onTap: () {
                    // viewModel.onLogInButtonClick();
                  },
                  child: ButtonWidget(
                    isBusy: false,
                    buttonTitle: 'Share Code',
                    containerWidth: double.infinity,
                    containerHeigth: 58.h,
                  ),
                ),
              ),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: AppBarWidget(
                  title: 'Powabuddy/Powarewards',
                  backIcon: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    padding: const EdgeInsets.only(left: 5),
                    icon: Icon(
                      PowaGroupIcon.arrow_back,
                      size: 24.h,
                      color: const Color(0xff36393C),
                    ),
                    onPressed: () {
                      //viewModel.navigationService.back();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              backgroundColor: Color(0xffEFF1F2),
              body: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    // const Spacer(
                    //   flex: 2,
                    // ),
                    headerContant(),
                    // SizedBox(
                    //   height: 20.h,
                    // ),
                    Spacer(),
                    shareIcon(PowaGroupIcon.share),
                    content('Share Your Link'),
                    descriptionContent(context,
                        'Invite friends to create an account so they can enjoyas much as you do!'),
                    // SizedBox(
                    //   height: 15.h,
                    // ),
                    Spacer(),
                    shareIcon(PowaGroupIcon.cart_icon),
                    content('Friend Buys Something'),
                    descriptionContent(context,
                        "Every friend you refer will receive a \$20 voucher once they create their account ( Minimum spend \$99. Valid on full price items only)"),
                    // SizedBox(
                    //   height: 15.h,
                    // ),
                    Spacer(),
                    shareIcon(PowaGroupIcon.credit_icon),
                    content('Earn \$20 Credit!'),
                    descriptionContent(context,
                        "If your friend keeps their purchase, adfter 30 day we’ll add \$20 credit to your account."),
                    Spacer(),
                    // const Spacer(
                    //   flex: 3,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 30, right: 30),
                    //   child: InkWell(
                    //     onTap: () {
                    //       // viewModel.onLogInButtonClick();
                    //     },
                    //     child: ButtonWidget(
                    //       isBusy: false,
                    //       buttonTitle: 'Share Code',
                    //       containerWidth: double.infinity,
                    //       containerHeigth: 58.h,
                    //     ),
                    //   ),
                    // ),
                    // const Spacer(
                    //   flex: 2,
                    // ),
                  ],
                ),
              ),
            ));
  }

//return header widget
  Widget headerContant() => Text('How It Work',
      textAlign: TextAlign.center,
      style: TextStyle(
          //color: Colors.black,
          fontFamily: 'Raleway',
          // fontWeight: FontWeight.bold,
          color: const Color(0xff1B1D1E),
          // fontFamily: 'Raleway',
          fontWeight: FontWeight.w800,
          fontSize: Globlas.deviceType == 'phone' ? 22 : 32));

//return success Icon widget
  Widget shareIcon(icon) => Container(
        height: 60.h,
        width: 60.w,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xff33A3E4),
        ),
        alignment: Alignment.center,
        child: Icon(icon,
            color: Colors.white, size: Globlas.deviceType == 'phone' ? 40 : 80),
      );

//return success contant
  Widget content(text) => Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: const Color(0xff1B1D1E),
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w700,
                  fontSize: Globlas.deviceType == 'phone' ? 16 : 26)),
          const SizedBox(
            height: 8,
          ),
        ],
      );

//return sub contant
  Widget descriptionContent(context, text) => Container(
        // color: Colors.amberAccent,
        width: MediaQuery.of(context).size.width / 1.5,
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color(0xff36393C),
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
                fontSize: Globlas.deviceType == 'phone' ? 15 : 22)),
      );

  // Return Login Button Widget
}
