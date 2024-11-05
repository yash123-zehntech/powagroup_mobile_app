import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import '../ui/screen/modules/favorite_module/create_jobList_dropdown model/response_model/joblist_hive_model.dart';

Widget dropDownforJob(
    BuildContext context, viewModel, type, list, JobListData jobListData) {
  return Column(
    children: [
      DropdownButtonHideUnderline(
        child: DropdownButton<JobListData>(
          onTap: () {
            viewModel.dropDownTrade == " Select"
                ? AppUtil.showDialogbox(context,
                    "Currently There is no JobListData Found Please Create a new one")
                : '';
            viewModel.notifyListeners();
          },
          hint: viewModel.dropDownTrade == null
              ? const Padding(
                  padding: EdgeInsets.only(left: 10),
                )
              : Text(
                  viewModel.dropDownTrade,
                  style: TextStyle(
                      color: const Color(0xff858D93),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Raleway',
                      fontSize: Globlas.deviceType == 'phone' ? 15 : 25),
                ),
          isExpanded: true,
          iconSize: 30.h,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontFamily: 'Raleway',
              fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
          items: viewModel.trade.map<DropdownMenuItem<JobListData>>((val) {
            return DropdownMenuItem<JobListData>(
              value: val,
              child: Text(
                val.jobName.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Raleway',
                    fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
              ),
            );
          }).toList(),
          onChanged: (val) {
            viewModel.dropDownTrade = val!.jobName.toString();

            if (viewModel.dropDownTrade == '  Select') {
              AppUtil.showDialogbox(context,
                  "Currently  There is no JobListData Found Please Create a new one");
              viewModel.notifyListeners();
            } else {
              viewModel.createJobList = JobListData(
                id: val.id.toString(),
                jobName: val.jobName.toString(),
                jobDate: val.jobDate.toString(),
                description: val.description.toString(),
                productsList: [],
              );

              viewModel.notifyListeners();
            }
          },
        ),
      ),
      Container(
        height: 1.h,
        width: double.infinity,
        color: Colors.grey,
      ),
      const SizedBox(
        height: 10,
      )
    ],
  );
}
