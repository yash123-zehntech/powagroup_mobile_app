import 'package:shared_preferences/shared_preferences.dart';

class SharedPre {
  static const String LOGIN_TOKEN = "accessToken";
  static const String LOGIN_EXPIRY_DATE = "TokenExpiryDate";
  static const String USERNAME = "userName";
  static const String refreshToke = "refresh_toke";
  static const String deviceToke = "device_toke";
  static const String endPointArn = "end_point_arn";
  static const String isLogin = "isLogin";
  static const String NAME = "name";
  static const String EMAIL = "email";
  static const String Mobile = "mobile";
  static const String countryCode = "countryCode";
  static const String profileImage = "profileImage";
  static const String userId = "userId";
  static const String unreadcount = "unreadcount";
  static const String storeId = "storeId";
  static const String unreadmsg = "unreadmsg";
  static const String setTime = "setTime";
  static const String SITECONTACT = "siteContact";
  static const String ISPICKUP = "isPickup";

  static setStringValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static setDateTimeValue(String key, DateTime value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value.toIso8601String());
  }

  static setBoolValue(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static setIntValue(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static getStringValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? prefs.getString(key) : "";
  }

  static getBoolValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? prefs.getBool(key) : false;
  }

  static getIntValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? prefs.getInt(key) : -1;
  }

  static clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  static Future<DateTime?> getDateTimeValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(key);

    if (stringValue != null) {
      return DateTime.parse(stringValue);
    }

    return null; // Or you can return a default value if the key is not found
  }
}
