import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/response_model/joblist_hive_model.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/job_product_item_module/job_product_item_view.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../home_module/product_subcategory_item_module/response_model/product_hive_model.dart';

class CreateJobListSelectedModel extends BaseViewModel {
  final HiveDbServices<JobListData> _localDb =
      HiveDbServices(Constants.createjobs);
  TextEditingController jobController = TextEditingController();
  final navigationService = locator<NavigationService>();
  final bottomSheetService = locator<BottomSheetService>();
  List<JobListData> _jobList = List.empty(growable: true);
  bool isShowModelPopup = false;
  List<ProductData> _productList = List.empty(growable: true);
  JobListData _createJobList = JobListData();
  String _dropDownTrade = 'Select';
  JobListData? jobList;
  var getId;
  var discription;
  List<JobListData> trade = [];

  JobListData get createJobList => _createJobList;

  set createJobList(JobListData createJobList) {
    _createJobList = createJobList;
    notifyListeners();
  }

  List<ProductData> get productList => _productList;

  set productList(List<ProductData> productList) {
    _productList = productList;
    notifyListeners();
  }

  // on login buttion clik
  onProductItemClick() {}

  // on Button action click
  // onButtonActionClick(BuildContext context) {
  //   PersistentNavBarNavigator.pushNewScreen(context,
  //       screen: JobProductItemView());
  // }

  String get dropDownTrade => _dropDownTrade;
  set dropDownTrade(String dropDownTrade) {
    _dropDownTrade = dropDownTrade;
    notifyListeners();
  }

  getJobList(String value, ProductData productData, JobListData createJobLis,
      BuildContext context) async {
    bool? result;
    _jobList = await _localDb.getData();

    if (_jobList.isNotEmpty) {
      if (createJobLis.id == null) {
        createJobList = JobListData(
          id: _jobList[0].id.toString(),
          jobName: _jobList[0].jobName.toString(),
          jobDate: _jobList[0].jobDate.toString(),
          description: _jobList[0].description.toString(),
          productsList: [],
        );
      }
      for (int i = 0; i < _jobList.length; i++) {
        result = _jobList[i].productsList!.any((element) {
          return element.id == productData.id;
        });

        if (!result) {
          if (_jobList[i].id == createJobList.id) {
            _jobList[i].productsList!.add(JobListProduct(
                description: productData.description,
                yashValue: productData.yashValue,
                extraImages: productData.extraImages,
                id: productData.id,
                isFav: productData.isFav,
                mainImageUrl: productData.mainImageUrl,
                name: productData.name,
                price: productData.price,
                priceByQty: productData.priceByQty,
                priceDelivery: productData.priceDelivery,
                priceTax: productData.priceTax,
                priceTotal: productData.qtyBreaks == null ||
                        productData.qtyBreaks!.isEmpty
                    ? productData.priceTotal
                    : productData.qtyBreaks![0].price,
                priceUntaxed: productData.priceUntaxed,
                qtyBreaks: productData.qtyBreaks,
                saleUom: productData.saleUom,
                sku: productData.sku,
                deliveryEx: productData.deliveryEx,
                deliveryInc: productData.deliveryInc,
                deliveryTax: productData.deliveryTax,
                controllerForJobList: TextEditingController(
                    text: productData.yashValue != null &&
                            productData.yashValue!.isNotEmpty
                        ? productData.yashValue
                        : productData.qtyBreaks != null &&
                                productData.qtyBreaks!.isNotEmpty
                            ? productData.qtyBreaks![0].qty!
                                .replaceAll(".0", "")
                            : '')));

            _localDb.putAt(
                i,
                JobListData(
                    id: createJobList.id,
                    description: createJobList.description,
                    jobName: createJobList.jobName,
                    jobDate: createJobList.jobDate,
                    productsList: _jobList[i].productsList,
                    deliveryEx: _jobList[i].productsList![i].deliveryEx,
                    deliveryInc: _jobList[i].productsList![i].deliveryInc,
                    deliveryTax: _jobList[i].productsList![i].deliveryTax));

            Navigator.of(context).pop();
            AppUtil.showSnackBar("Added to job list successfully");
            try {
              PersistentNavBarNavigator.pushNewScreen(
                  withNavBar: true,
                  context,
                  screen: JobProductItemView(
                    jobList: jobList,
                    productsList: _jobList[i].productsList,
                    jobName: createJobList.jobName,
                    jobDate: createJobList.jobDate,
                  ));
            } catch (e) {}

            notifyListeners();
          } else {}
        } else {
          Navigator.pop(context);

          AppUtil.showSnackBar('Product is already added ');
        }
      }
    }

    _jobList = await _localDb.getData();

    // if (_jobList.isNotEmpty && !result!) {
    //   Navigator.of(AppUtil.getContext()).pop();
    //   AppUtil.showSnackBar("Added to job list successfully");
    // }
  }

  getDropDownList() async {
    trade.clear();
    _jobList = await _localDb.getData();

    if (_jobList.isEmpty) {
      dropDownTrade = 'Select';
      isShowModelPopup = true;
      setBusy(true);
      notifyListeners();
    } else if (_jobList.isNotEmpty) {
      dropDownTrade = _jobList[0].jobName.toString();

      for (int i = 0; i < _jobList.length; i++) {
        jobList = JobListData(
            id: _jobList[i].id,
            jobName: _jobList[i].jobName,
            jobDate: _jobList[i].jobDate,
            description: _jobList[i].description);
        trade.add(jobList!);
      }
      isShowModelPopup = false;

      setBusy(false);
      notifyListeners();
    }
  }
}

class JobList {
  String? id;
  String? jobName;
  String? jobDate;

  JobList(this.id, this.jobName, this.jobDate);
}
