import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive/hive.dart';
import 'package:powagroup/.env.example.dart';
import 'package:powagroup/services/globals.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/contact_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/invoice_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/extra_info_module/response_model/sitecontact_info_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/hive_model.dart/cart_selected_qty.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/projects.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/review_model.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/customer_reviews_by_product.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/quotation_review_model.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/response_model/customer_reviews_by_product_for_quote.dart';
import 'package:powagroup/ui/screen/modules/quotation_review/response_model/quotation_review_for_pagination.dart';
import 'package:powagroup/ui/screen/modules/reviews/response_model/Customer_review_for_pagination.dart';
import 'package:powagroup/ui/screen/modules/sales_order_detail_module/customer_review_by_product_for_sale.dart';
import 'package:powagroup/ui/screen/modules/sales_order_detail_module/response_model.dart/sales_details_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_detail_module/response_model.dart/tax_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/address_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/customer_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/delivery_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/invoice_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/site_contact_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/shipping_details_model.dart';
import 'package:powagroup/ui/screen/modules/user_module/profile/response_model.dart/user_profile_model.dart';
import 'package:provider/provider.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/ui/screen/modules/address_module/response_model/address_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/extra_info_module/response_model/extra_info_response.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/response_model/joblist_hive_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/blog_detail.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_category_module/response_model/product_categories_response.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_subcategory_response.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_by_id.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_model.dart';
import 'package:powagroup/util/app_data.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:stacked_services/stacked_services.dart';
import 'ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_methods_response.dart';
import 'ui/screen/modules/all_cart_module/model/cartItemList.dart';
import 'ui/screen/modules/home_module/home_module/model/content_slider.dart';
import 'ui/screen/modules/home_module/home_module/model/videos.dart';
import 'ui/screen/modules/quotation_detail_module/response_model/quotation_detail_responsemodel.dart';
import 'ui/screen/modules/quotation_module/response_model/quotation_response.dart';
import 'ui/screen/modules/sales_order_detail_module/response_model.dart/line_model.dart';
import 'ui/screen/modules/sales_order_detail_module/response_model.dart/order_detail_response.dart';
import 'ui/screen/modules/sales_order_detail_module/response_model.dart/unitprice_model.dart';
import 'ui/screen/modules/sales_order_module/respose_model/orderlist.model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stacked_services/stacked_services.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showFlutterNotification(message);
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          color: Colors.blue,
          playSound: true,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}

