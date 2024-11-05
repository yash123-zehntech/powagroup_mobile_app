import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';

import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/ui/screen/modules/address_module/address_view.dart';
import 'package:powagroup/ui/screen/modules/successfull_module/success_model.dart';
import 'package:powagroup/ui/screen/modules/user_module/login/login_view_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';

class SuccessView extends StatelessWidget {
  String? buttonText;
  String? message;
  SuccessView({Key? key, this.buttonText, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/icon/blur.png'), fit: BoxFit.fill),
          )),
      Scaffold(
          backgroundColor: Colors.transparent,
          body: ViewModelBuilder<SuccessViewMode>.reactive(
              viewModelBuilder: () => SuccessViewMode(),
              onViewModelReady: (viewModel) => {},
              builder: (context, viewModel, child) => Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        const Spacer(
                          flex: 5,
                        ),
                        successIcon(),
                        const Spacer(
                          flex: 2,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            successContent(buttonText),
                            const SizedBox(
                              height: 8,
                            ),
                            // successSubContent(message),
                            successSubContent(),
                          ],
                        ),
                        const Spacer(
                          flex: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: InkWell(
                            onTap: () {
                              viewModel.onLogInButtonClick();
                            },
                            child: ButtonWidget(
                              isBusy: false,
                              buttonTitle: 'Log In',
                              containerWidth: double.infinity,
                              containerHeigth: 58.h,
                            ),
                          ),
                        ),
                        const Spacer(
                          flex: 5,
                        ),
                      ],
                    ),
                  )))
    ]);
  }

//return success Icon widget
  Widget successIcon() => Container(
        height: 100.h,
        width: 100.w,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xff33A3E4),
        ),
        alignment: Alignment.center,
        child: Icon(PowaGroupIcon.success,
            color: Colors.white, size: Globlas.deviceType == 'phone' ? 50 : 80),
      );

//return success contant
  Widget successContent(String? buttonText) => buttonText == null
      ? Text('Successfully',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: const Color(0xff1B1D1E),
              fontFamily: 'Raleway-ExtraBold',
              fontWeight: FontWeight.w800,
              fontSize: Globlas.deviceType == 'phone' ? 40 : 60))
      : Text(buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: const Color(0xff1B1D1E),
              fontFamily: 'Raleway-ExtraBold',
              fontWeight: FontWeight.w800,
              fontSize: Globlas.deviceType == 'phone' ? 40 : 60));

//return sub contant
  Widget successSubContent() => Padding(
        padding: const EdgeInsets.only(left: 50.0, right: 50),
        child: Text(
            'Password reset request was sent successfully please check your email to reset your password',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color(0xff36393C),
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
                fontSize: Globlas.deviceType == 'phone' ? 14 : 21)),
      );
}
