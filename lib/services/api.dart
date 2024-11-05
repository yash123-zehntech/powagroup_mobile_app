import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api_client.dart';
import 'package:powagroup/services/api_methods.dart';
import 'package:powagroup/ui/screen/modules/address_module/response_model/cities_respose.dart';
import 'package:powagroup/ui/screen/modules/address_module/response_model/create_address_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/contact_address_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delete_address_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/get_order_totals_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/invoice_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/extra_info_module/response_model/site_contact.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/response_model/create_order_response.dart';
import 'package:powagroup/ui/screen/modules/blog_module/responseModel/blogdetails_id.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/blog_detail.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/content_slider.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/review_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/videos.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_category_module/response_model/product_categories_response.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_subcategory_response.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/favorite_detail_model.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/rating_details_model.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/response_model/quotation_detail_responsemodel.dart';
import 'package:powagroup/ui/screen/modules/quotation_module/response_model/quotation_response.dart';
import 'package:powagroup/ui/screen/modules/sales_order_detail_module/response_model.dart/sales_details_model.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/sales_order_response.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_model.dart';
import 'package:powagroup/ui/screen/modules/search_module/response_model/search_product_response.dart';
import 'package:powagroup/ui/screen/modules/user_module/login/response_model/login_response.dart';
import 'package:powagroup/ui/screen/modules/user_module/profile/response_model.dart/user_profile_model.dart';
import 'package:powagroup/ui/screen/modules/user_module/register/model/register_reponsemodel.dart';
import 'package:powagroup/ui/screen/modules/user_module/submit_request/model/submit_responsemodel.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/shared_preference.dart';
import 'package:powagroup/util/util.dart';
import '../ui/screen/modules/all_cart_module/delivery_module/response_model/contact_info.dart';
import '../ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_methods_response.dart';
import '../ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_view_response.dart';
import '../ui/screen/modules/all_cart_module/delivery_module/response_model/invoice_response.dart';
import '../ui/screen/modules/all_cart_module/extra_info_module/response_model/warehouses_response_model.dart';
import '../ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_response_with_price.dart';
import '../ui/screen/modules/quotation_detail_module/quotation_add_new_comments_model.dart';
import '../ui/screen/modules/quotation_detail_module/quotation_review_model.dart';
import '../ui/screen/modules/site_address_module/respose_model/create_site_contact_response.dart';
import '../ui/screen/modules/splash_module/splash/response_model/refresh_respose_model.dart';
import '../ui/screen/modules/user_module/forgot_password/response_model/forgot_password_response.dart';
import '../ui/screen/modules/all_cart_module/extra_info_module/response_model/sitecontact_info_response.dart';

