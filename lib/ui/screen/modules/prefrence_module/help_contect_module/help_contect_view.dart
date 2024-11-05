import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/double_icon_widget.dart';
import 'package:powagroup/ui/screen/modules/prefrence_module/communication_references_module/communication_view_model.dart';
import 'package:powagroup/ui/screen/modules/prefrence_module/help_contect_module/help_contect_view_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpContectView extends StatelessWidget {
  const HelpContectView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HelpContectViewModel>.reactive(
      viewModelBuilder: () => HelpContectViewModel(),
      onViewModelReady: (viewModel) {},
      builder: (context, viewModel, child) => Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarWidget(
              backIcon: IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                padding: const EdgeInsets.only(left: 5),
                icon: Icon(
                  PowaGroupIcon.back,
                  size: 24.h,
                  color: const Color(0xff36393C),
                ),
                onPressed: () {
                  // viewModel.navigationService.back();
                  Navigator.pop(context);
                },
              ),
              title: 'About Us/Help/Contact',
            ),
          ),
          backgroundColor: const Color(0xffEFF1F2),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 16),
            children: [
              profileContainer(),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  itemCount: viewModel.subSectionList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return subSectionItem(viewModel, index);
                  })
            ],
          )),
    );
  }

  // Return Profile Section Item
  Widget subSectionItem(HelpContectViewModel viewModel, int index) {
    return InkWell(
      onTap: () {
        viewModel.onItemClick(index);
        //viewModel.onProfileFeaturesClick(index);
      },
      child: Container(
        padding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 24, right: 24),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
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
            doubleIcon()
          ],
        ),
      ),
    );
  }

  // Return Profile Container Widget
  Widget profileContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: const Color(0xffFFFFFF)),
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          callNowWidget(),
          const SizedBox(
            height: 10,
          ),
          emailWidget(),
        ],
      ),
    );
  }

  // Return Call Now Widget
  Widget callNowWidget() {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse("tel:1300 303 366"));
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: "Call Now :",
            style: TextStyle(
              fontFamily: 'Raleway',
              letterSpacing: -0.4,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: const Color(0xff36393C),
              fontSize: Globlas.deviceType == "phone" ? 14 : 24,
            ),
            children: [
              TextSpan(
                  text: " 1300 303 366",
                  style: TextStyle(
                      fontFamily: 'Poppins-SemiBold',
                      fontSize: Globlas.deviceType == "phone" ? 18 : 28,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4,
                      color: const Color(0xffD60505)))
            ]),
      ),
    );
  }

  // Return Email Widget
  Widget emailWidget() {
    return InkWell(
      onTap: () async {
        final Uri params = Uri(
          scheme: 'mailto',
          path: 'sales@powagroup.com',
        );
        String url = params.toString();
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {}
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: "Email :",
            style: TextStyle(
              fontFamily: 'Raleway',
              letterSpacing: -0.4,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: const Color(0xff36393C),
              fontSize: Globlas.deviceType == "phone" ? 14 : 24,
            ),
            children: [
              TextSpan(
                  text: " sales@powagroup.com",
                  style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.4,
                      color: const Color(0xff1B1D1E)))
            ]),
      ),
    );
  }
}
