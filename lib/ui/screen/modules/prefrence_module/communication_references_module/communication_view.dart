import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/custom_switch.dart';
import 'package:powagroup/ui/screen/modules/prefrence_module/communication_references_module/communication_view_model.dart';
import 'package:powagroup/ui/screen/modules/user_module/profile/profile_view_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:stacked/stacked.dart';

class CommunicationRefrencesView extends StatelessWidget {
  const CommunicationRefrencesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommunicationViewModel>.reactive(
      viewModelBuilder: () => CommunicationViewModel(),
      onViewModelReady: (viewModel) {},
      builder: (context, viewModel, child) => Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarWidget(
              backIcon: IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                padding: EdgeInsets.only(left: 5.h),
                icon: Icon(
                  PowaGroupIcon.back,
                  size: 24.h,
                  color: const Color(0xff36393C),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: 'Communication References',
            ),
          ),
          backgroundColor: const Color(0xffEFF1F2),
          body: ListView.builder(
            padding: EdgeInsets.only(left: 16.h, right: 16.h, top: 16.h),
            itemCount: viewModel.subSectionList.length,
            itemBuilder: (BuildContext context, int index) {
              return subFeatureSection(viewModel, index);
            },
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
          )),
    );
  }

  // Return Profile Section Item
  Widget subFeatureSection(CommunicationViewModel viewModel, int index) {
    return InkWell(
      onTap: () {
        //viewModel.onProfileFeaturesClick(index);
      },
      child: Container(
        padding:
            EdgeInsets.only(top: 20.h, bottom: 20.h, left: 24.h, right: 24.h),
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: const Color(0xffFFFFFF)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              viewModel.subSectionList[index],
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  color: const Color(0xff36393C)),
            ),
            FlutterSwitch(
              width: 32.0.w,
              height: 18.0.h,
              disabled: false,
              showOnOff: true,
              valueFontSize: 0.0,
              inactiveColor: const Color(0xff858D93).withOpacity(0.3),
              activeColor: const Color(0xff858D93).withOpacity(0.3),
              activeToggleColor: const Color(0xffD60505),
              inactiveToggleColor: const Color(0xff858D93),
              toggleSize: 19.0.h,
              padding: 0.0,
              value: viewModel.isEnabled,
              onToggle: (val) {
                // viewModel.isEnabled = val; // In Future
              },
            ),
            // FlutterSwitch(
            //     value: viewModel.isEnabled,
            //     showOnOff: true,
            //     width: 35.0,
            //     height: 18.0,
            //     toggleSize: 5.0,
            //     valueFontSize: 0,
            //     onToggle: (value) {
            //       viewModel.isEnabled = !viewModel.isEnabled;
            //     }),
          ],
        ),
      ),
    );
  }
}
