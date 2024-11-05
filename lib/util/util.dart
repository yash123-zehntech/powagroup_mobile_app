// ignore_for_file: empty_catches, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:csc_picker/model/select_status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powagroup/helper_widget/error_box_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:powagroup/helper_widget/login_message_dialog.dart';
import 'package:powagroup/helper_widget/success_box_widget.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/address_module/response_model/address_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/contact_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_methods_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/invoice_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/extra_info_module/response_model/extra_info_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/extra_info_module/response_model/sitecontact_info_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/hive_model.dart/cart_selected_qty.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/model/cartItemList.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/response_model/joblist_hive_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/user_module/profile/response_model.dart/user_profile_model.dart';
import 'package:powagroup/util/app_data.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/shared_preference.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_subcategory_response.dart';

class AppUtil {
  int totalItem = 0;
  static HiveDbServices<ProductData> _cartLocalDB =
      HiveDbServices(Constants.cart_product);

  static HiveDbServices<UserObject> _localDbForUserData =
      HiveDbServices(Constants.user_data);

  static HiveDbServices<CartItemList> _localDbForCartItemList =
      HiveDbServices(Constants.cart_item);

  static HiveDbServices<ProductData> _localDbForFavouritesData =
      HiveDbServices(Constants.all_fav_product);

  static HiveDbServices<JobListData> _localDbForJoblist =
      HiveDbServices(Constants.createjobs);
  // static HiveDbServices<CartSelectedValue> _selectedCartQTYLocalDB =
  //     HiveDbServices(Constants.selected_cart_details);
  static List<ProductData> cartProductList = List.empty(growable: true);
  static List<ProductData> favProductList = List.empty(growable: true);
  static List<JobListData> jobList = List.empty(growable: true);

  static List<CartItemList> cartItemList = [];
  // static CartItemList cartItemList;

  // static List<CartSelectedValue> cartSelectedQTYList =
  //     List.empty(growable: true);
  static double totalPriceOfItem = 0;
  static double deliveryCharge = 0;
  static double untaxtedAmount = 0;
  static double totalTaxAmount = 0;
  static final HiveDbServices<AddressData> localDbforAddress =
      HiveDbServices(Constants.address);
  static final HiveDbServices<ExtraInfoData> localDbforExtraInfo =
      HiveDbServices(Constants.extra_info);
  static List<AddressData> addressList = List.empty(growable: true);
  static final HiveDbServices<DeliveryInfo> localDbforDeilvery =
      HiveDbServices(Constants.delivery_address);
  static List<DeliveryInfo> deliveryList = List.empty(growable: true);
  static final HiveDbServices<InvoiceInfo> localDbforInvoice =
      HiveDbServices(Constants.invoice_address);
  static List<InvoiceInfo> invoiceList = List.empty(growable: true);
  static final HiveDbServices<ContactInfo> localDbforContact =
      HiveDbServices(Constants.contact_address);
  static List<ContactInfo> contactList = List.empty(growable: true);

  static String formatDate(String date, String format, String expectFormat) {
    if (date.isEmpty || date.toLowerCase().contains('null')) return 'N/A';
    DateTime parse = DateFormat(format).parse(date);
    return DateFormat(expectFormat).format(parse);
  }

  static Size displaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double displayHeight(BuildContext context) {
    return displaySize(context).height;
  }

  static double displayWidth(BuildContext context) {
    return displaySize(context).width;
  }

  // static void hideKeyboard() {
  //   if (keyboardIsVisible(StackedService.navigatorKey.currentContext)) {
  //     FocusScope.of(StackedService.navigatorKey.currentContext).unfocus();
  //   }
  // }

