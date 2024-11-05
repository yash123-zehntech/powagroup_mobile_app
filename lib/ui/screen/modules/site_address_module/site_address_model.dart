import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/helper_widget/debouncer.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/globals.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/address_module/response_model/address_response.dart';
import 'package:powagroup/ui/screen/modules/address_module/response_model/create_address_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/extra_info_module/response_model/site_contact.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_page_module/home_page_view.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/respose_model/site_contact_model.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../all_cart_module/cart_module/cart_view.dart';
import 'respose_model/create_site_address.dart';
import 'respose_model/create_site_contact_response.dart';

class SiteAddressViewMode extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController mobileNumberController = TextEditingController();

  GlobalKey<FormState> formKeyForSiteContact = new GlobalKey<FormState>();

  Api apiCall = locator<Api>();
  String? _deliveryAddressId;
  String? get deliveryAddressId => _deliveryAddressId;
  set deliveryAddressId(String? deliveryAddressId) {
    _deliveryAddressId = deliveryAddressId;
    notifyListeners();
  }

  onSubmitButtonClick(BuildContext context) async {
    if (formKeyForSiteContact.currentState!.validate()) {
      formKeyForSiteContact.currentState!.save();
      callSiteContactApi();
    }
  }

  //  send otp api calling
  callSiteContactApi() async {
    setBusy(true);

    SiteContactCreateData data = SiteContactCreateData();
    var map = Map<String, dynamic>();
    // data.firstname = firstNameController.text.toString();
    data.firstname = firstNameController.text.toString();
    data.lastname = lastNameController.text.toString();
    data.email = emailController.text.toString();
    data.mobile = mobileNumberController.text.toString();
    data.deliveryAddressId = deliveryAddressId.toString();
    // map["firstname"] = firstNameController.text.toString();
    // map["lastname"] = emailController.text.toString();
    // map["email"] = emailController.text.toString();
    // map["mobile"] = mobileNumberController.text.toString();
    // map["delivery_address_id"] = deliveryAddressId.toString();

    // String jsonData = jsonEncode();
    //json.encode(mapRequest.toJson()

    CreateSiteContactResponse createSiteContactResponse =
        await apiCall.createSiteContact(data.toJson());

    switch (createSiteContactResponse.statusCode) {
      case Constants.sucessCode:
        // setToken(siteResponse.token!);
        bool result =
            await PersistentNavBarNavigator.pushNewScreen(AppUtil.getContext(),
                screen: CartView(
                  index: 2,
                ));

        break;
      case Constants.wrongError:
        AppUtil.showDialogbox(AppUtil.getContext(),
            createSiteContactResponse.error ?? 'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        AppUtil.showDialogbox(AppUtil.getContext(),
            createSiteContactResponse.error ?? 'Oops Something went wrong');

        break;
      default:
        {
          if (createSiteContactResponse.error != null &&
              createSiteContactResponse.error!.isNotEmpty) {
            AppUtil.showDialogbox(AppUtil.getContext(),
                createSiteContactResponse.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    setBusy(false);
  }
}