getToken() async {
//   try {
//     final fcmToken = await FirebaseMessaging.instance.getToken();
//     Future.delayed(Duration(seconds: 1));
//     Globals.getFCMToken = fcmToken!;
//   } catch (error) {
// // AppSetting.insatnce.pushToken = '';
//   }
  String tokenStr = '';
  FirebaseMessaging.instance.getToken().then((token) {
    tokenStr = token!;
  }).timeout(Duration(seconds: 5), onTimeout: () {
    tokenStr = '';
  }).catchError((error) {
    tokenStr = '';
  }).whenComplete(() {
    Globals.getFCMToken = tokenStr;
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase crash
  await Firebase.initializeApp();
  getToken();
  // final fcmToken = await FirebaseMessaging.instance.getToken();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // await Firebase.initializeApp();

    showFlutterNotification(message);
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // await Firebase.initializeApp();
    showFlutterNotification(message);
  });

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // final fcmToken = await FirebaseMessaging.instance.getToken();

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'any string works';
  await Stripe.instance.applySettings();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final appDocumentDirectory = Platform.isAndroid
      ? await path_provider.getApplicationDocumentsDirectory()
      : await path_provider.getApplicationSupportDirectory();
  configureDependencies();
  AppData appData = AppData();
  Hive
        ..init(appDocumentDirectory.path)
        ..registerAdapter(CategoryAdapter())
        ..registerAdapter(ProductDataAdapter())
        ..registerAdapter(SubCategoryDataAdapter())
        ..registerAdapter(JobListDataAdapter())
        ..registerAdapter(QtyBreakAdapter())
        ..registerAdapter(AddressDataAdapter())
        ..registerAdapter(ProductDetailsDataAdapter())
        ..registerAdapter(ProductDetailByIdAdapter())
        ..registerAdapter(AccessoryProductAdapter())
        ..registerAdapter(AlternativeProductAdapter())
        ..registerAdapter(BlogPostAdapter())
        ..registerAdapter(AuthorAdapter())
        ..registerAdapter(OrderAdapter())
        ..registerAdapter(ProductAdapter())
        ..registerAdapter(ExtraInfoDataAdapter())
        ..registerAdapter(UserReviewAdapter())
        ..registerAdapter(ReviewedByAdapter())
        ..registerAdapter(CustomerReviewByProductAdapter())
        ..registerAdapter(DeliveryInfoAdapter())
        ..registerAdapter(InvoiceInfoAdapter())
        ..registerAdapter(SiteContactInfoAdapter())
        ..registerAdapter(CustomerReviewForPaginationAdapter())
        ..registerAdapter(SalesOrderDetailsAdapter())
        ..registerAdapter(OrdersAdapter())
        ..registerAdapter(LineAdapter())
        ..registerAdapter(QuotationOrderDetailsListAdapter())
        ..registerAdapter(CustomerAdapter())
        ..registerAdapter(QuotationOrderAdapter())
        ..registerAdapter(CartSelectedValueAdapter())
        ..registerAdapter(DeliveryAdapter())
        ..registerAdapter(InvoiceAdapter())
        ..registerAdapter(SiteContactAdapter())
        ..registerAdapter(AddressAdapter())
        ..registerAdapter(TaxAdapter())
        ..registerAdapter(UnitPriceExAdapter())
        ..registerAdapter(MessageAdapter())
        ..registerAdapter(CustomerReviewByProductForQuoteAdapter())
        ..registerAdapter(QuotationPageReviewForPaginationAdapter())
        ..registerAdapter(CustomerReviewByProductForSaleAdapter())
        ..registerAdapter(UserObjectAdapter())
        ..registerAdapter(JobListProductAdapter())
        ..registerAdapter(ProjectAdapter())
        ..registerAdapter(VideoAdapter())
        ..registerAdapter(SliderDataAdapter())
        ..registerAdapter(ContactInfoAdapter())
        ..registerAdapter(ShippingDetailsAdapter())
        ..registerAdapter(DeliveryMethodAdapter())
        ..registerAdapter(CartItemListAdapter())

      // ..registerAdapter(CustomerReviewDataAdapter())CustomerReviewByProductForSaleAdapter
      ;

  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp(appData: appData));

  // runApp(
  //   DevicePreview(
  //     enabled: true,
  //     // tools: [
  //     //   ...DevicePreview.defaultTools,
  //     //   // const CustomPlugin(),
  //     // ],
  //     builder: (context) => const MyApp(),
  //   ),
  // );
  getDeviceType();
}

DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

String getAndroidDeviceId() {
  String androidId = '';
  deviceInfo.androidInfo.then((AndroidDeviceInfo info) {
    androidId = info.androidId;

    Globals.getDeviceId = androidId;
    // Retrieve the Android device ID
  }).catchError((error) {});

  return androidId;
}

String getIosDeviceId() {
  String iosId = '';
  deviceInfo.iosInfo.then((IosDeviceInfo info) {
    iosId = info.identifierForVendor;
    Globals.getDeviceId = iosId; // Retrieve the iOS device ID
  }).catchError((error) {});
  return iosId;
}

Future<String> getDeviceInfo() async {
  IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  return iosInfo.model.toLowerCase();
}

getDeviceType() async {
  if (Platform.isAndroid) {
    getAndroidDeviceId();
    final data = (MediaQueryData.fromWindow(WidgetsBinding.instance.window));
    Globlas.deviceType = data.size.shortestSide < 600 ? 'phone' : 'tablet';
  } else if (Platform.isIOS) {
    getDeviceInfo();
    final deviceType = await getDeviceInfo();
    Globlas.deviceType = deviceType == "ipad" ? "tablet" : "phone";
  }
}

class MyApp extends StatelessWidget {
  AppData? appData;
  MyApp({Key? key, this.appData}) : super(key: key);

  // This widget is the root of your application.
  // @override

  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppData>(
        create: (_) => appData!,
        child: MediaQuery(
            data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
            // like this it works and produces correct font sizes
            child: ScreenUtilInit(
              designSize: const Size(376, 812),
              builder: (BuildContext context, child) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'PowaGroup',
                theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Color(0xffD60505)),
                    primaryColor: Color(0xffD60505),
                    inputDecorationTheme:
                        InputDecorationTheme(focusColor: Color(0xffD60505)),
                    primarySwatch: Colors.red,
                    appBarTheme: const AppBarTheme(color: Colors.white)),
                navigatorKey: StackedService.navigatorKey,
                onGenerateRoute: StackedRouter().onGenerateRoute,
              ),
            )));
  }
}
