import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powagroup/util/constant.dart';

class Validation {
  // Validation for check valid email
  static bool emailValidation(String value) {
    final validEmail =
        RegExp(r'\S+@\S+\.\S+'); //RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$");
    return validEmail.hasMatch(value);
  }

  static String validString(String value) {
    return value != null &&
            value.isNotEmpty &&
            !value.toLowerCase().contains('null')
        ? value
        : 'N/A';
  }

  static Map getHeaderWithContent(String lang, String token) {
    Map<String, String> header = Map();
    header["X-Localization"] = lang;
    header["Accept"] = "application/json";
    header["Content-Type"] = "application/json";
    header["Authorization"] = "Bearer $token";
    return header;
  }

  // check netrowk is connected or not
  static Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  static String? fieldEmpty(String value) {
    // Text('Field can not be emptyoooo');
    String message = Constants.fieldCanNotBeEmpty;
    //  String message =  Text('Field can not be emptyoooo',
    //       style:
    //           const TextStyle(fontSize: 50, backgroundColor: Color(0xff858D93)));
    if (value.isNotEmpty) {
      return null;
    } else {
      return message;
    }
  }

  static String? fieldCheckboxEmpty(String value) {
    // Text('Field can not be emptyoooo');
    String message = Constants.fieldCanNotBeEmpty;
    //  String message =  Text('Field can not be emptyoooo',
    //       style:
    //           const TextStyle(fontSize: 50, backgroundColor: Color(0xff858D93)));
    if (value.isNotEmpty) {
      return null;
    } else {
      return message;
    }
  }

  static String? emailValidate(String value) {
    if (value.isNotEmpty) {
      if (Validation.emailValidation(value.trim())) {
        return null;
      } else {
        return Constants.invalidEmail;
      }
    } else {
      return Constants.enterEmail;
    }
  }

  static String loginPassValid(String value) {
    if (value.isNotEmpty) {
      return '';
    } else {
      return Constants.enterYourPassword;
    }
  }

  static String passwordValidate(String value) {
    if (value.isNotEmpty) {
      if (value.length < 6) {
        return Constants.passwordValidation;
      } else {
        return '';
      }
    } else {
      return Constants.enterYourPassword;
    }
  }

  static String passwordMatch(String value, String match) {
    if (value.isNotEmpty) {
      if (value == match) {
        return '';
      } else {
        return Constants.passwordNotMatch;
      }
    } else {
      return Constants.fieldCanNotBeEmpty;
    }
  }

// set default string
  static String setDefaultString(String value) {
    return value != null && value.isNotEmpty && value.toLowerCase() != 'null'
        ? value
        : "";
  }

  // validatation for mobile number chek
  // static bool validMobile(String value) {
  //   final mobileRegExp = RegExp(r'^[6-9][0-9]{9}$');
  //   if (value.isNotEmpty && mobileRegExp.hasMatch(value)) {
  //     return true;
  //   } else if (value.isEmpty || value == null) {
  //     //AppUtil.showToast(Constants.enterMobileNumber);
  //     return false;
  //   } else if (!mobileRegExp.hasMatch(value)) {
  //     //AppUtil.showToast(Constants.validMobile);
  //     return false;
  //   } else {
  //     //AppUtil.showToast(Constants.enterYourPassword);
  //     return false;
  //   }
  // }

  static String? validMobile(String value) {
    final mobileRegExp = RegExp(r'^[6-9][0-9]{9}$');
    // final mobileRegExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    if (value.isNotEmpty && mobileRegExp.hasMatch(value)) {
      return null;
    } else if (value.isEmpty || value == null) {
      //AppUtil.showToast(Constants.enterMobileNumber);
      return Constants.fieldCanNotBeEmpty;
    } else if (value.length < 10) {
      return Constants.lengthOfMoblie;
    }
    // else if (!mobileRegExp.hasMatch(value)) {
    //   //AppUtil.showToast(Constants.validMobile);
    //   return Constants.invalidMobile;
    // }
    else {
      //AppUtil.showToast(Constants.enterYourPassword);
      return null;
    }
  }

  // Validation fot otp check
  static bool otpValidation(String value) {
    if (value.isEmpty) {
      //AppUtil.showToast(Constants.enterOtp);
      return false;
    } else if (value.length != 6) {
      //AppUtil.showToast(Constants.invalidOtp);
      return false;
    } else {
      return true;
    }
  }

  // Validation fot otp check
  static bool videoTitleValidation(String value) {
    if (value.isEmpty) {
      //AppUtil.showToast(Constants.enterTitle);
      return false;
    } else {
      return true;
    }
  }

// Validation fot otp check
  static bool coffeTypeValidation(String value) {
    if (value.isEmpty) {
      //AppUtil.showToast(Constants.selectCoffeeType);
      return false;
    } else {
      return true;
    }
  }

  static String? notValidate(String value) {
    // if (value.isNotEmpty) {
    //   if (Validation.emailValidation(value.trim())) {
    //     return null;
    //   } else {
    //     return Constants.invalidEmail;
    //   }
    // } else {
    //   return Constants.enterEmail;
    // }
    return null;
  }
}
