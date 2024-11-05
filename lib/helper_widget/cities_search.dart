import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/helper_widget/debouncer.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/ui/screen/modules/address_module/address_view_model.dart';
import 'package:powagroup/ui/screen/modules/address_module/response_model/cities_respose.dart';
import 'package:powagroup/util/globleData.dart';

Widget citiesSearch(
  List<CitiesData>? citiesList,
  AddressViewMode viewModel,
) {
  return Container(
    // padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Search by city or Postcode",
            style: TextStyle(
                color: const Color(0xff36393C),
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
                fontSize: Globlas.deviceType == 'phone' ? 15 : 25)),
        SizedBox(
          height: 15.h,
        ),
        InkWell(
          child: Container(
            height: 40.h,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                width: 0.4,
                color: const Color(0xff858D93).withOpacity(0.5),
                style: BorderStyle.solid,
              ), // inner circle color
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    // height: 30.h,
                    // width: 180.w,
                    child: Center(
                      child: TextFormField(
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          viewModel.isChangedEditField = true;
                          if (value.isNotEmpty) {
                            viewModel.onCitiesItemChanged();
                          } else {
                            // viewModel.noDataFound = false;
                            // viewModel.searchTap = false;
                            // viewModel.clearList();
                          }
                        },
                        onTap: () {},
                        controller: viewModel.streetNameNumberController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: const Color(0xff36393C),
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w500,
                            fontSize: Globlas.deviceType == 'phone' ? 15 : 25),
                        decoration: InputDecoration(
                            hintText: "Search",
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            border: InputBorder.none,
                            suffixIcon: InkWell(
                              onTap: () {
                                viewModel.isTapping = !viewModel.isTapping;
                              },
                              child: Icon(
                                Icons.arrow_drop_down,
                                size: 30,
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
                // Expanded(
                // )
                // PopupMenuButton<CitiesData>(
                //   // position: PopupMenuPosition.over,
                //   constraints: const BoxConstraints(),
                //   // padding: const EdgeInsets.only(bottom: 0, top: 0),
                //   padding: EdgeInsets.zero,
                //   tooltip: " ",
                //   iconSize: 30,

                //   icon: Icon(
                //     Icons.arrow_drop_down,
                //     // color: Color(0xff36393C),
                //   ),
                //   splashRadius: 12,
                //   itemBuilder: (BuildContext context) {
                //     return citiesList!.map((CitiesData choice) {
                //       return PopupMenuItem<CitiesData>(
                //           onTap: () {
                //             viewModel.streetNameNumberController.text =
                //                 choice.name!;

                //             viewModel.stateNameController.text =
                //                 choice.stateName!;
                //             viewModel.cityController.text = choice.city!;

                //             viewModel.cityValue = " ";
                //             viewModel.listOfState.clear();
                //             viewModel.listOfCity.clear();
                //             viewModel.listOfState.add(choice.stateName);
                //             viewModel.listOfCity.add(choice.city);

                //             viewModel.notifyListeners();
                //           },
                //           value: choice,
                //           child: Container(
                //               child: Text(
                //             choice.name.toString(),
                //           )));
                //     }).toList();
                //   },
                // ),
              ],
            ),
          ),
        ),
        // Expanded(
        //   child: ListView.builder(
        //     itemCount: citiesList!.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       CitiesData choice = citiesList[index];

        //       return ListTile(
        //         title: Text(choice.name.toString()),
        //         onTap: () {
        //           viewModel.streetNameNumberController.text = choice.name!;
        //           viewModel.stateNameController.text = choice.stateName!;
        //           viewModel.cityController.text = choice.city;

        //           viewModel.cityValue = " ";
        //           viewModel.listOfState.clear();
        //           viewModel.listOfCity.clear();
        //           viewModel.listOfState.add(choice.stateName);
        //           viewModel.listOfCity.add(choice.city);

        //           viewModel.notifyListeners();
        //         },
        //       );
        //     },
        //   ),
        // ),
      ],
    ),
  );
}
