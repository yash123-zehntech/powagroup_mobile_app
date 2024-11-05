import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/form_field_user_profile.dart';
import 'package:powagroup/ui/screen/modules/user_module/user_profile/user_profile_model.dart';
import 'package:powagroup/util/validator.dart';
import 'package:stacked/stacked.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserProfileViewModel>.reactive(
      viewModelBuilder: () => UserProfileViewModel(),
      onViewModelReady: (viewModel) {
        viewModel.getUserData();
      },
      builder: (context, viewModel, child) => Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(68),
            child: AppBarWidget(
              title: 'Delivery Addresses/Contacts',
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
                  //viewModel.navigationService.back();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          backgroundColor: const Color(0xffEFF1F2),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 16),
            children: [
              profileDetailsView(viewModel, context),
            ],
          )),
    );
  }

  // Return Profile Details View
  Widget profileDetailsView(
      UserProfileViewModel viewModel, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            child: formFieldUserProfile(
          viewModel,
          'Name :',
          context,
          PowaGroupIcon.user_icon,
          viewModel.nameController,
          viewModel.isBusy,
        )),
        Container(
            child: formFieldUserProfile(
          viewModel,
          'Address :',
          context,
          Icons.location_on,
          viewModel.addressController,
          viewModel.isBusy,
        )),
        Container(
            child: formFieldUserProfile(
          viewModel,
          'Phone :',
          context,
          PowaGroupIcon.phone,
          viewModel.phoneController,
          viewModel.isBusy,
        )),
        Container(
            child: formFieldUserProfile(
          viewModel,
          'Email :',
          context,
          Icons.email,
          viewModel.emailController,
          viewModel.isBusy,
        )),
      ],
    );
  }
}
