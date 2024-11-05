import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/bottom_contant_widget.dart';
import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/helper_widget/form_textfield.widget.dart';
import 'package:powagroup/helper_widget/header_contant_widget.dart';
import 'package:powagroup/helper_widget/header_sub_contant_widget.dart';
import 'package:powagroup/helper_widget/labal_field_contant_widget.dart';
import 'package:powagroup/ui/screen/modules/user_module/login/login_view_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/validator.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewMode>.reactive(
        viewModelBuilder: () => LoginViewMode(),
        onViewModelReady: (LoginViewMode viewModel) {
          // viewModel.emailController.text = "ann@treppidengineering.com.au";
          // viewModel.passwordController.text = "JhbGciOiJIUzI1";
          // viewModel.emailController.text = "khushi.kawade@zehntech.com";
          // viewModel.passwordController.text = "khushi@123";
        },
        builder: (context, viewModel, child) => Stack(children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/icon/blur.png'),
                        fit: BoxFit.cover),
                  )),
              Scaffold(
                  backgroundColor: Colors.transparent,
                  bottomNavigationBar: endContent(
                      viewModel, 'Not registered yet ?', ' Create Account'),
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: const Color(0xffC6F2E7).withOpacity(0.1),
                    elevation: 0,
                  ),
                  body: ListView(
                    padding: EdgeInsets.only(left: 20.h, right: 20.h),
                    children: <Widget>[
                      headerContent(
                          'Login', Globlas.deviceType == 'phone' ? 50.0 : 70.0),
                      SizedBox(
                        height: 5.h,
                      ),
                      headerSubContent('welcome back!',
                          Globlas.deviceType == 'phone' ? 17.0 : 25.0),
                      SizedBox(
                        height: 70.h,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 25, right: 25, top: 30.sp, bottom: 50),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: const Color(0XFFFFFFFF),
                            borderRadius: BorderRadius.circular(15.0.r)),
                        child: ListView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            getLoginForm(context, viewModel),
                            forgetPasswordContainer(context, viewModel),
                            SizedBox(
                              height: 20.h,
                            ),
                            InkWell(
                              onTap: () {
                                viewModel.onLoginButtonClick();
                              },
                              child: ButtonWidget(
                                buttonTitle: 'Log In',
                                containerWidth: double.infinity,
                                containerHeigth: 58.h,
                                isBusy: viewModel.isBusy,
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            loginRequestWidget(
                                viewModel,
                                'If your Company has an account,',
                                ' Request Login'),
                          ],
                        ),
                      ),
                    ],
                  ))
            ]));
  }

//return forgot password contant
  Widget forgetPasswordContainer(context, LoginViewMode viewModel) =>
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          viewModel.onForgotPasswordClick();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Forgot Password ?",
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: Globlas.deviceType == 'phone' ? 15 : 22,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff36393C)),
            ),
          ],
        ),
      );

//return Textfield
  Widget getLoginForm(context, LoginViewMode viewModel) => Form(
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
            Container(child: fieldContent('Password')),
            TextFormField(
              cursorColor: Color(0xffD60505),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              //onFieldSubmitted: _handleSubmitted,
              validator: (value) {
                if (value == null || value == "") {
                  return "Password is required";
                } else if (value.length < 6) {
                  return "Password must contain atleast 6 character";
                } else {
                  return null;
                }
              },
              // onChanged: ((value) => viewModel.password = value),
              controller: viewModel.passwordController,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Raleway',
                  fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
              obscureText: viewModel.passwordVisible,
              decoration: InputDecoration(
                enabled: viewModel.isBusy ? false : true,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: Globlas.deviceType == 'phone' ? 10 : 20,
                    vertical: Globlas.deviceType == 'phone' ? 12 : 15),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFD60505),
                  ),
                  //borderRadius: BorderRadius.circular(5),
                ),
                hintStyle: TextStyle(
                    color: const Color(0xff858D93),
                    fontWeight: FontWeight.w400,
                    fontSize: Globlas.deviceType == 'phone' ? 15 : 25),
                hintText: "Enter Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    viewModel.passwordVisible
                        ? PowaGroupIcon.eyes
                        : PowaGroupIcon.eye,
                    size: Globlas.deviceType == 'phone' ? 18 : 45,
                  ),
                  onPressed: () {
                    viewModel.passwordVisible = !viewModel.passwordVisible;
                  },
                ),
              ),
              onSaved: (value) => viewModel.password = value!,
            ),
          ],
        ),
      );
}