  static bool keyboardIsVisible(BuildContext context) {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  static Map getHeaderToken(String token) {
    Map<String, String> header = Map();
    //header["X-Localization"] = lang;
    //header["Accept"] = "application/json";
    header["Authorization"] = "Bearer $token";
    return header;
  }

  static Map getHeader(String lang) {
    Map<String, String> header = Map();
    header["X-Localization"] = lang;
    header["Accept"] = "application/json";
    return header;
  }

  static Map<String, String> getJsonHeader() {
    Map<String, String> header = {};
    header[HttpHeaders.contentTypeHeader] = "application/json";
    return header;
  }

  static Map<String, String> getHeaderToken1(String token) {
    Map<String, String> header = {};
    header[HttpHeaders.contentTypeHeader] = "application/json";
    header["Authorization"] = "Bearer $token";
    return header;
  }

  static Map<String, String> getHeaderWithToken(String token) {
    Map<String, String> header = {};
    header[HttpHeaders.contentTypeHeader] = "application/json";
    header["Authorization"] = "Bearer $token";
    return header;
  }

  static Future<bool> checkNetwork() async {
    if (Platform.isAndroid) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        return true;
      } else {
        return false;
      }
    } else {
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
        return true;
      } on SocketException catch (_) {
        return false;
      }
    }
  }

  static Future<bool> onLikeButtonTapped(bool isLiked) async {
    return !isLiked;
  }

  static Future<bool> ondisLikeButtonTapped(bool isLiked) async {
    return !isLiked;
  }

  static double getDeviceWidth() {
    return MediaQuery.of(getContext()).size.width;
  }

  // get QTY value
  static TextEditingController getQTYValue(
      TextEditingController? dropDownControllerValue) {
    TextEditingController qtyValue = TextEditingController();
    if (dropDownControllerValue!.text.contains(".0")) {
      qtyValue.text = dropDownControllerValue.text.replaceAll(".0", "");
    } else {
      qtyValue.text = dropDownControllerValue.text;
    }

    return qtyValue;
  }

  // get QTY value
  static String getQTYValueForMenu(String qtyValue) {
    String qtyValueNew = '';

    try {
      if (qtyValue.contains(".0")) {
        qtyValueNew = qtyValue.replaceAll(".0", "");
      } else {
        qtyValueNew = qtyValue;
      }
    } catch (e) {}

    return qtyValueNew;
  }

  static double getDeviceHeight() {
    //return 0.0;
    return MediaQuery.of(getContext()).size.height;
  }

  static String fieldEmpty(String value) {
    if (value.isNotEmpty) {
      return '';
    } else {
      return Constants.fieldCanNotBeEmpty;
    }
  }

  static String timeFormat(int time) {
    if (time >= 0 && time <= 9) {
      return '0$time';
    } else
      return '$time';
  }

