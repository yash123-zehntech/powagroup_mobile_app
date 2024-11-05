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

class ProductSubCategoryViewModel extends BaseViewModel {
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
  onProductSubCategoryItemClick(Category subCategoryObj, BuildContext context) {
    String inputString = subCategoryObj.parentPath.toString();
    List<String> parts = inputString.split('/'); // Split the string by '/'

    if (parts.length >= 2) {
      String id = parts[1]; // Access the second element of the split array
      getProductCategories(id, subCategoryObj); // Output: 76
    } else {}
    ;
  }

  onSearchIconClick(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context, screen: SearchView());
  }

  // Call API for product category
  getProductCategories(String id, subCategoryObj) async {
    HiveDbServices<Category> _localDbForSubSubCategories =
        HiveDbServices(Constants.subSubcategories);
    List<Category>? _subSubCategoriesList =
        await _localDbForSubSubCategories.getData();

    if (_subSubCategoriesList.isEmpty) {
      setBusy(true);
    } else {
      subSubCategoriesList.clear();
    }
    var map = Map<String, dynamic>();
    map['category_id'] = id;
    map['top_level_categories_only'] = "true";

    ProductCategoriesResponse? productCategoriesResponse =
        await apiCall.getProductSubSubCategories(map);

    switch (productCategoriesResponse.statusCode) {
      case Constants.sucessCode:
        await _localDbForSubSubCategories.clear();
        productCategoriesResponse.categories!.forEach((Category element) {
          _localDbForSubSubCategories.addData(element);
        });

        subSubCategoriesList.clear();

        subSubCategoriesList = await _localDbForSubSubCategories.getData();

        navigateScreen(subCategoryObj);

        break;
      case Constants.wrongError:
        isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            productCategoriesResponse.error ?? 'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        isAPIError = true;
        AppUtil.showDialogbox(AppUtil.getContext(),
            productCategoriesResponse.error ?? 'Oops Something went wrong');
        break;
      default:
        {
          if (productCategoriesResponse.error != null &&
              productCategoriesResponse.error!.isNotEmpty) {
            AppUtil.showDialogbox(AppUtil.getContext(),
                productCategoriesResponse.error ?? 'Oops Something went wrong');
          }
        }
        break;
    }
    setBusy(false);
  }

  navigateScreen(subCategoryObj) {
    if (subSubCategoriesList != null && subSubCategoriesList.isNotEmpty) {
      PersistentNavBarNavigator.pushNewScreen(AppUtil.getContext(),
          screen: ProductSubSubCategoryView(
            categoryObj: subCategoryObj,
            subCategoryList: subSubCategoriesList,
          ));
    } else {
      String result = subCategoryObj.parentPath!.replaceFirst("/", "-");
      PersistentNavBarNavigator.pushNewScreen(AppUtil.getContext(),
          screen: ProductSubCategoryItemView(
              subCategoryObj: subCategoryObj, path: result));
    }
  }
}