@lazySingleton
class Api {
  final ApiMethods _apiMethods = locator<ApiMethods>();
  final ApiClient _apiClient = locator<ApiClient>();
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // //Call Api for User Login
  Future<LoginResponse> userLogin(
    var body,
  ) async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return LoginResponse(error: Constants.noInternet, statusCode: 501);
    }

    Response response =
        await _apiClient.postMethod(_apiMethods.userLogin, body);
    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(name: 'User_login_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return LoginResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'User_login_API_Success');
          LoginResponse resp =
              LoginResponse.fromJson(jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;

          return resp;
        }
      } catch (e) {
        analytics.logEvent(name: 'User_Login_API_in_catch_${e}');
        return LoginResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance.recordError(
          'User login API ${response.statusCode} error error', null);
      analytics.logEvent(
          name: 'User_login_API_${response.statusCode}_error_${response.body}');
      return LoginResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for User Login
  Future<RefreshTokenResponse> refreshToken() async {
    bool internet = await AppUtil.checkNetwork();
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    if (!internet) {
      return RefreshTokenResponse(error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.getMethod(_apiMethods.refreshToken,
        header: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(name: 'Refresh_token_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return RefreshTokenResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Refresh_token_API_success');
          RefreshTokenResponse resp = RefreshTokenResponse.fromJson(
              jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;

          return resp;
        }
      } catch (e) {
        analytics.logEvent(name: 'Refresh_token_API_in_catch_${e}');
        return RefreshTokenResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance.recordError(
          'Refresh token API ${response.statusCode} error error', null);
      analytics.logEvent(
          name:
              'Refresh_token_API_${response.statusCode}_error_${response.body}');
      return RefreshTokenResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for User forgot password
  Future<ForgotPasswordResponse> userForgotPassword(
    var email,
  ) async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return ForgotPasswordResponse(
          error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.postMethod(
        _apiMethods.userForgotPassword + "?email=$email", email);

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        analytics.logEvent(name: 'Forgot_password_API_error_${response.body}');
        if (response.body.contains('error')) {
          var jsonResponse = json.decode(response.body);
          return ForgotPasswordResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Forgot_password_API_success');
          ForgotPasswordResponse resp = ForgotPasswordResponse.fromJson(
              jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(name: 'Forgot_password_API_in_catch_${e}');
        return ForgotPasswordResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance.recordError(
          'Forgot password API ${response.statusCode} error error', null);
      analytics.logEvent(
          name:
              'Forgot_password_API_${response.statusCode}_error_${response.body}');
      return ForgotPasswordResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  //Call Api for Favorite product
  Future<FavoriteResponseModel> checkFavoritePorduct(var body, var id) async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return FavoriteResponseModel(
          error: Constants.noInternet, statusCode: 501);
    }

    var Token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);

    Response response = await _apiClient.postMethod(
      "${_apiMethods.getProductByid}/$id",
      body,
      header: {
        "Authorization": "Bearer $Token",
        "Content-type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Check_favorite_product_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return FavoriteResponseModel(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Check_favorite_product_API_success');
          FavoriteResponseModel resp = FavoriteResponseModel.fromJson(
              jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(name: 'Check_favorite_product_API_in_catch_${e}');
        return FavoriteResponseModel(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance.recordError(
          'Check favorite product API ${response.statusCode} error error',
          null);
      analytics.logEvent(
          name:
              'Check_favorite_product_API_${response.statusCode}_error_${response.body}');
      return FavoriteResponseModel(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  //Call Api for delete address/contact
  Future<DeleteContactResponse> deleteContact(
      Map<String, dynamic> body, int? id) async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return DeleteContactResponse(
          error: Constants.noInternet, statusCode: 501);
    }

    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);

    Response response = await _apiClient.postMethod(
      "${_apiMethods.deleteAddress}/$id/delete",
      json.encode(body),
      header: {
        "Authorization": "Bearer $token",
        "Content-type": "application/json"
      },
    );
    if (response.statusCode == 200) {
      try {
        FirebaseCrashlytics.instance.recordError('Success', null);
        if (response.body.contains('error')) {
          analytics.logEvent(name: 'Delete_product_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return DeleteContactResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Delete_product_API_success');
          DeleteContactResponse resp = DeleteContactResponse.fromJson(
              jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(name: 'Delete_product_API_in_catch_${e}');
        return DeleteContactResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance.recordError(
          'Delete product API ${response.statusCode} error error', null);
      analytics.logEvent(
          name:
              'Delete_product_API_${response.statusCode}_error_${response.body}');
      return DeleteContactResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for Get Product Sub Categoruy

  Future<ProductSubCategoriesItemsResponse> getProductSubCategoryItem1(
      String subCategoryId, var body) async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return ProductSubCategoriesItemsResponse(
          error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.postMethod(
        _apiMethods.getProductCategories + "/$subCategoryId", body, header: {
      'Authorization': 'Bearer $token',
      "Content-Type": "application/json"
    });

    var jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_category_API_error_${response.body}');
          if (jsonResponse.containsKey('error')) {
            analytics.logEvent(
                name: 'Api_mobile_category_API_error_${response.body}');
            return ProductSubCategoriesItemsResponse(
                error: jsonResponse['error']['message'], statusCode: 500);
          } else {
            analytics.logEvent(name: 'Api_mobile_category_API_success');
            ProductSubCategoriesItemsResponse resp =
                ProductSubCategoriesItemsResponse.fromJson(
                    jsonDecode(response.body.toString()));
            resp.statusCode = response.statusCode;
            return resp;
          }
        } else {
          analytics.logEvent(name: 'Api_mobile_category_API_success');
          Map<String, dynamic> jsonResponseMap = json.decode(response.body);
          String resultString = jsonResponseMap['result'];

          Map<String, dynamic> resultObject = json.decode(resultString);

          return ProductSubCategoriesItemsResponse(
              productResult:
                  ProductSubCategoriesItemsResponse.fromJson(resultObject),
              statusCode: 200);
        }
      } catch (e) {
        analytics.logEvent(name: 'Api_mobile_category_API_in_catch_${e}');
        return ProductSubCategoriesItemsResponse(
            error: "ProductSubCategoriesItemsResponse", statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance.recordError(
          'Api_mobile_category_API ${response.statusCode} error error', null);
      analytics.logEvent(
          name:
              'Api_mobile_category_API_${response.statusCode}_error_${response.body}');
      return ProductSubCategoriesItemsResponse(
          error: jsonResponse['error']['message'],
          statusCode: response.statusCode);
    }
  }

  // //Call Api for Get Product Categoruy
  Future<ProductCategoriesResponse> getProductCategories1() async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return ProductCategoriesResponse(
          error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.getMethodWithQuery(
        _apiMethods.getProductCategories,
        body: {"include_pricing": "1"});

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_category_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return ProductCategoriesResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Api_mobile_category_Success');
          ProductCategoriesResponse resp = ProductCategoriesResponse.fromJson(
              jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(name: 'Api_mobile_category_event_in_catch_${e}');
        return ProductCategoriesResponse(error: e.toString(), statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Api_mobile_category error', null);
      analytics.logEvent(name: 'Api_mobile_category_error_${response.body}');
      return ProductCategoriesResponse(
          error: response.body, statusCode: response.statusCode);
    }
  }

  // //Call Api for Get Product Categoruy
  Future<ProductCategoriesResponse> getProductSubSubCategories(var body) async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);

    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return ProductCategoriesResponse(
          error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.getMethodForQueryParams(
        _apiMethods.getProductSubSubCategories, body,
        header: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_subcategories_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return ProductCategoriesResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Api_mobile_subcategories_Success');
          ProductCategoriesResponse resp = ProductCategoriesResponse.fromJson(
              jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Api_mobile_subcategories_event_in_catch_${e}');
        return ProductCategoriesResponse(error: e.toString(), statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Api_mobile_subcategories_error', null);
      analytics.logEvent(
          name: 'Api_mobile_subcategories_error_${response.body}');
      return ProductCategoriesResponse(
          error: response.body, statusCode: response.statusCode);
    }
  }

  Future<UserProfile> getUserObject() async {
    bool internet = await AppUtil.checkNetwork();
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    if (!internet) {
      return UserProfile(error: Constants.noInternet, statusCode: 501);
    }

    Response response =
        await _apiClient.getMethod(_apiMethods.getUserProfile, header: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Get_User_object_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return UserProfile(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Get_User_object_API_Success');
          UserProfile resp =
              UserProfile.fromJson(jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(name: 'Get_User_object_API_event_in_catch_${e}');
        return UserProfile(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Get User object API error', null);
      analytics.logEvent(name: 'Get_User_object_API_error_${response.body}');
      return UserProfile(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for Get Qutation Details
  Future<QuotationOrderDetailsList> getQuotationDetails(
      String qutationId) async {
    bool internet = await AppUtil.checkNetwork();
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    if (!internet) {
      return QuotationOrderDetailsList(
          error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.getMethod(
        _apiMethods.getSalesOrderDetails + "?order_id=$qutationId",
        header: {
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Quotation_details_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return QuotationOrderDetailsList(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'QQuotation_details_API_Success');
          QuotationOrderDetailsList resp =
              QuotationOrderDetailsList.fromJson(json.decode(response.body));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(name: 'Quotation_details_API_event_in_catch_${e}');
        return QuotationOrderDetailsList(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Quotation details API error', null);
      analytics.logEvent(name: 'Quotation_details_API_error_${response.body}');
      return QuotationOrderDetailsList(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for Get sales order Details
  Future<SalesOrderDetails> getSalesOrderDetails(int productId) async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return SalesOrderDetails(error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.getMethod(
        _apiMethods.getSalesOrderDetails + "?order_id=$productId",
        header: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Sales_orders_details_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return SalesOrderDetails(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Sales_orders_details_API_Success');
          SalesOrderDetails resp =
              SalesOrderDetails.fromJson(json.decode(response.body));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Sales_orders_details_API_event_in_catch_${e}');
        return SalesOrderDetails(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Sales orders details API error', null);
      analytics.logEvent(
          name: 'Sales_orders_details_API_error_${response.body}');
      return SalesOrderDetails(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for Get Product DetailPage
  Future<ProductSubDetailModel> getProductDetailPageItem(
      body, String subCategoryId) async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return ProductSubDetailModel(
          error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.postMethodRow(
        "${_apiMethods.getProductByid}/$subCategoryId", body,
        header: token != null && token.isNotEmpty
            ? {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              }
            : null);

    var jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Product_details_API_error_${response.body}');
          return ProductSubDetailModel(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Product_details_API_Success');
          Map<String, dynamic> jsonResponseMap = json.decode(response.body);
          String resultString = jsonResponseMap['result'];

          Map<String, dynamic> resultObject = json.decode(resultString);

          return ProductSubDetailModel(
              productResult: ProductSubDetailModel.fromJson(resultObject),
              statusCode: 200);
        }
      } catch (e) {
        analytics.logEvent(name: 'Product_details_API_event_in_catch_${e}');
        return ProductSubDetailModel(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Product details API error', null);
      analytics.logEvent(name: 'Product_details_API_error_${response.body}');
      return ProductSubDetailModel(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for Get Product Sub Categoruy
  Future<SearchResponse> getProductBySearchKey(body) async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return SearchResponse(error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.postMethod(
        _apiMethods.getProductByKey, body, header: {
      'Authorization': 'Bearer $token',
      "Content-Type": "application/json"
    });

    var jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(name: 'Search_product_API_error_${response.body}');
          if (jsonResponse.containsKey('error')) {
            analytics.logEvent(
                name: 'Search_product_API_error_${response.body}');
            return SearchResponse(
                error: jsonResponse['error']['message'], statusCode: 500);
          } else {
            analytics.logEvent(name: 'Search_product_API_Success');
            Map<String, dynamic> jsonResponseMap = json.decode(response.body);
            String resultString = jsonResponseMap['result'];

            Map<String, dynamic> resultObject = json.decode(resultString);

            return SearchResponse(
                productResult: SearchResponse.fromJson(resultObject),
                statusCode: 200);
          }
        } else {
          analytics.logEvent(name: 'Search_product_API_Success');
          Map<String, dynamic> jsonResponseMap = json.decode(response.body);
          String resultString = jsonResponseMap['result'];

          Map<String, dynamic> resultObject = json.decode(resultString);

          return SearchResponse(
              productResult: SearchResponse.fromJson(resultObject),
              statusCode: 200);
        }
      } catch (e) {
        analytics.logEvent(name: 'Search_product_API_event_in_catch_${e}');
        return SearchResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Search product API error', null);
      analytics.logEvent(name: 'Search_product_API_error_${response.body}');
      return SearchResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for New Product
  Future<ProductSubCategoriesItemsResponse> getNewProduct(var body) async {
    bool internet = await AppUtil.checkNetwork();
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    if (!internet) {
      return ProductSubCategoriesItemsResponse(
          error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.postMethod(
        _apiMethods.getNewProduct + "?new_only=true", body, header: {
      'Authorization': 'Bearer $token',
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(name: 'New_product_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return ProductSubCategoriesItemsResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'New_product_API_Success');
          Map<String, dynamic> jsonResponseMap = json.decode(response.body);
          String resultString = jsonResponseMap['result'];

          Map<String, dynamic> resultObject = json.decode(resultString);

          return ProductSubCategoriesItemsResponse(
              productResult:
                  ProductSubCategoriesItemsResponse.fromJson(resultObject),
              statusCode: 200);
        }
      } catch (e) {
        analytics.logEvent(name: 'New_product_API_event_in_catch_${e}');
        return ProductSubCategoriesItemsResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance.recordError('New product API error', null);
      analytics.logEvent(name: 'New_product_API_error_${response.body}');
      return ProductSubCategoriesItemsResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api Blog Summary
  Future<BlogDetailModel> getBlogSummary() async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return BlogDetailModel(error: Constants.noInternet, statusCode: 501);
    }
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);

    Response response = await _apiClient
        .getMethod(_apiMethods.getBlogSummary + "?summary=False", header: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(name: 'Blog_summery_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return BlogDetailModel(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Blog_summery_API_Success');
          BlogDetailModel resp =
              BlogDetailModel.fromJson(jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(name: 'Blog_summery_API_event_in_catch_${e}');
        return BlogDetailModel(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance.recordError('Blog summery API error', null);
      analytics.logEvent(name: 'Blog_summery_API_error_${response.body}');
      return BlogDetailModel(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // get Content Slider list
  Future<ContentSliderApiResponse> getContentSliderList() async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return ContentSliderApiResponse(
          error: Constants.noInternet, statusCode: 501);
    }
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);

    Response response = await _apiClient.getMethod(
      _apiMethods.getContentSlider,
      //     header: {
      //   "Authorization": "Bearer $token",
      // }
    );

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_content_slider_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return ContentSliderApiResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Api_mobile_content_slider_API_Success');
          ContentSliderApiResponse resp = ContentSliderApiResponse.fromJson(
              jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;

          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Api_mobile_content_slider_API_event_in_catch_${e}');
        return ContentSliderApiResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('/api/mobile/content_slider API error', null);
      analytics.logEvent(
          name: 'Api_mobile_content_slider_API_error_${response.body}');
      return ContentSliderApiResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  Future<VideosApiResponse> getVideosList() async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return VideosApiResponse(error: Constants.noInternet, statusCode: 501);
    }
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);

    Response response = await _apiClient.getMethod(
      _apiMethods.getVideos,
      //     header: {
      //   "Authorization": "Bearer $token",
      // }
    );

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_videos_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return VideosApiResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Api_mobile_videos_API_Success');
          VideosApiResponse resp =
              VideosApiResponse.fromJson(jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(name: 'Api_mobile_videos_API_event_in_catch_${e}');
        return VideosApiResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('/api/mobile/videos API error', null);
      analytics.logEvent(name: 'Api_mobile_videos_API_error_${response.body}');
      return VideosApiResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for All Favourite Product Response
  Future<ProductSubCategoriesItemsResponse> getAllFavouriteProduct1(
      value, body) async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return ProductSubCategoriesItemsResponse(
          error: Constants.noInternet, statusCode: 501);
    }

    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);

    Response response = await _apiClient.postMethod(
        _apiMethods.getAllFavouriteProduct + "/?fav_only=$value", body,
        header: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        });

    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Get_all_favorites_products_API_error_${response.body}');
          if (jsonResponse.containsKey('error')) {
            analytics.logEvent(
                name: 'Get_all_favorites_products_API_error_${response.body}');
            return ProductSubCategoriesItemsResponse(
                error: jsonResponse['error']['message'], statusCode: 500);
          } else {
            analytics.logEvent(name: 'Get_all_favorites_products_API_Success');
            Map<String, dynamic> jsonResponseMap = json.decode(response.body);
            String resultString = jsonResponseMap['result'];

            Map<String, dynamic> resultObject = json.decode(resultString);

            return ProductSubCategoriesItemsResponse(
                productResult:
                    ProductSubCategoriesItemsResponse.fromJson(resultObject),
                statusCode: 200);
          }
        } else {
          analytics.logEvent(name: 'Get_all_favorites_products_API_Success');
          Map<String, dynamic> jsonResponseMap = json.decode(response.body);
          String resultString = jsonResponseMap['result'];

          Map<String, dynamic> resultObject = json.decode(resultString);

          return ProductSubCategoriesItemsResponse(
              productResult:
                  ProductSubCategoriesItemsResponse.fromJson(resultObject),
              statusCode: 200);
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Get_all_favorites_products_API_event_in_catch_${e}');
        return ProductSubCategoriesItemsResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Get all favorites products API error', null);
      analytics.logEvent(
          name: 'Get_all_favorites_products_API_error_${response.body}');
      return ProductSubCategoriesItemsResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for Quotation Response
  Future<QuotationResponse> getQuotations() async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return QuotationResponse(error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient
        .getMethod(_apiMethods.getQuotations + "?order_type=quote", header: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Get_Quotation_products_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return QuotationResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Get_Quotation_products_API_Success');
          QuotationResponse resp =
              QuotationResponse.fromJson(jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Get_Quotation_products_API_event_in_catch_${e}');
        return QuotationResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Get Quotation products API error', null);
      analytics.logEvent(
          name: 'Get_Quotation_products_API_error_${response.body}');
      return QuotationResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for sales Order Response
  Future<SalesOrderResponse> getSalesOrder() async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return SalesOrderResponse(error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.getMethod(
        _apiMethods.getSalesOrder + "?order_type=sale&summary=False",
        header: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Get_Sales_order_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return SalesOrderResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Get_Sales_order_API_Success');
          SalesOrderResponse resp =
              SalesOrderResponse.fromJson(jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(name: 'Get_Sales_order_API_event_in_catch_${e}');
        return SalesOrderResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Get Sales order API error', null);
      analytics.logEvent(name: 'Get_Sales_order_API_error_${response.body}');
      return SalesOrderResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for Get Product DetailPage
  Future<ProductResponseWithPrice> getProductDetailswithPrice1(
      body, String subCategoryId) async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return ProductResponseWithPrice(
          error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.postMethodRow(
        "${_apiMethods.getProductByid}/$subCategoryId", body,
        header: token != null && token.isNotEmpty
            ? {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              }
            : null);

    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_product_with_price_API_error_${response.body}');
          if (jsonResponse.containsKey('error')) {
            analytics.logEvent(
                name:
                    'Api_mobile_product_with_price_API_error_${response.body}');
            return ProductResponseWithPrice(
                error: jsonResponse['error']['message'], statusCode: 500);
          } else {
            analytics.logEvent(
                name: 'Api_mobile_product_with_price_API_error_Success');
            Map<String, dynamic> jsonResponseMap = json.decode(response.body);
            String resultString = jsonResponseMap['result'];

            Map<String, dynamic> resultObject = json.decode(resultString);

            return ProductResponseWithPrice(statusCode: 200);
          }
        } else {
          analytics.logEvent(name: 'Api_mobile_product_with_price_API_Success');
          Map<String, dynamic> jsonResponseMap = json.decode(response.body);
          String resultString = jsonResponseMap['result'];

          Map<String, dynamic> resultObject = json.decode(resultString);

          return ProductResponseWithPrice(statusCode: 200);
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Api_mobile_product_with_price_API_event_in_catch_${e}');
        return ProductResponseWithPrice(
            error: "ProductDetails", statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('/api/mobile/product with price API error', null);
      analytics.logEvent(
          name: 'Api_mobile_product_with_price_API_error_${response.body}');
      return ProductResponseWithPrice(
          error: "ProductDetails", statusCode: response.statusCode);
    }
  }

  Future<BlogDetailByIndex> getBlogDetailPage(String blogid) async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return BlogDetailByIndex(error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.getMethod(
        _apiMethods.getBlogsDetails + "?blog_post_id=$blogid",
        header: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_blog_post_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return BlogDetailByIndex(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Api_mobile_blog_post_API_Success');
          BlogDetailByIndex resp =
              BlogDetailByIndex.fromJson(jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Api_mobile_blog_post_API_event_in_catch_${e}');
        return BlogDetailByIndex(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Api_mobile_blog_post API error', null);
      analytics.logEvent(
          name: 'Api_mobile_blog_post_API_error_${response.body}');
      return BlogDetailByIndex(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for commentSection
  Future<RatingDetail> commentSection(
      var body, subCategoryId, String title, String msg, int i) async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return RatingDetail(error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.postMethod(
        "${_apiMethods.commontSection}/create?product_id=$subCategoryId&title=$title&review=$msg&rating=${i}",
        body);

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Comment_section_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return RatingDetail(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Comment_section_API_Success');
          RatingDetail resp =
              RatingDetail.fromJson(jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(name: 'Comment_section_API_event_in_catch_${e}');
        return RatingDetail(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Comment section API error', null);
      analytics.logEvent(name: 'Comment_section_API_error_${response.body}');
      return RatingDetail(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for commentSection
  Future<QuotationAddNewComments> commentSectionForQuotation(
      var body, subCategoryId, String title, String msg) async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return QuotationAddNewComments(
          error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.postMethod(
        "/api/mobile/order/$subCategoryId/add_comment", body,
        header: {
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Comment_section_for_quotation_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return QuotationAddNewComments(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Comment_section_for_quotation_API_Success');
          QuotationAddNewComments resp = QuotationAddNewComments.fromJson(
              jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Comment_section_for_quotation_API_event_in_catch_${e}');
        return QuotationAddNewComments(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Comment section for quotation API error', null);
      analytics.logEvent(
          name: 'Comment_section_for_quotation_API_error_${response.body}');
      return QuotationAddNewComments(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  Future<ProductReview> getCustomerReviewDetail() async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return ProductReview(error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.getMethod(
      _apiMethods.customerReview,
    );
    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_review_recent_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return ProductReview(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Api_mobile_review_recent_API_Success');
          ProductReview resp =
              ProductReview.fromJson(jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Api_mobile_review_recent_API_event_in_catch_${e}');
        return ProductReview(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Api_mobile_review_recent API error', null);
      analytics.logEvent(
          name: 'Api_mobile_review_recent_API_error_${response.body}');
      return ProductReview(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  Future<ProductReview> getLeaveComments(productId, offset) async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return ProductReview(error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.getMethod(
      "${_apiMethods.commontSection}/product?product_id=$productId&offset=$offset&limit=${10}",
    );

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(name: 'Leave_comments_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return ProductReview(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Leave_comments_API_Success');
          ProductReview resp =
              ProductReview.fromJson(jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;

          return resp;
        }
      } catch (e) {
        analytics.logEvent(name: 'Leave_comments_API_event_in_catch_${e}');
        return ProductReview(error: Constants.review, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Leave comments API error', null);
      analytics.logEvent(name: 'Leave_comments_API_error_${response.body}');
      return ProductReview(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  Future<QuotationComments> getLeaveCommentsForQuotation(
      productId, offset) async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return QuotationComments(error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.getMethod(
        "/api/mobile/order/$productId/messages?offset=0&limit=30",
        header: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Leave_comments_for_quotation_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return QuotationComments(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Leave_comments_for_quotation_API_Success');
          QuotationComments resp =
              QuotationComments.fromJson(jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;

          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Leave_comments_for_quotation_API_event_in_catch_${e}');
        return QuotationComments(error: Constants.review, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Leave comments for quotation API error', null);
      analytics.logEvent(
          name: 'Leave_comments_for_quotation_API_error_${response.body}');
      return QuotationComments(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  getDeliveryAddress() async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return DeliveryAddressResponse(
          error: Constants.noInternet, statusCode: 501);
    }

    Response response =
        await _apiClient.getMethod(_apiMethods.getDeliveryAddress, header: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_contacts_delivery_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return DeliveryAddressResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Api_mobile_contacts_delivery_API_Success');
          List<DeliveryInfo> list = deliveryInfoFromJson(response.body);

          DeliveryAddressResponse resp = DeliveryAddressResponse(
              deliveryAddressInfo: list, error: null, statusCode: 200);
          resp.statusCode = 200;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Api_mobile_contacts_delivery_API_event_in_catch_${e}');
        return DeliveryAddressResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Api_mobile_contacts_delivery API error', null);
      analytics.logEvent(
          name: 'Api_mobile_contacts_delivery_API_error_${response.body}');
      return DeliveryAddressResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  getInvoiceAddress() async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();

    if (!internet) {
      return InvoiceAddressResponse(
          error: Constants.noInternet, statusCode: 501);
    }

    Response response =
        await _apiClient.getMethod(_apiMethods.getInvoiceAddress, header: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_contacts_invoice_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return InvoiceAddressResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Api_mobile_contacts_invoice_API_Success');
          List<InvoiceInfo> list = invoiceInfoFromJson(response.body);

          InvoiceAddressResponse resp = InvoiceAddressResponse(
              invoiceAddressInfo: list, error: null, statusCode: 200);
          resp.statusCode = 200;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Api_mobile_contacts_invoice_API_event_in_catch_${e}');
        return InvoiceAddressResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Api_mobile_contacts_invoice API error', null);
      analytics.logEvent(
          name: 'Api_mobile_contacts_invoice_API_error_${response.body}');
      return InvoiceAddressResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  getContactAddress() async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();

    if (!internet) {
      return ContactAddressResponse(
          error: Constants.noInternet, statusCode: 501);
    }

    Response response =
        await _apiClient.getMethod(_apiMethods.getContactAddress, header: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_contacts_contact_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return ContactAddressResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Api_mobile_contacts_contact_API_Success');
          List<ContactInfo> list = contactInfoFromJson(response.body);

          ContactAddressResponse resp = ContactAddressResponse(
              contactAddressInfo: list, error: null, statusCode: 200);
          resp.statusCode = 200;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Api_mobile_contacts_contact_API_event_in_catch_${e}');
        return ContactAddressResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Api_mobile_contacts_contact API error', null);
      analytics.logEvent(
          name: 'Api_mobile_contacts_contact_API_error_${response.body}');
      return ContactAddressResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for Extra Information
  Future<SiteContactResponse> getExtraInfo() async {
    var jsonResponse;

    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return SiteContactResponse(error: Constants.noInternet, statusCode: 501);
    }

    Response response =
        await _apiClient.getMethod(_apiMethods.getSiteContact, header: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_contacts_all_API_error_${response.body}');
          jsonResponse = json.decode(response.body);

          return SiteContactResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Api_mobile_contacts_all_API_Success');
          List<SiteContactInfo> list =
              siteContactInfoFromJson(response.body.toString());

          SiteContactResponse resp = SiteContactResponse(
              siteContactInfo: list, error: null, statusCode: 200);

          resp.statusCode = 200;

          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Api_mobile_contacts_all_API_event_in_catch_${e}');
        return SiteContactResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Api_mobile_contacts_all API error', null);
      analytics.logEvent(
          name: 'Api_mobile_contacts_all_API_error_${response.body}');
      return SiteContactResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for Extra Information
  Future<WarehousesResponse> getWarehouseListItems() async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return WarehousesResponse(error: Constants.noInternet, statusCode: 501);
    }

    Response response =
        await _apiClient.getMethod(_apiMethods.getWarehouses, header: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_warehouses_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return WarehousesResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Api_mobile_warehouses_API_Success');
          WarehousesResponse resp =
              WarehousesResponse.fromJson(jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Api_mobile_warehouses_API_event_in_catch_${e}');
        return WarehousesResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Api_mobile_warehouses API error', null);
      analytics.logEvent(
          name: 'Api_mobile_warehouses_API_error_${response.body}');
      return WarehousesResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  Future<RegisterResponse> registerUser(
    var body,
  ) async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return RegisterResponse(error: Constants.noInternet, statusCode: 501);
    }

    Response response =
        await _apiClient.postMethod(_apiMethods.registerUser, body);

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_registration_new_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return RegisterResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Api_mobile_registration_new_API_Success');
          RegisterResponse resp =
              RegisterResponse.fromJson(jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Api_mobile_registration_new_API_event_in_catch_${e}');
        return RegisterResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Api_mobile_registration_new API error', null);
      analytics.logEvent(
          name: 'Api_mobile_registration_new_API_error_${response.body}');
      return RegisterResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // Create Address API
  Future<CreateAddressResponse> createAddress(
    var body,
    String? addressId,
  ) async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return CreateAddressResponse(
          error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.postMethod(
      addressId != null && addressId.isNotEmpty
          ? '${_apiMethods.deleteAddress}/${int.parse(addressId)}/update'
          : _apiMethods.createAddress,
      json.encode(body),
      header: {
        "Authorization": "Bearer $token",
        "Content-type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(name: 'Create_address_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          if (jsonResponse.containsKey('error')) {
            analytics.logEvent(
                name: 'Create_address_API_error_${response.body}');
            return CreateAddressResponse(
                error: jsonResponse['error']['message'], statusCode: 500);
          } else {
            analytics.logEvent(name: 'Create_address_API_Success');
            CreateAddressResponse resp = CreateAddressResponse.fromJson(
                jsonDecode(response.body.toString()));
            resp.statusCode = response.statusCode;
            return resp;
          }
        } else {
          analytics.logEvent(name: 'Create_address_API_Success');
          CreateAddressResponse resp = CreateAddressResponse.fromJson(
              jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(name: 'Create_address_API_event_in_catch_${e}');
        return CreateAddressResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Create address API error', null);
      analytics.logEvent(name: 'Create_address_API_error_${response.body}');
      return CreateAddressResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  Future<SubmitResponse> submitRegisterUser(
    var body,
  ) async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return SubmitResponse(error: Constants.noInternet, statusCode: 501);
    }

    Response response =
        await _apiClient.postMethod(_apiMethods.submitRequestForRegister, body);
    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name:
                  'Api_mobile_registration_existing_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return SubmitResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(
              name: 'Api_mobile_registration_existing_API_Success');
          SubmitResponse resp =
              SubmitResponse.fromJson(jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Api_mobile_registration_existing_API_event_in_catch_${e}');
        return SubmitResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Api_mobile_registration_existing API error', null);
      analytics.logEvent(
          name: 'Api_mobile_registration_existing_API_error_${response.body}');
      return SubmitResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  Future<CreateOrderResponse> proceedToPay(
    var body,
  ) async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return CreateOrderResponse(error: Constants.noInternet, statusCode: 501);
    }

    var Token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);

    Response response = await _apiClient.postMethod(
      _apiMethods.create,
      body,
      header: {
        "Authorization": "Bearer $Token",
        "Content-type": "application/json"
      },
    );

    print("Body ------------ ${response.body}");

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_order_create_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return CreateOrderResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Api_mobile_order_create_API_Success');
          CreateOrderResponse resp = CreateOrderResponse.fromJson(
              jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Api_mobile_order_create_API_event_in_catch_${e}');
        return CreateOrderResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Api_mobile_order_create API error', null);
      analytics.logEvent(
          name: 'Api_mobile_order_create_API_error_${response.body}');
      return CreateOrderResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // Confirm Payment
  Future<CreateOrderResponse> confirmPayment(
    var body,
    orderId,
  ) async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return CreateOrderResponse(error: Constants.noInternet, statusCode: 501);
    }

    var Token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);

    Response response = await _apiClient.postMethod(
      '${_apiMethods.confirmPayment}/$orderId/confirm',
      body,
      header: {
        "Authorization": "Bearer $Token",
        "Content-type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      print("Body ----------- ${response.body}");
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        var jsonResponse = json.decode(response.body);

        // Check if `result` exists and handle it based on its type
        if (jsonResponse.containsKey('result')) {
          var result = jsonResponse['result'];

          // If `result` is a String, parse it as JSON for error handling
          if (result is String) {
            var resultJson =
                json.decode(result); // Decode the inner JSON string in 'result'

            if (resultJson['status'] == 'error' &&
                resultJson.containsKey('error')) {
              analytics.logEvent(
                  name:
                      'confirm_payment_api_error_${resultJson['error']['message']}');
              return CreateOrderResponse(
                  error: resultJson['error']['message'], statusCode: 500);
            }
          } else {
            // If `result` is already a JSON object, treat it as a success response
            analytics.logEvent(name: 'confirm_payment_api_error_Success');
            CreateOrderResponse resp =
                CreateOrderResponse.fromJson(jsonResponse);
            resp.statusCode = response.statusCode;
            return resp;
          }
        }

        // In case `result` is not found, handle as unexpected response
        return CreateOrderResponse(
            error: 'Unexpected response format', statusCode: 500);
      } catch (e) {
        analytics.logEvent(name: 'confirm_payment_api_error_in_catch_${e}');
        return CreateOrderResponse(error: e.toString(), statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('confirm_payment_api_error API error', null);
      analytics.logEvent(name: 'confirm_payment_api_error_${response.body}');
      return CreateOrderResponse(
          error: response.body, statusCode: response.statusCode);
    }

    // if (response.statusCode == 200) {
    //   print("Body ----------- ${response.body}");
    //   FirebaseCrashlytics.instance.recordError('Success', null);
    //   try {
    //     if (response.body.contains('error')) {
    //       analytics.logEvent(
    //           name: 'confirm_payment_api_error_${response.body}');
    //       var jsonResponse = json.decode(response.body);
    //       if (jsonResponse.containsKey('error')) {
    //         analytics.logEvent(
    //             name: 'confirm_payment_api_error_${response.body}');
    //         return CreateOrderResponse(
    //             error: jsonResponse['error']['message'], statusCode: 500);
    //       } else {
    //         analytics.logEvent(name: 'confirm_payment_api_error_Success');
    //         CreateOrderResponse resp = CreateOrderResponse.fromJson(
    //             jsonDecode(response.body.toString()));
    //         resp.statusCode = response.statusCode;
    //         return resp;
    //       }
    //     } else {
    //       analytics.logEvent(name: 'confirm_payment_api_error_Success');
    //       CreateOrderResponse resp = CreateOrderResponse.fromJson(
    //           jsonDecode(response.body.toString()));
    //       resp.statusCode = response.statusCode;
    //       return resp;
    //     }
    //   } catch (e) {
    //     analytics.logEvent(name: 'confirm_payment_api_error_in_catch_${e}');
    //     return CreateOrderResponse(error: e.toString(), statusCode: 500);
    //   }
    // } else {
    //   FirebaseCrashlytics.instance
    //       .recordError('confirm_payment_api_error API error', null);
    //   analytics.logEvent(name: 'confirm_payment_api_error_${response.body}');
    //   return CreateOrderResponse(
    //       error: response.body, statusCode: response.statusCode);
    // }
  }

  // //Call Api for Get cities
  Future<CitiesListResponse> getCities(var body) async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return CitiesListResponse(error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient
        .getMethodForQueryParams(_apiMethods.cities, body, header: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_contacts_cities_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          return CitiesListResponse(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          analytics.logEvent(name: 'Api_mobile_contacts_cities_API_Success');
          CitiesListResponse resp =
              CitiesListResponse.fromJson(jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Api_mobile_contacts_cities_API_event_in_catch_${e}');
        return CitiesListResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Api_mobile_contacts_cities API error', null);
      analytics.logEvent(
          name: 'Api_mobile_contacts_cities_API_error_${response.body}');
      return CitiesListResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  Future<DeliveryMethodsResponse> getDeliveryMethods(var body) async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);

    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return DeliveryMethodsResponse(
          error: Constants.noInternet, statusCode: 501);
    }
    Response response = await _apiClient
        .postMethodRow(_apiMethods.deliveryMethods, body, header: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'Api_mobile_delivery_methods_API_error_${response.body}');
          if (jsonResponse.containsKey('error')) {
            analytics.logEvent(
                name: 'Api_mobile_delivery_methods_API_error_${response.body}');
            return DeliveryMethodsResponse(
                error: jsonResponse['error']['message'], statusCode: 500);
          } else {
            analytics.logEvent(name: 'Api_mobile_delivery_methods_API_Success');
            DeliveryMethodsResponse resp = DeliveryMethodsResponse.fromJson(
                jsonDecode(response.body.toString()));
            resp.statusCode = response.statusCode;
            return resp;
          }
        } else {
          analytics.logEvent(name: 'Api_mobile_delivery_methods_API_Success');
          Map<String, dynamic> jsonResponseMap = json.decode(response.body);
          String resultString = jsonResponseMap['result'];

          Map<String, dynamic> resultObject = json.decode(resultString);

          return DeliveryMethodsResponse(
              deliveryMethodsResult:
                  DeliveryMethodsResponse.fromJson(resultObject),
              statusCode: 200);
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Api_mobile_delivery_methods_API_event_in_catch_${e}');
        return DeliveryMethodsResponse(error: e.toString(), statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Api_mobile_delivery_methods API error', null);
      analytics.logEvent(
          name: 'Api_mobile_delivery_methods_API_error_${response.body}');
      return DeliveryMethodsResponse(
          error: response.body, statusCode: response.statusCode);
    }
  }

  // //Call Api for User Login
  Future<CreateSiteContactResponse> createSiteContact(
    var body,
  ) async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return CreateSiteContactResponse(
          error: Constants.noInternet, statusCode: 501);
    }

    Response response = await _apiClient.postMethod(
      _apiMethods.createSiteContact,
      json.encode(body),
      header: {
        "Authorization": "Bearer $token",
        "Content-type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name:
                  'Api_mobile_site_contacts_create_API_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          if (jsonResponse.containsKey('error')) {
            analytics.logEvent(
                name:
                    'Api_mobile_site_contacts_create_API_error_${response.body}');
            return CreateSiteContactResponse(
                error: jsonResponse['error']['message'], statusCode: 500);
          } else {
            analytics.logEvent(
                name: 'Api_mobile_site_contacts_create_API_Success');
            CreateSiteContactResponse resp = CreateSiteContactResponse.fromJson(
                jsonDecode(response.body.toString()));
            resp.statusCode = response.statusCode;
            return resp;
          }
        } else {
          analytics.logEvent(
              name: 'Api_mobile_site_contacts_create_API_Success');
          CreateSiteContactResponse resp = CreateSiteContactResponse.fromJson(
              jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(
            name: 'Api_mobile_site_contacts_create_API_event_in_catch_${e}');
        return CreateSiteContactResponse(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('Api_mobile_site_contacts_create API error', null);
      analytics.logEvent(
          name: 'Api_mobile_site_contacts_create_API_error_${response.body}');
      return CreateSiteContactResponse(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // Call the API to get Order total
  Future<GetOrderTotalsResponse> getOrderTotal(var body) async {
    var token = await SharedPre.getStringValue(SharedPre.LOGIN_TOKEN);

    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return GetOrderTotalsResponse(
          error: Constants.noInternet, statusCode: 501);
    }
    Response response = await _apiClient
        .postMethodRow(_apiMethods.getOrderTotals, body, header: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      print("Body ----------- ${response.body}");
      FirebaseCrashlytics.instance.recordError('Success', null);
      try {
        if (response.body.contains('error')) {
          analytics.logEvent(
              name: 'get_order_totals_api_error_${response.body}');
          var jsonResponse = json.decode(response.body);
          if (jsonResponse.containsKey('error')) {
            analytics.logEvent(
                name: 'get_order_totals_api_error_${response.body}');
            return GetOrderTotalsResponse(
                error: jsonResponse['error']['message'], statusCode: 500);
          } else {
            analytics.logEvent(name: 'get_order_totals_api_error_Success');
            GetOrderTotalsResponse resp = GetOrderTotalsResponse.fromJson(
                jsonDecode(response.body.toString()));
            resp.statusCode = response.statusCode;
            return resp;
          }
        } else {
          analytics.logEvent(name: 'get_order_totals_api_error_Success');
          GetOrderTotalsResponse resp = GetOrderTotalsResponse.fromJson(
              jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        analytics.logEvent(name: 'get_order_totals_api_error_in_catch_${e}');
        return GetOrderTotalsResponse(error: e.toString(), statusCode: 500);
      }
    } else {
      FirebaseCrashlytics.instance
          .recordError('get_order_totals_api_error API error', null);
      analytics.logEvent(name: 'get_order_totals_api_error_${response.body}');
      return GetOrderTotalsResponse(
          error: response.body, statusCode: response.statusCode);
    }
  }
}
