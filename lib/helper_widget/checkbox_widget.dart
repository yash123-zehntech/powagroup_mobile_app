import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget checkbox(
  viewModel,
) =>
    ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(12),
                  child: InkWell(
                    onTap: () {
                      viewModel.CheckboxListItem[index].isSelect =
                          !viewModel.CheckboxListItem[index].isSelect!;
                      if (viewModel.CheckboxListItem[0].isSelect == true &&
                          viewModel.CheckboxListItem[1].isSelect == true &&
                          viewModel.CheckboxListItem[2].isSelect == true) {
                        viewModel.allcheck = true;
                        viewModel.notifyListeners();
                       
                      } else {
                        viewModel.allcheck = false;
                        viewModel.notifyListeners();
                      }
                      viewModel.notifyListeners();
                    },
                    child: Container(
                      height: 20.h,
                      width: 20.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: viewModel.CheckboxListItem[index].isSelect!
                              ? const Color(0xFFD60505)
                              : const Color(0xff858D93),
                          width: 1,
                        ),
                        color: viewModel.CheckboxListItem[index].isSelect!
                            ? const Color(0xFFD60505)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Icon(Icons.check, color: Colors.white, size: 16.h),
                    ),
                  )),
              Expanded(
                child: Text(
                  '${viewModel.CheckboxListItem[index].title}',
                  style: TextStyle(fontSize: 13.0.h),
                ),
              ),
            ], //<Widget>[]
          );
        });
