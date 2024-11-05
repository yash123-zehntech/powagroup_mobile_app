import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/job_dropdown.dart';
import 'package:powagroup/helper_widget/labal_field_contant_widget.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/create_job_list_selected_model.dart';

import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/response_model/joblist_hive_model.dart';

import 'package:powagroup/ui/screen/modules/favorite_module/create_job_list_module/create_job_list_view.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import '../../home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import '../job_product_item_module/job_product_item_view.dart';

class CreateJoblistSelected extends StatefulWidget {
  ProductData? productData;
  List<JobListData>? createJobList;
  CreateJoblistSelected({Key? key, this.productData, this.createJobList})
      : super(key: key);

  @override
  State<CreateJoblistSelected> createState() =>
      _CreateJoblistViewWithDropDownState();
}

class _CreateJoblistViewWithDropDownState extends State<CreateJoblistSelected> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateJobListSelectedModel>.reactive(
      viewModelBuilder: () => CreateJobListSelectedModel(),
      onViewModelReady: (viewModel) {
        viewModel.getDropDownList();
      },
      builder: (context, viewModel, child) => Scaffold(
          backgroundColor: const Color(0xffD8D8D9).withOpacity(0.72),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              joblistView(context, viewModel, widget.productData),
            ],
          )),
    );
  }

  // Return Confirmation View
  Widget joblistView(
    context,
    CreateJobListSelectedModel viewModel,
    ProductData? productData,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
      decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                padding: const EdgeInsets.all(8),
                icon: Icon(
                  PowaGroupIcon.cross,
                  size: 24.h,
                  color: const Color(0xff36393C),
                ),
                onPressed: () {
                  //viewModel.navigationService.back();
                  //===========sayyam
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          // const SizedBox(
          //   height: 7,
          // ),
          // const Center(
          //     child: Icon(PowaGroupIcon.alrt, color: const Color(0xffD60505))),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: fieldContent("Select Job List"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Container(
                child: dropDownforJob(context, viewModel,
                    viewModel.dropDownTrade, 1, viewModel.createJobList)),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: InkWell(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buttonWidget(
                      'Add to Job List',
                      const Color(0xffD60505),
                      const Color(0xffFFFFFF),
                      viewModel,
                      context,
                      2,
                      widget.productData,
                      viewModel.createJobList),
                ],
              ),
            ),
          ),
          viewModel.isBusy == false
              ? const SizedBox(
                  height: 8,
                )
              : Container(),
          viewModel.isBusy == false
              ? Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buttonWidget(
                          'Create Job List',
                          const Color(0xffD60505),
                          const Color(0xffFFFFFF),
                          viewModel,
                          context,
                          1,
                          widget.productData,
                          viewModel.createJobList),
                    ],
                  ),
                )
              : Container(),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}

Widget buttonWidget(
  String title,
  Color color,
  Color textColor,
  CreateJobListSelectedModel viewModel,
  context,
  int index,
  ProductData? productData,
  JobListData? createJobList,
) {
  return Expanded(
    child: InkWell(
      onTap: () async {
        if (index == 1) {
          await Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) =>
                  CreateJoblistView()));
          viewModel.getDropDownList();

          WidgetsBinding.instance
              .addPostFrameCallback((_) => viewModel.notifyListeners());
        } else if (index == 2) {
          viewModel.getDropDownList();

          viewModel.getJobList(viewModel.dropDownTrade, productData!,
              viewModel.createJobList, context);

          viewModel.notifyListeners();
        }
      },
      child: Container(
        height: 50.h,
        // width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 32,
                  offset: Offset(1, 3),
                  color: Color.fromRGBO(222, 179, 175, 0.72))
            ]),
        child: Text(
          title,
          style: TextStyle(
              fontFamily: 'Raleway-SemiBold',
              fontSize: Globlas.deviceType == "phone" ? 14 : 24,
              letterSpacing: 0.2,
              color: textColor,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}
