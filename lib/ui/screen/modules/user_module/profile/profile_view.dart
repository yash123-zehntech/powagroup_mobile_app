import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/helper_widget/double_icon_widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/ui/screen/modules/user_module/profile/profile_view_model.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onViewModelReady: (viewModel) {
        viewModel.getUserData();
      },
      builder: (context, viewModel, child) => Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(68),
            child: AppBarWidget(
              title: '',
              backIcon: null,
            ),
          ),
          backgroundColor: const Color(0xffEFF1F2),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 16),
            children: [
              profileContainer(viewModel),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  itemCount: viewModel.profileSectionList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return profileSectionItem(viewModel, index, context);
                  }),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  viewModel.onProfileFeaturesClick(9, context);
                },
                child: ButtonWidget(
                  buttonTitle: 'Log Out',
                  containerWidth: double.infinity,
                  containerHeigth: 58.h,
                  isBusy: false,
                ),
              ),
            ],
          )),
    );
  }

  // Return Profile Section Item
  Widget profileSectionItem(ProfileViewModel viewModel, int index, context) {
    return InkWell(
      onTap: () {
        viewModel.onProfileFeaturesClick(index, context);
      },
      child: Container(
        padding:
            EdgeInsets.only(top: 20.h, bottom: 20.h, left: 24.h, right: 24.h),
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xffFFFFFF)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              viewModel.profileSectionList[index],
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  color: const Color(0xff36393C)),
            ),
            doubleIcon()
          ],
        ),
      ),
    );
  }

  // Return Profile Container Widget
  Widget profileContainer(ProfileViewModel viewModel) {
    return viewModel.isBusy
        ? ShimmerLoading(
            isLoading: true,
            child: Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100],
              ),
            ))
        : Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: const Color(0xffFFFFFF)),
            padding:
                const EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      profileImage(viewModel),
                      const SizedBox(
                        height: 5,
                      ),
                      personNameWidget(viewModel),
                      const SizedBox(
                        height: 5,
                      ),
                      personEmailWidget(viewModel),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    callNowWidget(),
                    const SizedBox(
                      height: 8,
                    ),
                    numberWidget(),
                    const SizedBox(
                      height: 8,
                    ),
                    followUsWidget(),
                    const SizedBox(
                      height: 4,
                    ),
                    socialIcon()
                  ],
                ),
              ],
            ),
          );
  }

//return social Icon
  Widget socialIcon() => Row(
        children: [
          InkWell(
            onTap: () {
              AppUtil.launchURL(Constants.FACEBOOK_LOGIN_URL);
            },
            child: Container(
                height: 25.h,
                width: 25.h,
                child: Image.asset(
                  'assets/icon/facebook.png',
                )),
          ),
          SizedBox(
            width: 6.w,
          ),
          InkWell(
            onTap: () {
              AppUtil.launchURL(Constants.LINKDIN_LOGIN_URL);
            },
            child: Container(
              height: 25.h,
              width: 25.h,
              child: Image.asset(
                'assets/icon/linkedin.png',
              ),
            ),
          )
        ],
      );
  // Return Follow Us Widget
  Widget followUsWidget() {
    return Text(
      'follow on',
      style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: Globlas.deviceType == "phone" ? 10 : 20,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4,
          color: const Color(0xff858D93)),
    );
  }

  // Return Number Widget
  Widget numberWidget() {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse("tel:1300 303 366"));
      },
      child: Text(
        '1300 303 366',
        style: TextStyle(
            fontFamily: 'Poppins-SemiBold',
            fontSize: Globlas.deviceType == "phone" ? 18 : 28,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
            color: const Color(0xffD60505)),
      ),
    );
  }

  // Return Call Now Widget
  Widget callNowWidget() {
    return Text(
      'Call Now',
      style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: Globlas.deviceType == "phone" ? 14 : 24,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: const Color(0xff36393C)),
    );
  }

  // Return Person Email Widget
  Widget personEmailWidget(ProfileViewModel viewModel) {
    return Text(
      viewModel.userDetails != null &&
              viewModel.userDetails!.email != null &&
              viewModel.userDetails!.email != false
          ? viewModel.userDetails!.email!
          : '',
      style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: Globlas.deviceType == "phone" ? 12 : 22,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: const Color(0xff36393C)),
    );
  }

  // Return Person Name Widget
  Widget personNameWidget(ProfileViewModel viewModel) {
    return Text(
      viewModel.userDetails != null &&
              viewModel.userDetails!.name != null &&
              viewModel.userDetails!.name!.isNotEmpty
          ? viewModel.userDetails!.name!
          : '',
      style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: Globlas.deviceType == "phone" ? 16 : 26,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: const Color(0xff36393C)),
    );
  }

  // Return Profile Image
  Widget profileImage(ProfileViewModel viewModel) {
    return Container(
      width: 70.h,
      height: 70.h,
      alignment: Alignment.center,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Color(0xffF2F2F2)),
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
    );
  }
}
