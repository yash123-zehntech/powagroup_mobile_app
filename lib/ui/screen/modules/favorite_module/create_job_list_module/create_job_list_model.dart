import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/create_job_list_selected.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/response_model/joblist_hive_model.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_job_list_module/response_model/create_job_list_response_model.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../home_module/product_subcategory_item_module/response_model/product_hive_model.dart';

class CreateJobListViewModel extends BaseViewModel {
  TextEditingController jobNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController jobDateController = TextEditingController();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final HiveDbServices<JobListData> _localDb =
      HiveDbServices(Constants.createjobs);
  Api apiCall = locator<Api>();
  final navigationService = locator<NavigationService>();
  final bottomSheetService = locator<BottomSheetService>();
  JobListData? jobListData;
  bool isShowModelPopup = false;
  List<JobListProduct> _productList = List.empty(growable: true);
  List<JobListData> _jobList = [];
  List<JobListData> _jobListItem = [];
  List<JobListData> _createdjobList = [];
  List<JobListData> initJobList = [];
  List<JobListProduct> get productList => _productList;
  List<JobListData> getJobListItem = List.empty(growable: true);

  set productList(List<JobListProduct> productList) {
    _productList = productList;
    notifyListeners();
  }

  // on Button action click
  onButtonActionClick() {
    navigationService.navigateTo(Routes.jobProductItemView);
  }

  onCrossButtonClick() {
    navigationService.navigateTo(Routes.productSubCategoryItemView);
  }

  //   api calling
  callCreateJobListApi(ProductData? productData, BuildContext context) async {
    _jobList.add(JobListData(
        id: AppUtil.getCurrentDate(),
        jobName: jobNameController.text,
        description: descriptionController.text,
        jobDate: jobDateController.text,
        productsList: productList));

    _localDb.putListData(_jobList);
    initJobList = await _localDb.getData();

    if (productData != null) {
      if (initJobList.length == 1) {
        getJobList(
            productData,
            JobListData(
                id: _jobList[0].id,
                jobName: jobNameController.text,
                description: descriptionController.text,
                jobDate: jobDateController.text,
                productsList: productList));
      }
    }

    Navigator.pop(context);
  }

  getJobList(ProductData productData, JobListData createJobLis) async {
    _createdjobList = await _localDb.getData();

    if (_createdjobList.isNotEmpty) {
      //  if (_createdjobList.contains(createJobLis.id)) {
      //      AppUtil.showSnackBar("Product is Already exsist");
      //    } else {
      for (int i = 0; i < _createdjobList.length; i++) {
        bool result = _createdjobList[i]
            .productsList!
            .any((element) => element.id == productData.id);
        if (!result) {
          if (_createdjobList[i].id == createJobLis.id) {
            _createdjobList[i].productsList!.add(JobListProduct(
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
                deliveryTax: productData.deliveryTax,
                priceTax: productData.priceTax,
                priceTotal: productData.qtyBreaks == null || productData.qtyBreaks!.isEmpty
                    ? productData.priceTotal
                    : productData.qtyBreaks![0].price,
                priceUntaxed: productData.priceUntaxed,
                qtyBreaks: productData.qtyBreaks,
                saleUom: productData.saleUom,
                sku: productData.sku,
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
                    id: createJobLis.id,
                    description: createJobLis.description,
                    jobName: createJobLis.jobName,
                    jobDate: createJobLis.jobDate,
                    productsList: _createdjobList[i].productsList));
          }
          _createdjobList = await _localDb.getData();
          if (_createdjobList.isNotEmpty == true) {
            return AppUtil.showSnackBar("Added to job list successfully");
          }
        } else {
          navigationService.back();
          AppUtil.showSnackBar('Product is already added ');
        }
      }
      // }
    }
  }

  updateJobList(JobListData? jobList) async {}

  updateJobListAPi(JobListData? jobList, BuildContext context) async {
    getJobListItem.clear();
    getJobListItem = await AppUtil.getJobProductList();
    _localDb.clear();
    for (var i = 0; i < getJobListItem.length; i++) {
      if (getJobListItem[i].id == jobList!.id) {
        getJobListItem[i].jobName = jobNameController.text;
        getJobListItem[i].description = descriptionController.text;
        getJobListItem[i].productsList = jobList.productsList;
        getJobListItem[i].jobDate = jobDateController.text;
      }
    }
    await _localDb.putListData(getJobListItem);
    Navigator.pop(context);
    // return true;
  }
}
