import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/helper_widget/debouncer.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/address_module/response_model/address_response.dart';
import 'package:powagroup/ui/screen/modules/address_module/response_model/create_address_response.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'response_model/cities_respose.dart';

class AddressViewMode extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  TextEditingController addressNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController streetNameNumberController = TextEditingController();
  TextEditingController streetNameController = TextEditingController();
  TextEditingController stateNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController contectNumberController = TextEditingController();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final _debouncer = Debouncer(milliseconds: 1000);
  String _contectNumber = '';
  String _streetNameNumber = '';
  String _streetName = '';
  String _username = '';
  String _password = '';
  String _email = '';
  String _accountname = '';
  String _mobilenumber = '';
  String _companyname = '';
  String _abn = '';
  String _city = '';
  String _code = '';
  String _country = '';
  String value = '';
  bool value1 = false;
  late String _dropDownTrade = '  State/Provice..';
  late String _dropDownState = '  State/Provice..';
  String _dropDownAct = '   ACT';
  String _dropDownAccount = '  Select';
  String dropDownValue = '';
  bool star = false;
  // List<String?> _stateList = List.empty(growable: true);
  List<String?> _cityList = List.empty(growable: true);
  List<String?> _listOfCity = List.empty(growable: true);
  List<String?> _listOfState = List.empty(growable: true);

  String? countryValue = "";
  String _stateValue = "";
  String _cityValue = "";
  String _addressTypeValue = "";
  CitiesListResponse? citiesResponse;

  List<String> trade = [
    'Plumbing',
    'HVAC',
    'Fire Services',
    'Electrical',
    'Building or other Trades',
  ];

  List<String> act = ['NSW', 'NT', 'QLD', 'SA', 'VIC', 'WA'];

  List<String> accountType = [
    'C.O.D TRADE ACCOUNT',
    '3o DAY EOM TRADE ACCOUNT'
  ];

  // List<String> addressType = ['Billing Address', 'Shipping Address'];
  List<String> addressType = ['Contact', 'Invoice', 'Delivery'];

  Api api = locator<Api>();

  HiveDbServices<AddressData> _localDb = HiveDbServices(Constants.address);
  List<AddressData> _addressList = List.empty(growable: true);

  String get userName => _username;
  set userName(String userName) {
    _username = userName;
    notifyListeners();
  }

  bool _isChangedEditField = false;
  bool get isChangedEditField => _isChangedEditField;
  set isChangedEditField(bool isChangedEditField) {
    _isChangedEditField = isChangedEditField;
    notifyListeners();
  }

  String get addressTypeValue => _addressTypeValue;
  set addressTypeValue(String addressTypeValue) {
    _addressTypeValue = addressTypeValue;
    notifyListeners();
  }

  String get stateValue => _stateValue;
  set stateValue(String stateValue) {
    _stateValue = stateValue;
    notifyListeners();
  }

  String get cityValue => _cityValue;
  set cityValue(String cityValue) {
    _cityValue = cityValue;
    notifyListeners();
  }

  // String _cityName = "";
  // String get cityName => _cityName;
  // set cityName(String cityName) {
  //   _cityName = cityName;
  //   notifyListeners();
  // }

  // List<String?> get stateList => _stateList;
  // set stateList(List<String?> stateList) {
  //   _stateList = stateList;
  //   notifyListeners();
  // }

  List<String?> get listOfState => _listOfState;
  set listOfState(List<String?> listOfState) {
    _listOfState = listOfState;
    notifyListeners();
  }

  // List<String?> get cityList => _cityList;
  // set cityList(List<String?> cityList) {
  //   _cityList = cityList;
  //   notifyListeners();
  // }

  List<String?> get listOfCity => _listOfCity;
  set listOfCity(List<String?> listOfCity) {
    _listOfCity = listOfCity;
    notifyListeners();
  }

  String get dropDownState => _dropDownState;
  set dropDownState(dropDownstate) {
    _dropDownState = dropDownState;
    notifyListeners();
  }

  String get contectNumber => _contectNumber;
  set contectNumber(String contectNumber) {
    _contectNumber = contectNumber;
    notifyListeners();
  }

  String get streetNameNumber => _streetNameNumber;
  set streetNameNumber(String streetNameNumber) {
    _streetNameNumber = streetNameNumber;
    notifyListeners();
  }

  String get streetName => _streetName;
  set streetName(String streetName) {
    _streetName = streetName;
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

  String get city => _city;
  set city(String city) {
    _city = city;
    notifyListeners();
  }

  String get code => _code;
  set code(String code) {
    _code = code;
    notifyListeners();
  }

  String get country => _country;
  set country(String country) {
    _country = country;
    notifyListeners();
  }

  set dropdown(var value) {
    this.value = value;
    notifyListeners();
  }

  bool _noDataFound = false;

  bool get noDataFound => _noDataFound;

  set noDataFound(bool noDataFound) {
    _noDataFound = noDataFound;
    notifyListeners();
  }

  // get State Name
  String getStateName(String stateFullName) {
    if (stateFullName == "Australian Capital Territory") {
      return 'ACT';
    } else if (stateFullName == "New South Wales") {
      return 'NSW';
    } else if (stateFullName == "Northern Territory") {
      return 'NT';
    } else if (stateFullName == "Queensland") {
      return 'QLD';
    } else if (stateFullName == "South Australia") {
      return 'SA';
    } else if (stateFullName == "Tasmania") {
      return 'TAS';
    } else if (stateFullName == "Victoria") {
      return 'VIC';
    } else if (stateFullName == "Western Australia") {
      return 'WA';
    }
    return '';
  }

  // get State Name
  String getStateValue(String stateName) {
    if (stateName == "ACT") {
      return 'Australian Capital Territory';
    } else if (stateName == "NSW") {
      return 'New South Wales';
    } else if (stateName == "NT") {
      return 'Northern Territory';
    } else if (stateName == "QLD") {
      return 'Queensland';
    } else if (stateName == "SA") {
      return 'South Australia';
    } else if (stateName == "TAS") {
      return 'Tasmania';
    } else if (stateName == "VIC") {
      return 'Victoria';
    } else if (stateName == "WA") {
      return 'Western Australia';
    }
    return '';
  }

  onSubmitButtonClick(
      bool isEdit, AddressData? addressData, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      AddressData data = AddressData(isSelect: false);

      // data.addressName = addressNameController.text.toString();
      // data.emailAddress = emailController.text.toString();
      // data.mobileNumber = mobileNumberController.text.toString();
      // data.addressType = addressTypeValue.toLowerCase().toString();
      // data.streetNameNumber = streetNameNumberController.text.toString();
      // data.streetNameOther = streetNameController.text.toString();
      // data.city = cityValue.toString();
      // data.state = stateValue.length > 3
      //     ? getStateName(stateValue)
      //     : getStateValue(stateValue);
      // data.country =
      //     // countryController.text.toString()
      //     "AU";

      data.addressName = addressNameController.text.toString();
      data.emailAddress = emailController.text.toString();
      data.mobileNumber = mobileNumberController.text.toString();
      data.addressType = "delivery";
      // addressTypeValue.toLowerCase().toString();
      data.streetNameNumber = streetNameNumberController.text.toString();
      data.streetNameOther = streetNameController.text.toString();
      data.city = cityValue.toString();
      data.state = stateNameController.text.toString();
      //  "Victoria";
      // data.state = stateValue.length > 3
      //     ? getStateName(stateValue)
      //     : getStateValue(stateValue);
      data.country = "Australia";

      setBusy(true);

      CreateAddressResponse createAddressResponse = await api.createAddress(
          data.toJson(), addressData != null ? addressData.id! : '');

      switch (createAddressResponse.statusCode) {
        case Constants.sucessCode:
          var jsonObject = json.decode(createAddressResponse.result!);

          if (jsonObject['id'] != null
              //&&
              // jsonObject['status'] != null &&
              // jsonObject['status'] != "error"
              ) {
            AppUtil.showSnackBar(addressData != null
                ? "Address updated successfully"
                : "Address created successfully");
            Navigator.of(context).pop(true);
          } else {
            AppUtil.showDialogbox(AppUtil.getContext(),
                jsonObject['error']['message'] ?? 'Oops Something went wrong');
          }

          // AppUtil.showDialogboxforSuccess(
          //     AppUtil.getContext(),
          //     'Thank You!',
          //     'Your request has been sent successfully. Please check your email to continue.',
          //     0);

          break;
        case Constants.wrongError:
          AppUtil.showDialogbox(AppUtil.getContext(),
              createAddressResponse.error ?? 'Oops Something went wrong');
          // AppUtil.showToast(loginResp.error ?? '');

          break;
        case Constants.networkErroCode:
          AppUtil.showDialogbox(AppUtil.getContext(),
              createAddressResponse.error ?? 'Oops Something went wrong');
          // AppUtil.showToast(loginResp.error ?? '');
          break;
        default:
          {
            if (createAddressResponse.error != null &&
                createAddressResponse.error!.isNotEmpty) {
              //AppUtil.showToast(loginResp.error ?? '');
            }
          }
          break;
      }
      setBusy(false);

      // if (_addressList == null && _addressList.isEmpty) {
      //   _localDb.clear();
      // }
      // _addressList.clear();

      // _addressList = await _localDb.getData();

      // if (_addressList != null && _addressList.isNotEmpty) {
      //   if (addressData != null) {
      //     for (int i = 0; i < _addressList.length; i++) {
      //       if (_addressList[i].id == addressData.id) {
      //         _addressList[i].addressName = addressNameController.text;
      //         _addressList[i].emailAddress = emailController.text;
      //         _addressList[i].mobileNumber = mobileNumberController.text;
      //         _addressList[i].streetNameNumber =
      //             streetNameNumberController.text;
      //         _addressList[i].streetNameOther = streetNameController.text;
      //         _addressList[i].code = codeController.text;
      //         _addressList[i].state = stateValue;
      //         _addressList[i].city = cityValue;
      //         _addressList[i].siteContactPhoneNumber =
      //             contectNumberController.text;
      //         _addressList[i].addressType = addressTypeValue;
      //       }
      //     }
      //     _localDb.clear();
      //     _localDb.putListData(_addressList);
      //   } else {
      //     _addressList.clear();
      //     _addressList.add(getAddressObject());
      //   }
      // } else {
      //   _addressList.clear();
      //   _addressList.add(getAddressObject());
      // }
      // if (addressData == null) {
      //   _localDb.putListData(_addressList);
      // }

      // if (_addressList.isNotEmpty) {
      //   AppUtil.showSnackBar("Added to Address successfully");

      //   PersistentNavBarNavigator.pushNewScreen(context,
      //       screen: HomePageView(
      //         number: 3,
      //         numberforCart: 1,
      //       ));
      // }
    } else {}
  }

  // get City
  // getCity() async {
  //   // List<String?> cityListData =
  //   //     await AppUtil.getCities(getStateValue(stateValue));
  //   cityList.add(cityController.text.toString());
  //   stateList.add(stateNameController.text.toString());
  //   // cityList = cityListData;

  //   notifyListeners();
  // }

  // get Address object to store data in local db
  AddressData getAddressObject() {
    return AddressData(
        id: AppUtil.getCurrentDate(),
        addressName: addressNameController.text,
        emailAddress: emailController.text,
        mobileNumber: mobileNumberController.text,
        streetNameNumber: streetNameNumberController.text,
        streetNameOther: streetNameController.text,
        code: codeController.text,
        country: countryController.text,
        state: stateValue,
        city: cityValue,
        siteContactPhoneNumber: contectNumberController.text,
        addressType: addressTypeValue,
        completeAddress:
            '${streetNameNumberController.text} ${cityValue} ${codeController.text} $stateValue ${countryController.text}',
        isSelect: false);
  }

  // Set Local Database value in controllers and fields
  setControllerValue(AddressData data) {
    addressNameController.text = data.addressName!;
    emailController.text = data.emailAddress!;
    mobileNumberController.text = data.mobileNumber!;
    streetNameNumberController.text = data.streetNameNumber!;
    streetNameController.text = data.streetNameOther!;
    //codeController.text = data.code!;stateNameController
    // stateValue = data.state!;
    // cityValue = data.city!;
    // streetNameNumberController.text = data.state!;
    cityController.text = data.city!;
    stateNameController.text = data.state!;
    // cityController.text = data.code!;
    //contectNumberController.text = data.siteContactPhoneNumber!;
    addressTypeValue = capitalize(data.addressType!);

    // getCity();
  }

  capitalize(String s) {
    return s[0].toUpperCase() + s.substring(1);
  }

  clearList() {
    if (citiesResponse != null) {
      citiesResponse = null;
      notifyListeners();
    }
  }

  List<CitiesData> _citiesList = List.empty(growable: true);

  List<CitiesData> get citiesList => _citiesList;
  set citiesList(List<CitiesData> citiesList) {
    _citiesList = citiesList;
    notifyListeners();
  }

  bool setsearchTap = false;
  bool get searchTap => setsearchTap;
  set searchTap(bool searchTap) {
    setsearchTap = searchTap;
    notifyListeners();
  }

  bool _isTapping = false;

  bool get isTapping => _isTapping;
  set isTapping(bool isTapping) {
    _isTapping = isTapping;
    notifyListeners();
  }

  bool _isContinerTapping = false;

  bool get isContinerTapping => _isContinerTapping;
  set isContinerTapping(bool isContinerTapping) {
    _isContinerTapping = isContinerTapping;
    notifyListeners();
  }

  onCitiesItemChanged() {
    if (streetNameNumberController.text.isNotEmpty) {
      if (streetNameNumberController.text.length <= 2) {
        AppUtil.showSnackBar("Minimum 2 charactors required");
        // clearList();
      } else {
        setsearchTap = true;
        notifyListeners();
        _debouncer.run(() {
          if (streetNameNumberController.text.trim().isNotEmpty) {
            callCitiesAPI(streetNameNumberController.text);
          }
        });
      }
    } else {
      // getSearchLocaldata();
    }
  }

  noDataFoundFunction() {
    AppUtil.showSnackBar("No data found");
  }

  bool _checkforCities = false;
  bool get checkforCities => _checkforCities;
  set checkforCities(bool checkforCities) {
    _checkforCities = checkforCities;
    notifyListeners();
  }

  // Call Global Search API for Product
  callCitiesAPI(String search) async {
    checkforCities = true;
    isContinerTapping = false;

    final queryParams = {
      'search': search,
      'country_name': 'Australia',
    };

    citiesResponse = await api.getCities(queryParams);
    if (citiesResponse != null) {
      if (citiesResponse!.cities!.isNotEmpty) {
        noDataFound = false;
      } else {
        noDataFound = true;
        noDataFoundFunction();

        // searchFieldFocus.unfocus();
      }
      notifyListeners();
    }
    switch (citiesResponse!.statusCode) {
      case Constants.sucessCode:
        if (citiesResponse != null &&
            citiesResponse!.cities != null &&
            citiesResponse!.cities!.isNotEmpty) {
          citiesList.clear();
          citiesList.addAll(citiesResponse!.cities!);
        }
        break;
      case Constants.wrongError:
        // isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            citiesResponse!.error ?? 'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        // isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            citiesResponse!.error ?? 'Oops Something went wrong');
        break;
      default:
        {
          if (citiesResponse!.error != null &&
              citiesResponse!.error!.isNotEmpty) {
            // isAPIError = true;
            AppUtil.showDialogbox(AppUtil.getContext(),
                citiesResponse!.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    checkforCities = false;
  }
}
