import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';

import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/helper_widget/form_textfield.widget.dart';
import 'package:powagroup/helper_widget/header_contant_widget.dart';
import 'package:powagroup/helper_widget/header_sub_contant_widget.dart';
import 'package:powagroup/ui/screen/modules/user_module/delete_user_account/delete_user_account_view_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/validator.dart';
import 'package:stacked/stacked.dart';

class DeleteAccountView extends StatelessWidget {
  const DeleteAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/icon/blur.png'), fit: BoxFit.cover),
          )),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                //viewModel.navigationService.back();
                Navigator.pop(context);
              },
              icon: Icon(
                PowaGroupIcon.arrow_back,
                color: const Color(0xff36393C),
                size: 25.h,
              ),
            ),
            backgroundColor: const Color(0xffC6F2E7).withOpacity(0.1),
            elevation: 0,
          ),
          body: ViewModelBuilder<DeleteAccountViewMode>.reactive(
              viewModelBuilder: () => DeleteAccountViewMode(),
              onViewModelReady: (viewModel) => {},
              builder: (context, viewModel, child) => ListView(
                    padding: EdgeInsets.only(left: 20.h, right: 20.h),
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          headerContent('Delete Account',
                              Globlas.deviceType == 'phone' ? 40.0 : 60.0),
                          SizedBox(
                            height: 5.h,
                          ),
                          headerSubContent(
                              'Enter Your registered Email Address',
                              Globlas.deviceType == 'phone' ? 17.0 : 27.0),
                          SizedBox(
                            height: 100.h,
                          ),
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 2 / 6.8,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: const Color(0XFFFFFFFF),
                            borderRadius: BorderRadius.circular(15.0.r)),
                        child: ListView(
                          padding: const EdgeInsets.only(
                            left: 30,
                            right: 30,
                            top: 30,
                          ),
                          children: [
                            getDeleteAccountForm(context, viewModel),
                            InkWell(
                              onTap: () {
                                viewModel.onSubmitButtonClick();
                              },
                              child: ButtonWidget(
                                isBusy: viewModel.isBusy,
                                buttonTitle: 'Submit',
                                containerWidth: double.infinity,
                                containerHeigth: 58.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))),
    ]);
  }

//retrun  email text field for password
  Widget getDeleteAccountForm(context, DeleteAccountViewMode viewModel) => Form(
        key: viewModel.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                child: formField(
                    viewModel,
                    'Email ',
                    context,
                    'Your email address',
                    PowaGroupIcon.email,
                    TextInputType.emailAddress,
                    viewModel.emailController,
                    Validation.emailValidate,
                    viewModel.isBusy,
                    false)),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );
}
