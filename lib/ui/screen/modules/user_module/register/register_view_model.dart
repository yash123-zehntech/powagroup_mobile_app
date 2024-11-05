import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/ui/screen/modules/user_module/register/model/register_reponsemodel.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RegisterViewMode extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController accountEmailController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController accountLastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController abnController = TextEditingController();
  TextEditingController acnController = TextEditingController();
  TextEditingController businessAddController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController cityAddController = TextEditingController();

  TextEditingController monthlySpendController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FocusNode firstNameNode = FocusNode();
  final FocusNode lastNameNode = FocusNode();
  final FocusNode mobileNumberNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode accountNameNode = FocusNode();
  final FocusNode accountLastNameNode = FocusNode();
  final FocusNode accountEmailNode = FocusNode();
  final FocusNode accountPhoneNumberNode = FocusNode();
  final FocusNode companyNameNode = FocusNode();
  final FocusNode abnNode = FocusNode();
  final FocusNode acnNode = FocusNode();
  final FocusNode businessAddNode = FocusNode();
  final FocusNode postCodeNode = FocusNode();
  final FocusNode tradeNode = FocusNode();
  final FocusNode stateNode = FocusNode();

  String _firstname = '';
  String _lastname = '';
  String _password = '';
  String _email = '';
  String _accountEmail = '';
  String _accountname = '';
  String _mobilenumber = '';
  String _phonenumber = '';
  String _companyname = '';
  String _abn = '';
  String _acn = '';
  String _bussinessadd = '';
  String _postcode = '';
  String value = '';
  bool value1 = false;
  late String _dropDownTrade = '  Select';
  String _dropDownAct = '   ACT';
  String _dropDownHereAbout = '   Seacrh Engines (Google)';
  String _dropDownAccount = '  Select';
  String dropDownValue = '';
  bool allcheck = true;
  int checkCount = 0;
  bool isButtonClick = true;
  String _workType = '   High-Rise';
  List<CheckboxList> CheckboxListItem = [
    CheckboxList(
      title: 'TICK: I am a Qualified trades person',
      isSelect: true,
    ),
    CheckboxList(
      title: 'TICK: Subscribe to POWAGROUP updates & POWAREWARDS',
      isSelect: true,
    ),
    CheckboxList(
      title: 'TICK: I agree to POWAGROUP Terms and conditions',
      isSelect: true,
    ),
  ];

  List<String> trade = [
    'Plumbing',
    'HVAC',
    'Fire Services',
    'Electrical',
    'Building or other Trades',
  ];

  List<String> act = ['NSW', 'NT', 'QLD', 'SA', 'VIC', 'WA'];
  List<String> hereAbout = [
    'Search Engines (Google)',
    'From a Mate',
    'Social Media',
    'Saw our Powagroup boxes/vans',
    'Weekly Powagroup Emails',
    'Other'
  ];

  List<String> accountType = [
    'C.O.D TRADE ACCOUNT',
    '3o DAY EOM TRADE ACCOUNT'
  ];

  List<String> workType = [
    'High-Rise',
    'Commercial',
    'Residental',
    'Maintenance',
    'Other'
  ];

  Api api = locator<Api>();
  bool _isKeyBoardOpen = false;

  bool get isKeyBoardOpen => _isKeyBoardOpen;
  set isKeyBoardOpen(bool isKeyBoardOpen) {
    _isKeyBoardOpen = isKeyBoardOpen;
    notifyListeners();
  }

  void setKeyboardOpen(bool value) {
    isKeyBoardOpen = value;
    notifyListeners(); // Notify listeners to update the UI
  }

  double _targetPadding = 0.0;
  double get targetPadding => _targetPadding;
  set targetPadding(double targetPadding) {
    _targetPadding = targetPadding;
    notifyListeners();
  }

  double calculatePadding(BuildContext context) {
    final bottomViewInsets = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = AppUtil.displayHeight(context);

    targetPadding =
        bottomViewInsets > 0 ? screenHeight * 0.30 : screenHeight * 0.09;

    return targetPadding;
  }

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

  String get accountEmail => _accountEmail;
  set accountEmail(String accountEmail) {
    _accountEmail = accountEmail;
    notifyListeners();
  }

  String get dropDownTrade => _dropDownTrade;
  set dropDownTrade(String dropDownTrade) {
    _dropDownTrade = dropDownTrade;
    notifyListeners();
  }

  String get dropDownAct => _dropDownAct;
  set dropDownAct(String dropDownAct) {
    _dropDownAct = dropDownAct;
    notifyListeners();
  }

  String get dropDownHereAbout => _dropDownHereAbout;
  set dropDownHereAbout(String dropDownHereAbout) {
    _dropDownHereAbout = dropDownHereAbout;
    notifyListeners();
  }

  String get worksType => _workType;
  set worksType(String worksType) {
    _workType = worksType;
    notifyListeners();
  }

  String get dropDownAccount => _dropDownAccount;
  set dropDownAccount(String dropDownAccount) {
    _dropDownAccount = dropDownAccount;
    notifyListeners();
  }

  String get password => _password;
  set password(String password) {
    _password = password;
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

  String get phonenumber => _phonenumber;
  set phonenumber(String phonenumber) {
    _phonenumber = phonenumber;
    notifyListeners();
  }

  String get companyName => _companyname;
  set companyName(String companyName) {
    _companyname = companyName;
    notifyListeners();
  }

  String get aBN => _abn;
  set aBN(String aBN) {
    _abn = aBN;
    notifyListeners();
  }

  String get aCN => _acn;
  set aCN(String aCN) {
    _acn = aCN;
    notifyListeners();
  }

  String get bussinessAdd => _bussinessadd;
  set bussinessAdd(String bussinessAdd) {
    _bussinessadd = bussinessAdd;
    notifyListeners();
  }

  String get postCode => _postcode;
  set postCode(String postCode) {
    _postcode = postCode;
    notifyListeners();
  }

  set dropdown(var value) {
    this.value = value;
    notifyListeners();
  }

  // on login buttion clik
  onRegisterButtonClick() {
    isButtonClick = false;

    if (formKey.currentState!.validate() && allcheck) {
      formKey.currentState!.save();
      callRegisterApi();
    } else {}
    notifyListeners();
  }

  onRequestForLoginClick() {
    navigationService.navigateTo(Routes.submitRegisterView);
  }

  callRegisterApi() async {
    setBusy(true);
    var map = Map<String, dynamic>();
    map['first_name'] = firstNameController.text.toString();
    map['last_name'] = lastNameController.text.toString();
    map['mobile'] = mobileNumberController.text.toString();
    map['email'] = emailController.text.toString();
    map['company'] = companyNameController.text.toString();
    map['accounts_first_name'] = accountNameController.text.toString();
    map['accounts_last_name'] = accountLastNameController.text.toString();
    map['accounts_email'] = accountEmailController.text.toString();
    map['accounts_phone'] = phoneNumberController.text.toString();
    map['abn'] = abnController.text.toString();
    map['acn'] = acnController.text.toString();
    map['address_street_1'] = businessAddController.text.toString();
    map['address_street_2'] = '';

    map['address_city'] =
        cityAddController.text.toString(); //fields missing on registerPage
    map['address_state'] = dropDownAct.toString();
    map['address_postcode'] = postCodeController.text.toString();
    map['is_qualified'] = "true";
    map['subscribe_powarewards'] = "false";
    map['agree_terms'] = allcheck.toString();
    map['primary_work_type'] = worksType.toString();
    map['terms_preferred'] = dropDownAccount.toString();
    map['trade_type'] = dropDownTrade.toString();
    map['estimated_monthly_spend'] = monthlySpendController.text.toString();
    map['hear_about_us'] = dropDownHereAbout.toString();
    RegisterResponse registerResponse = await api.registerUser(map);

    switch (registerResponse.statusCode) {
      case Constants.sucessCode:
        AppUtil.showDialogboxforSuccess(
            AppUtil.getContext(),
            'Thank You!',
            'Your request has been sent successfully. Please check your email to continue.',
            0);

        break;
      case Constants.wrongError:
        AppUtil.showDialogbox(AppUtil.getContext(),
            registerResponse.error ?? 'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        AppUtil.showDialogbox(AppUtil.getContext(),
            registerResponse.error ?? 'Oops Something went wrong');

        break;
      default:
        {
          if (registerResponse.error != null &&
              registerResponse.error!.isNotEmpty) {
            AppUtil.showDialogbox(AppUtil.getContext(),
                registerResponse.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    setBusy(false);
  }
}

class CheckboxList {
  String? title;
  bool? isSelect = false;

  CheckboxList({this.title, this.isSelect});
}
