import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/ui/screen/modules/user_module/submit_request/model/submit_responsemodel.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SubmitRegisterViewMode extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _firstname = '';
  String _lastname = '';

  String _email = '';
  String _accountname = '';
  String _mobilenumber = '';
  String _companyname = '';

  String value = '';
  bool value1 = false;
  late String _dropDownTrade = '  Select';

  String dropDownValue = '';

  List<String> trade = [
    'Plumbing',
    'HVAC',
    'Fire Services',
    'Electrical',
    'Building or other Trades',
  ];

  Api api = locator<Api>();

  String get firstname => _firstname;
  set firstname(String firstname) {
    _firstname = firstname;
    notifyListeners();
  }

  String get lastname => _lastname;
  set lastname(String lastname) {
    _lastname = lastname;
    notifyListeners();
  }

  String get dropDownTrade => _dropDownTrade;
  set dropDownTrade(String dropDownTrade) {
    _dropDownTrade = dropDownTrade;
    notifyListeners();
  }

  String get email => _email;
  set Email(String Email) {
    _email = Email;
    notifyListeners();
  }

  String get accountName => _accountname;
  set accountName(String accountName) {
    _accountname = accountName;
    notifyListeners();
  }

  String get mobileNumber => _mobilenumber;
  set mobileNumber(String mobileNumber) {
    _mobilenumber = mobileNumber;
    notifyListeners();
  }

  String get companyName => _companyname;
  set companyName(String companyName) {
    _companyname = companyName;
    notifyListeners();
  }

  // on login buttion clik
  onSubmitRequestButtonClick() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      callRequestLogin();
    } else {}
  }

  callRequestLogin() async {
    setBusy(true);
    var map = Map<String, dynamic>();
    map['first_name'] = firstNameController.text.toString();
    map['last_name'] = lastNameController.text.toString();
    map['mobile'] = mobileNumberController.text.toString();
    map['email'] = emailController.text.toString();
    map['company'] = companyNameController.text.toString();
    map['trade_type'] = dropDownTrade.toString();

    SubmitResponse submitResponse = await api.submitRegisterUser(map);
    switch (submitResponse.statusCode) {
      case Constants.sucessCode:
        AppUtil.showDialogboxforSuccess(
            AppUtil.getContext(),
            'Thank You!',
            'Your request has been sent successfully. Please check your email to continue.',
            0);
        break;
      case Constants.wrongError:
        AppUtil.showDialogbox(AppUtil.getContext(),
            submitResponse.error ?? 'Oops Something went wrong');
        // AppUtil.showToast(loginResp.error ?? '');

        break;
      case Constants.networkErroCode:
        AppUtil.showDialogbox(AppUtil.getContext(),
            submitResponse.error ?? 'Oops Something went wrong');
        // AppUtil.showToast(loginResp.error ?? '');
        break;
      default:
        {
          if (submitResponse.error != null &&
              submitResponse.error!.isNotEmpty) {
            //AppUtil.showToast(loginResp.error ?? '');
          }
        }
        break;
    }
    setBusy(false);
  }
}
