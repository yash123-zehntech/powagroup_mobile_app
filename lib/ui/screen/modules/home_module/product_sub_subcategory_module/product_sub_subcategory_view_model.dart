import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_category_module/response_model/product_categories_response.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_sub_subcategory_module/product_sub_subcategory_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/product_subcategory_item_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_module/product_subcategory_view.dart';
import 'package:powagroup/ui/screen/modules/search_module/search_view.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProductSubSubCategoryViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  Api apiCall = locator<Api>();

  bool _isAPIError = false;
  List<Category> _subSubCategoriesList = List.empty(growable: true);
  List<Category> get subSubCategoriesList => _subSubCategoriesList;

  set subSubCategoriesList(List<Category> subSubCategoriesList) {
    _subSubCategoriesList = subSubCategoriesList;
    try {
      Future.delayed(const Duration(seconds: 4), () {
        notifyListeners();
      });
    } catch (error) {}
    // notifyListeners();
  }

  bool get isAPIError => _isAPIError;
  set isAPIError(bool isAPIError) {
    _isAPIError = isAPIError;
    notifyListeners();
  }

  // on login buttion clik
  onProductSubSubCategoryItemClick(
      Category subCategoryObj, BuildContext context) {
    String? result;
    List<String> parts = subCategoryObj.parentPath!.split('/');
    if (parts.length >= 3) {
      result =
          "${parts[1]}-${parts[2]}/"; // Concatenate the second and third elements with a hyphen
    }
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: ProductSubCategoryItemView(
            subCategoryObj: subCategoryObj, path: result));
  }

  onSearchIconClick(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context, screen: SearchView());
  }
}
