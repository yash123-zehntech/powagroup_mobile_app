import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/create_job_list_selected.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_job_list_module/create_job_list_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/search_module/search_view.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../create_jobList_dropdown model/response_model/joblist_hive_model.dart';

class ConfirmationViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final bottomSheetService = locator<BottomSheetService>();
  bool isShowModelPopup = false;
  List<JobListData> jobList = List.empty(growable: true);

  // on login buttion clik
  onProductItemClick() {}

  // on Button action click
  onYesButtonActionClick(BuildContext context) {
    Navigator.of(AppUtil.getContext()).pop();
     PersistentNavBarNavigator.pushNewScreen(context,
        screen: SearchView());
  }

  clickForJob(ProductData? searchList) async {
    jobList.clear();
    jobList = await AppUtil.getJobProductList();
    if (jobList.isEmpty || jobList.length == []) {
      await Navigator.of(AppUtil.getContext()).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => CreateJoblistView(
                productData: searchList,
                index: 0,
                //key: key,
                //title: 'title',
              )));
    } else {
      await Navigator.of(AppUtil.getContext()).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => CreateJoblistSelected(
                productData: searchList,
              )));
    }
    Navigator.of(AppUtil.getContext()).pop();
    jobList = await AppUtil.getJobProductList();
  }
}
