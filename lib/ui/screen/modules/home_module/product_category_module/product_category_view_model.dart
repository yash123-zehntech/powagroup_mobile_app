import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_module/product_subcategory_view.dart';
import 'package:powagroup/ui/screen/modules/search_module/search_view.dart';
import 'package:provider/provider.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_category_module/response_model/product_categories_response.dart';
import 'package:powagroup/util/app_data.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProductCategoryViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  Api apiCall = locator<Api>();
  ProductCategoriesResponse? productCategoriesResponse;
  List<Category> _categoriesList = List.empty(growable: true);
  final HiveDbServices<Category> _localDb =
      HiveDbServices(Constants.categories);

  List<Category> get categoriesList => _categoriesList;

  set categoriesList(List<Category> categoriesList) {
    categoriesList =
        categoriesList.where((element) => element.parentId == false).toList();

    _categoriesList.clear();
    _categoriesList = categoriesList;
    notifyListeners();
  }

  onSearchIconClick(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context, screen: SearchView());
  }

  // on login buttion clik
  onProductCategoryItemClick(
      Category categoryObj, int index, BuildContext context) async {
    List<Category>? _categoriesList = await _localDb.getData();

    List<Category> subCategoryList = _categoriesList
        .where((element) => element.parentName == categoriesList[index].name)
        .toList();
    if (subCategoryList.isNotEmpty) {
      PersistentNavBarNavigator.pushNewScreen(context,
          screen: ProductSubCategoryView(
            categoryObj: categoryObj,
            subCategoryList: subCategoryList,
          ));
    } else {}
  }

  // get Local DB Data for Categories
  getCategories() async {
    // setBusy(true);
    List<Category>? _categoriesList = await _localDb.getData();

    if (_categoriesList.isNotEmpty) {
      categoriesList.clear();
      categoriesList = _categoriesList
          .where((element) => element.parentId == false)
          .toList();
      // setBusy(false);
    }

    notifyListeners();
  }
}