// show loader
  static void showLoader() {
    showDialog(
        context: getContext(),
        barrierDismissible: false,
        useSafeArea: true,
        builder: (context) => WillPopScope(
              onWillPop: () => Future.value(false),
              child: Container(
                height: ScreenUtil().setSp(100.sp),
                width: MediaQuery.of(context).size.width / 1.5,
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ));
  }

  // change status bar coror
  static statusBarColor({Color? colorName}) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: colorName ?? Colors.transparent,
      //color set to transperent or set your own color
      statusBarIconBrightness: Brightness.light,
      //set brightness for icons, like dark background light icons
    ));
  }

  static BuildContext getContext() {
    return StackedService.navigatorKey!.currentContext!;
  }

  static showSnackBar(String content) {
    Fluttertoast.showToast(
        msg: content,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
    // ScaffoldMessenger.of(getContext()).hideCurrentSnackBar();
    // ScaffoldMessenger.of(getContext()).showSnackBar(SnackBar(
    //   content: Text(content),
    //   behavior: SnackBarBehavior.fixed,
    //   margin: EdgeInsets.only(
    //       bottom: content == "Added to job list successfully" ? 0 : 100,
    //       left: 16,
    //       right: 16),
    // ));
  }

  static Widget showProgress(Color color) {
    return LoadingAnimationWidget.fourRotatingDots(
      color: color,
      size: 30.h,
    );
  }

  static Widget showCircularProgress(Color color) {
    return CircularProgressIndicator(
      color: color,
    );
  }

  static String getUtcTime() {
    String date = DateTime.now().toIso8601String();
    List<String> res = date.split(".");
    var re =
        "${res[0]}-${DateTime.now().second}:${(double.parse(DateTime.now().millisecond.toString()) / 10).toStringAsFixed(0)}";

    return re;
  }

  static CircularProgressIndicator showProgresswithCustomColor(
      {Color? colorName, double? strokewidth}) {
    return CircularProgressIndicator(
      color: colorName,
      strokeWidth: strokewidth!,
    );
  }

  static String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  static String getCurrentDate() {
    // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    // String todayDate = dateFormat.format(DateTime.now());
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static String utcToLocalTime(String utcTime) {
    if (utcTime.contains("GMT")) {
      utcTime = utcTime.split('GMT')[0];
    }
    try {
      final formatter = DateFormat(
        'EEE, d MMM yyyy HH:mm:ss',
      );
      DateTime date1 = formatter.parse(utcTime, true);
      DateTime date2 = date1.toLocal();
      final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
      String outputDate = displayFormater.format(date2);
      String relutDate = formatter.format(DateTime.parse(outputDate));
      return relutDate;
    } catch (e) {
      return utcTime;
    }
  }

  static DateTime? convertTimestampToDate(dynamic timestamp) {
    try {
      DateTime date =
          DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
      return date;
    } catch (e) {
      return null;
    }
  }

  static String utcToLocalChatTime(String utcTime) {
    if (utcTime.contains("GMT")) {
      utcTime = utcTime.split('GMT')[0];
    }
    try {
      final formatter = DateFormat(
        'EEE, d MMM yyyy HH:mm:ss',
      );
      DateTime date1 = formatter.parse(utcTime, true);
      DateTime date2 = date1.toLocal();
      final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
      String outputDate = displayFormater.format(date2);
      String relutDate = formatter.format(DateTime.parse(outputDate));
      final DateFormat resultFormate = DateFormat('HH:mm');
      String result = resultFormate.format(formatter.parse(relutDate));
      return result;
    } catch (e) {
      return utcTime;
    }
  }

  static String utcGmtTime() {
    var f = DateFormat('E, d MMM yyyy HH:mm:ss');
    String date = "${f.format(DateTime.now().toUtc())} GMT";
    return date;
  }

  static String utcToLocalTime1(String utcTime) {
    if (utcTime.contains("GMT")) {
      utcTime = utcTime.split('GMT')[0];
    }

    try {
      final formatter = DateFormat(
        'EEE, d MMM yyyy HH:mm:ss',
      );
      DateTime date1 = formatter.parse(utcTime, true);
      DateTime date2 = date1.toLocal();
      final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
      String outputDate = displayFormater.format(date2);
      String relutDate = formatter.format(DateTime.parse(outputDate));
      return relutDate;
    } catch (e) {
      return utcTime;
    }
  }

  static showDialogbox(
    BuildContext context,
    title,
  ) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ErrorBoxWidget(
            title: title.toString() ?? "Oops Something Went Wrong",
          );
        });
  }

  static showLoginMessageDialog(
    BuildContext context,
    title,
  ) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return LoginMessageDialog(
            title: title ?? "Oops Something Went Wrong",
          );
        });
  }

  static getDate(datetime) {
    DateTime date = DateTime.parse(datetime);
    String getdate = DateFormat("MMMM dd, yyyy").format(date);
    return getdate;
  }

  static getDate1(datetime) {
    DateTime date = DateTime.parse(datetime);
    DateFormat getdate = DateFormat.yMMMMd();
    DateFormat getTime = DateFormat.jm();
    return '${getdate.format(date)} at ${getTime.format(date)}';
  }

  static getDate2(datetime) {
    DateTime date = DateTime.parse(datetime);
    DateFormat getdateForMonth = DateFormat.MMMM();
    DateFormat getdateForDay = DateFormat.d();
    DateFormat getdateForYear = DateFormat.y();
    DateFormat getTime = DateFormat.jm();
    return 'Published on  ${getdateForMonth.format(date)} ${getdateForDay.format(date)}th  ${getdateForYear.format(date)}, ${getTime.format(date)}';
  }

  static getFormattedDate(datetime, isValidUntil) {
    DateTime date = DateTime.parse(datetime);
    String getdate = isValidUntil
        ? DateFormat("dd/MM/yyyy").format(date)
        : DateFormat("dd/MM/yyyy HH:mm").format(date);
    return getdate;
  }

  static clearCartData() async {
    cartProductList = await _cartLocalDB.getData();
    cartProductList.clear();
    _cartLocalDB.clear();
  }

  static clearFavouritesData() async {
    // cartProductList = await _cartLocalDB.getData();
    favProductList = await _localDbForFavouritesData.getData();
    favProductList.clear();
    _localDbForFavouritesData.clear();
  }

  static clearJoblistData() async {
    // cartProductList = await _cartLocalDB.getData();
    jobList = await _localDbForJoblist.getData();
    jobList.clear();
    _localDbForJoblist.clear();
  }

  // Get Login token
  static Future<String> getLoginToken() async {
    String loginToken = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);

    return loginToken;
  }

  static getUserId() async {
    UserObject? _userData = await _localDbForUserData.get();
    int? userId;
    if (_userData != null) {
      userId = _userData.userId!;
    }
    // Future.delayed(Duration(seconds: 3));
    return userId;
  }

  static onAddToTruckClick(
    ProductData data,
    bool isDelete,
    viewModel,
  ) async {
    cartProductList = await _cartLocalDB.getData();
    await _cartLocalDB.clear();

    bool result = cartProductList.any((element) => element.id == data.id);

    if (!result && !isDelete) {
      cartProductList.add(data);

      _cartLocalDB.putListData(cartProductList);

      AppUtil.showSnackBar('Added to cart successfully');
    } else if (isDelete) {
      cartProductList.removeWhere(
          (element) => element.id.toString() == data.id.toString());
      _cartLocalDB.putListData(cartProductList);
      AppUtil.showSnackBar('Product removed from cart successfully');
    } else {
      if (result) {
        cartProductList.removeWhere(
            (element) => element.id.toString() == data.id.toString());

        cartProductList.add(data);
      }
      _cartLocalDB.putListData(cartProductList);
      AppUtil.showSnackBar(' Product is already added in the cart');
    }

    viewModel.getBedgeCount();

    Provider.of<AppData>(getContext(), listen: false)
        .setBedgeCount(cartProductList.length);
  }

  static Future<List<CartItemList>> getCartItemList() async {
    cartItemList = await _localDbForCartItemList.getData();
    return cartItemList;
  }

  static Future<List<ProductData>> getCartList() async {
    cartProductList = await _cartLocalDB.getData();

    //cartSelectedQTYList = await _selectedCartQTYLocalDB.getData();
    if (cartProductList.isNotEmpty) {
      cartProductList.forEach((element) {
        // if (userId == element.userId) {
        if (element.controllerForCart == null) {
          element.controllerForCart = TextEditingController();
          if (element.yashValue != null && element.yashValue!.isNotEmpty) {
            element.controllerForCart!.text =
                element.yashValue!.replaceAll(".0", "");
          } else {
            if (element.qtyBreaks != null && element.qtyBreaks!.isNotEmpty) {
              element.controllerForCart!.text =
                  element.qtyBreaks![0].qty!.replaceAll(".0", "").toString();
            }
            if (element.deliveryEx != null && element.deliveryEx!.isNotEmpty) {
              element.deliveryEx = element.deliveryEx;
              // ![0].qty!.replaceAll(".0", "").toString();
            }
          }
        } else {
          if (element.yashValue != null && element.yashValue!.isNotEmpty) {
            element.controllerForCart!.text =
                element.yashValue!.replaceAll(".0", "");
          } else {
            if (element.qtyBreaks != null && element.qtyBreaks!.isNotEmpty) {
              element.controllerForCart!.text =
                  element.qtyBreaks![0].qty!.replaceAll(".0", "").toString();
            }
            if (element.deliveryEx != null && element.deliveryEx!.isNotEmpty) {
              element.deliveryEx = element.deliveryEx;
              // ![0].qty!.replaceAll(".0", "").toString();
            }
          }
        }
      });
    }

    return cartProductList;
  }

  static Future<int> getCartProductLength() async {
    List<ProductData> cartProductList = await _cartLocalDB.getData();
    Provider.of<AppData>(getContext(), listen: false)
        .setBedgeCount(cartProductList.length);
    return cartProductList.length;
  }

  static Future<bool> getShowPricing() async {
    bool showPricing = false;
    UserObject? _userData = await _localDbForUserData.get();

    if (_userData != null && _userData.showPricing!) {
      showPricing = _userData.showPricing!;
    }

    return showPricing;
  }

  static Future<dynamic> getResponse() async {
    var res = await rootBundle
        .loadString('packages/csc_picker/lib/assets/country.json');
    return jsonDecode(res);
  }

  ///get states from json response
  static Future<List<String?>> getStates() async {
    CountryFlag? flagState;
    List<String?> _states = [];
    _states.clear();
    var response = await getResponse();
    var takeState = flagState == CountryFlag.ENABLE ||
            flagState == CountryFlag.SHOW_IN_DROP_DOWN_ONLY
        ? response
            .map((map) => Country.fromJson(map))
            .where((item) => item.emoji + "    " + item.name == "Australia")
            .map((item) => item.state)
            .toList()
        : response
            .map((map) => Country.fromJson(map))
            .where((item) => item.name == "Australia")
            .map((item) => item.state)
            .toList();

    var states = takeState as List;
    states.forEach((f) {
      // if (!mounted) return;
      // setState(() {
      var name = f.map((item) => item.name).toList();
      for (var stateName in name) {
        _states.add(stateName.toString());
      }
      // });
    });
    _states.sort((a, b) => a!.compareTo(b!));

    return _states;
  }

  ///get cities from json response
  static Future<List<String?>> getCities(String _selectedState) async {
    CountryFlag? flagState;
    List<String?> _cities = [];
    _cities.clear();
    var response = await getResponse();
    var takeCity = flagState == CountryFlag.ENABLE ||
            flagState == CountryFlag.SHOW_IN_DROP_DOWN_ONLY
        ? response
            .map((map) => Country.fromJson(map))
            .where((item) => item.emoji + "    " + item.name == "Australia")
            .map((item) => item.state)
            .toList()
        : response
            .map((map) => Country.fromJson(map))
            .where((item) => item.name == "Australia")
            .map((item) => item.state)
            .toList();
    var cities = takeCity as List;
    cities.forEach((f) {
      var name = f.where((item) => item.name == _selectedState);
      var cityName = name.map((item) => item.city).toList();
      cityName.forEach((ci) {
        var citiesName = ci.map((item) => item.name).toList();
        for (var cityName in citiesName) {
          _cities.add(cityName.toString());
        }
      });
    });
    _cities.sort((a, b) => a!.compareTo(b!));
    return _cities;
  }

  static Future<String> getLocalFile(String pathFile) async {
    final path = pathFile;
    final Directory? extDir = await getExternalStorageDirectory();

    final String dirPath = "${extDir}$pathFile";

    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/';

    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    new Directory(appDocDirectory.path + '/' + 'dir')
        .create(recursive: true)
        .then((Directory directory) {});

    return filePath;
  }

  static Future<File> takePicture(File pathFile) async {
    Directory root =
        await getApplicationDocumentsDirectory(); // this is using path_provider
    String directoryPath = root.path + "/${pathFile}";
    await Directory(directoryPath)
        .create(recursive: true); // the error because of this line
    String filePath = '$directoryPath';

    return File(filePath);
  }

  // get Item Total Price to show total price of items
  static double getItemTotalPrice() {
    totalPriceOfItem = 0;
    if (cartProductList != null && cartProductList.isNotEmpty) {
      for (int i = 0; i < cartProductList.length; i++) {
        double itemTotalPrice = 0;

        if (cartProductList[i].yashValue != null &&
            cartProductList[i].yashValue!.isNotEmpty) {
          if (cartProductList[i].yashValue!.contains(".0")) {
            itemTotalPrice = (itemTotalPrice +
                    cartProductList[i].priceUntaxed!.toDouble()) *
                int.parse(cartProductList[i].yashValue!.replaceAll(".0", ""));
          } else {
            itemTotalPrice =
                (itemTotalPrice + cartProductList[i].priceUntaxed!.toDouble()) *
                    int.parse(cartProductList[i].yashValue!);
          }
        } else {
          itemTotalPrice =
              (itemTotalPrice + cartProductList[i].priceUntaxed!.toDouble()) *
                  int.parse(cartProductList[i].yashValue!);
        }

        totalPriceOfItem = totalPriceOfItem + itemTotalPrice;
      }
    }

    return totalPriceOfItem;
  }

  // static double getItemDeliveryCharges() {
  //   deliveryCharge = 0;

  //   getItemTotalPrice();
  //   //getItemUntaxtedAmount();
  //   getTaxAmount();

  //   if (cartProductList != null && cartProductList[0].deliveryEx != null) {
  //     deliveryCharge = (cartProductList[0].deliveryEx!).toDouble();
  //   }
  //   return deliveryCharge;
  // }

  // static double getItemUntaxtedAmount(double charge) {
  //   untaxtedAmount = 0;

  //   if (cartProductList != null && cartProductList.isNotEmpty) {
  //     for (int i = 0; i < cartProductList.length; i++) {
  //       double itemTotalPrice = 0;

  //       if (cartProductList[i].yashValue != null &&
  //           cartProductList[i].yashValue!.isNotEmpty) {
  //         if (cartProductList[i].yashValue!.contains(".0")) {
  //           itemTotalPrice = (itemTotalPrice +
  //                   cartProductList[i].priceUntaxed!.toDouble()) *
  //               int.parse(cartProductList[i].yashValue!.replaceAll(".0", ""));
  //         } else {
  //           itemTotalPrice =
  //               (itemTotalPrice + cartProductList[i].priceUntaxed!.toDouble()) *
  //                   int.parse(cartProductList[i].yashValue!);
  //         }
  //       } else {
  //         itemTotalPrice =
  //             (itemTotalPrice + cartProductList[i].priceUntaxed!.toDouble()) *
  //                 int.parse(cartProductList[i].yashValue!);
  //       }

  //       untaxtedAmount = untaxtedAmount + itemTotalPrice;
  //     }
  //   }

  //   return untaxtedAmount + charge;
  // }

  // static double getTaxAmount() {
  //   totalTaxAmount = 0;
  //   double deliveryTax = 0.0;
  //   if (cartProductList != null && cartProductList.isNotEmpty) {
  //     for (int i = 0; i < cartProductList.length; i++) {
  //       double taxAmount = 0;

  //       if (cartProductList[i].yashValue != null &&
  //           cartProductList[i].yashValue!.isNotEmpty) {
  //         if (cartProductList[i].yashValue!.contains(".0")) {
  //           taxAmount = cartProductList[i].priceTax!;
  //         } else {
  //           taxAmount = cartProductList[i].priceTax!;
  //         }
  //       }

  //       print("Amount ------- ${taxAmount}");
  //       totalTaxAmount = totalTaxAmount + taxAmount;
  //     }

  //     deliveryTax = (cartProductList[0].deliveryTax).toDouble();

  //     //print("deliveryTax ------- ${deliveryTax}");
  //   }

  //   return (totalTaxAmount + deliveryTax).toDouble();
  // }

  // static double getTotalProductAmount(double deliveryCharge) {
  //   double totalProductAmount = 0;
  //   try {
  //     totalProductAmount =
  //         getItemTotalPrice() + deliveryCharge + getTaxAmount();
  //   } catch (e) {
  //     print("Exception to get total Amount -------- $e");
  //   }
  //   // try {
  //   //   totalProductAmount =
  //   //       getItemTotalPrice() + getItemDeliveryCharges() + getTaxAmount();
  //   // } catch (e) {}

  //   return totalProductAmount;
  // }

  // static Future<List<AddressData>> getAddressList() async {
  //   addressList.clear();
  //   addressList = await localDbforAddress.getData();
  //   return addressList;
  // }

  static Future<List<DeliveryInfo>> getDeliveryList() async {
    deliveryList.clear();

    deliveryList = await localDbforDeilvery.getData();
    return deliveryList;
  }

  static Future<List<InvoiceInfo>> getInvoiceList() async {
    invoiceList.clear();

    invoiceList = await localDbforInvoice.getData();
    return invoiceList;
  }

  static Future<List<ContactInfo>> getContactList() async {
    contactList.clear();

    contactList = await localDbforContact.getData();
    return contactList;
  }

  static printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static getSavedExtraInformation() async {
    bool extraInfo;
    var getData;
    try {
      getData = await localDbforExtraInfo.get();

      if (getData == null) {
        extraInfo = true;
      } else {
        extraInfo = false;
      }

      return extraInfo;
    } catch (e) {
      extraInfo = true;

      return extraInfo;
    }
  }

  static final HiveDbServices<JobListData> localDbforJob =
      HiveDbServices(Constants.createjobs);
  // static List<JobListData> jobList = List.empty(growable: true);
  static getJobProductList() async {
    jobList = await localDbforJob.getData();
    return jobList;
  }

  static showDialogboxforSuccess(
      BuildContext context, String success, String subtitle, int value) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return SuccessBoxWidget(
            success_title: success,
            subTitle: subtitle,
            value: value,
          );
        });
  }

  // launch Chat URL
  static launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch ${url}');
    }
  }

  // get Price Of Qty by multiply
  static double getQtyPriceByMultiply(
      String controllerValue, List<QtyBreak> qtyList) {
    double priceByMultiply = 0.0;
    if (controllerValue != "") {
      int value = int.parse(controllerValue);

      if (qtyList != null && qtyList.isNotEmpty) {
        qtyList.forEach((e) {
          int convertedValue = double.parse(e.qty!).toInt();
          if (convertedValue <= value) {
            priceByMultiply = e.price!;
          } else {
            return;
          }
        });
      }

      return priceByMultiply;
    }
    return priceByMultiply;
  }

  static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^http:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  static String getThumbnail({
    required String videoId,
    String quality = ThumbnailQuality.high,
    bool webp = true,
  }) =>
      webp
          ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
          : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';

  // Generate Thumbnail file
  static Future<String> getThumbnailFile(String videoUrl) async {
    String? videoId = convertUrlToId(videoUrl);
    String thumbnailUrl = getThumbnail(videoId: videoId ?? "");

    // String? fileName = await VideoThumbnail.thumbnailFile(
    //   video: videoUrl,
    //   thumbnailPath: (await getApplicationDocumentsDirectory()).path,
    //   imageFormat: ImageFormat.WEBP,
    //   maxHeight:
    //       64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    //   quality: 100,
    // );

    return thumbnailUrl;
  }
}
