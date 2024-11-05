import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/services/hive_db_services.dart';

import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_subcategory_response.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/product_detail_view.dart';
import 'package:powagroup/ui/screen/modules/search_module/search_view.dart';
import 'package:powagroup/util/constant.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../app/locator.dart';
import '../../../../services/api.dart';

class PapularProductListViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  Api apiCall = locator<Api>();

  onSearchIconClick(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context, screen: SearchView());
  }

  onPopularItemClick(list, int index, BuildContext context) {}
}
