import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/projects.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/videos.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_module/product_subcategory_view.dart';
import 'package:powagroup/ui/screen/modules/project_module/project.dart';
import 'package:powagroup/ui/screen/modules/search_module/search_view.dart';
import 'package:powagroup/ui/screen/modules/video_module/video_player/video_player.dart';
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

class ProjectsListViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  Api apiCall = locator<Api>();
  ProductCategoriesResponse? productCategoriesResponse;
  List<Category> _categoriesList = List.empty(growable: true);
  final HiveDbServices<Category> _localDb =
      HiveDbServices(Constants.categories);

  onSearchIconClick(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context, screen: SearchView());
  }

  onProjetItemClick(Project project, int index, BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(context,
        screen: ProjectDetailView(
          project: project,
        ));
  }
}
