import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/form_textfield.widget.dart';
import 'package:powagroup/helper_widget/labal_field_contant_widget.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_jobList_dropdown%20model/response_model/joblist_hive_model.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/create_job_list_module/create_job_list_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:powagroup/util/validator.dart';
import 'package:stacked/stacked.dart';
import '../../home_module/product_subcategory_item_module/response_model/product_hive_model.dart';

class CreateJoblistView extends StatefulWidget {
  ProductData? productData;
  JobListData? jobList;
  String? title;
  int? index;
  CreateJoblistView(
      {Key? key, this.title, this.jobList, this.index, this.productData})
      : super(key: key);

  @override
  State<CreateJoblistView> createState() => _CreateJoblistViewState();
}

class _CreateJoblistViewState extends State<CreateJoblistView> {
  @override
  DateTime date = DateTime.now();
  bool istap = false;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateJobListViewModel>.reactive(
      viewModelBuilder: () => CreateJobListViewModel(),
      onViewModelReady: (viewModel) {
        if (widget.index == 1) {
          viewModel.updateJobList(widget.jobList);
          viewModel.jobNameController.text = widget.jobList!.jobName.toString();
          viewModel.descriptionController.text =
              widget.jobList!.description.toString();
          viewModel.jobDateController.text = widget.jobList!.jobDate.toString();
        }
      },
      builder: (context, viewModel, child) => Scaffold(
          backgroundColor: const Color(0xffD8D8D9).withOpacity(0.72),
          body:
              // joblistView(context, viewModel, widget.productData),
              Column(
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
      context, CreateJobListViewModel viewModel, ProductData? productData) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Form(
        key: viewModel.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          height: MediaQuery.of(context).size.height / 2 + 120.h,
          alignment: Alignment.bottomCenter,
          // width: double.infinity,
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 25),
          decoration: BoxDecoration(
              color: const Color(0xffFFFFFF),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
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
                      // viewModel.navigationService.back();
                      Navigator.pop(context);
                      // viewModel.onCrossButtonClick();
                      // viewModel.navigationService.pushNamedAndRemoveUntil(
                      //     Routes.productSubCategoryItemView);
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Create A Job List',
                  style: TextStyle(
                      fontFamily: 'Raleway-Bold',
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.33,
                      fontSize: Globlas.deviceType == "phone" ? 20 : 30,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff1B1D1E)),
                ),
              ),
              Expanded(
                child: KeyboardVisibilityBuilder(
                  builder: (context, visible) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              // dynamicPadding
                              visible
                                  ? 250.h
                                  : AppUtil.displayHeight(context) * 0.00.h),
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,

                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Text("word---//"),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 30, right: 20),
                            child: Container(
                                child: formField(
                                    viewModel,
                                    'Job Name',
                                    context,
                                    'Job Name',
                                    PowaGroupIcon.space,
                                    TextInputType.name,
                                    viewModel.jobNameController,
                                    Validation.fieldEmpty,
                                    viewModel.isBusy,
                                    false)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: fieldContent("Description"),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          descriptionBox(viewModel),
                          SizedBox(
                            height: 15.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: fieldContent("Selected Date"),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Platform.isAndroid
                              ? dateContainer(viewModel, context)
                              : CupertinoButton(
                                  // Display a CupertinoDatePicker in date picker mode.
                                  onPressed: () => _showDialog(
                                    CupertinoDatePicker(
                                      initialDateTime: DateTime.now(),
                                      mode: CupertinoDatePickerMode.date,
                                      use24hFormat: true,
                                      onDateTimeChanged: (DateTime newDate) {
                                        String formattedDate =
                                            DateFormat('dd/MM/yyyy').format(
                                                newDate); // format date in required form here we use yyyy-MM-dd that means time is removed

                                        setState(() {
                                          date = newDate;
                                          istap = true;
                                          viewModel.jobDateController.text =
                                              formattedDate;
                                        });
                                        //formatted date output using intl package =>  2022-07-04
                                        //You can format date as per your need
                                      },
                                    ),
                                  ),

                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        // color: const Color(0xffD60505).withOpacity(0.11),
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                        border: Border.all(
                                            color: const Color(0xff858D93))),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            istap
                                                ? '${date.day}-${date.month}-${date.year}'
                                                : viewModel.jobDateController
                                                        .text.isNotEmpty
                                                    ? viewModel
                                                        .jobDateController.text
                                                        .toString()
                                                    : "date",
                                            style: TextStyle(
                                                fontFamily: 'Inter-Regular',
                                                fontSize: Globlas.deviceType ==
                                                        "phone"
                                                    ? 16
                                                    : 24,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: -0.33,
                                                color:
                                                    const Color(0xff858D93))),
                                        Icon(Icons.calendar_month),
                                      ],
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 30,
                              right: 30,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                buttonWidget(
                                    widget.index == 1 ? 'Update' : 'Create',
                                    const Color(0xffD60505),
                                    const Color(0xffFFFFFF),
                                    viewModel,
                                    productData,
                                    context),
                                // InkWell(
                                //   onTap: () {
                                //     viewModel.onSubmitButtonClick();
                                //   },
                                //   child: buttonWidget('Submit', const Color(0xffD60505),
                                //       const Color(0xffFFFFFF), viewModel),
                                //   // child: ButtonWidget(
                                //   //   buttonTitle: 'Submit',
                                //   //   containerWidth: double.infinity / 3,
                                //   //   containerHeigth: 58.h,
                                //   //   isBusy: viewModel.isBusy,
                                //   // ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonWidget(
    String title,
    Color color,
    Color textColor,
    CreateJobListViewModel viewModel,
    ProductData? productData,
    BuildContext context,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          if (viewModel.formKey.currentState!.validate()) {
            // ignore: avoid_single_cascade_in_expression_statements
            viewModel.formKey..currentState!.save();
            if (widget.index == 1) {
              viewModel.updateJobListAPi(widget.jobList, context);
            } else {
              viewModel.callCreateJobListApi(productData, context);
            }

            viewModel.notifyListeners();
          } else {}
        },
        child: Container(
          height: 58.h,
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

  Widget descriptionBox(CreateJobListViewModel viewModel) => Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          cursorColor: Color(0xffD60505),
          controller: viewModel.descriptionController,
          textAlignVertical: TextAlignVertical.top,
          maxLines: 4,
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  width: 1,
                  color: const Color(0xff858D93).withOpacity(0.5),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  width: 1,
                  color: const Color(0xff858D93).withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  width: 1,
                  color: const Color(0xff858D93).withOpacity(0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  width: 1,
                  color: const Color(0xff858D93).withOpacity(0.5),
                ),
              ),
              hintText: 'Description',
              hintStyle: TextStyle(
                  fontFamily: 'Inter-Regular',
                  fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.33,
                  color: const Color(0xff858D93))),
        ),
      );
}

Widget dateContainer(CreateJobListViewModel viewModel, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: TextField(
      cursorColor: Color(0xffD60505),
      controller: viewModel.jobDateController,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.calendar_month),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
          color: Color(0xFFD60505),
        )),
        // ... other InputDecoration properties
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                    brightness: Brightness.light,
                    onPrimary: Colors.white, // selected text color
                    onSurface: Colors.red, // default text color
                    primary: Colors.red // circle color
                    ),
                dialogBackgroundColor: Colors.white,
                // textButtonTheme: TextButtonThemeData(
                //     style: TextButton.styleFrom(
                //         textStyle: const TextStyle(
                //             color: Colors.amber,
                //             fontWeight: FontWeight.normal,
                //             fontSize: 12,
                //             fontFamily: 'Quicksand'),
                //         primary: Colors.amber, // color of button's letters
                //         backgroundColor: Colors.black54, // Background color
                //         shape: RoundedRectangleBorder(
                //             side: const BorderSide(
                //                 color: Colors.transparent,
                //                 width: 1,
                //                 style: BorderStyle.solid),
                //             borderRadius: BorderRadius.circular(50)))
                //             )
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
          viewModel.jobDateController.text = formattedDate;
        } else {}
      },
    ),
  );
}
