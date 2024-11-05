// Return Comment Section Widget
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/delivery_view_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_subcategory_response.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';

Widget commentSectionQuantity(List<QtyBreak>? qtyBreaks, sale_uom, viewModel,
    title, screenName, BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sale_uom == null ? "" : "per $sale_uom",
          style: TextStyle(
              fontFamily: 'Inter-Medium',
              fontSize: Globlas.deviceType == "phone" ? 14 : 24,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.33,
              color: const Color(0xff000000)),
        ),
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              title == 'Checkout' || title == 'Add To Truck'
                  ? Container(
                      height: 36.h,
                      width: 120.w,
                      padding: const EdgeInsets.only(left: 8, right: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          width: 0.4,
                          color: const Color(0xff858D93).withOpacity(0.5),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Qty : ',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize:
                                    Globlas.deviceType == "phone" ? 14 : 24,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.33,
                                color: const Color(0xff858D93),
                              )),
                          Container(
                            height: 30.h,
                            width: 48.w,
                            child: Center(
                              child: TextFormField(
                                cursorColor: Colors.black,
                                onChanged: (value) {
                                  viewModel.productDetails.yashValue = value;

                                  viewModel.debouncer.run(() {
                                    viewModel.updateControllerValue(
                                        viewModel.productDetails.yashValue,
                                        AppUtil.getQtyPriceByMultiply(
                                            viewModel.productDetails.yashValue!,
                                            viewModel
                                                .productDetails.qtyBreaks!));

                                    viewModel.notifyListeners();
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                  });
                                },
                                onTap: () {
                                  if (viewModel.productDetails != null &&
                                      viewModel.productDetails.yashValue !=
                                          null &&
                                      viewModel.productDetails.yashValue!
                                          .isNotEmpty) {
                                    viewModel.qtyValueController.clear();
                                  }
                                  viewModel.notifyListeners();
                                },
                                controller: viewModel.qtyValueController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        Globlas.deviceType == "phone" ? 18 : 28,
                                    color: const Color(0xff36393C),
                                    letterSpacing: -0.33),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            constraints: const BoxConstraints.expand(
                                height: 20, width: 20),
                            child: PopupMenuButton<QtyBreak>(
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(0),
                              tooltip: " ",
                              iconSize: 20,
                              icon: const Icon(Icons.arrow_drop_down),
                              splashRadius: 12,
                              itemBuilder: (BuildContext context) {
                                return qtyBreaks!.map((QtyBreak choice) {
                                  return PopupMenuItem<QtyBreak>(
                                    onTap: () {
                                      viewModel.updateControllerValue(
                                        choice.qty!.replaceAll(".0", ""),
                                        choice.price,
                                      );
                                      if (choice.qty!.contains(".0")) {
                                        choice.qty =
                                            choice.qty!.replaceAll(".0", "");
                                      }
                                      viewModel.qtyValueController.text =
                                          choice.qty;
                                      viewModel.notifyListeners();
                                    },
                                    value: choice,
                                    child: Container(
                                        width: 20.w,
                                        child: Text(AppUtil.getQTYValueForMenu(
                                            choice.qty.toString()))),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : priceColumnWidget('Total Amount', '\$152.00', viewModel),
              ButtonWidget(
                isBusy: false,
                buttonTitle: title,
                containerWidth: 130.w,
                containerHeigth: 48.h,
                productDetailsData: viewModel.productDetails,
                viewModel: viewModel,
              ),
            ],
          ),
          onTap: () {
            title == 'Next' && screenName == 'ReviewPage'
                ? viewModel.onNextButtonClick()
                : title == 'Next' && screenName == 'DeliveryPage'
                    ? viewModel.onNextButtonClick()
                    : title == 'Next' && screenName == 'ExtraInfoView'
                        ? viewModel.onNextButtonClick()
                        : title == 'Checkout' || title == 'Add To Truck'
                            ? viewModel.onCheckoutButtonClick(viewModel)
                            : Container();
          },
        ),
      ],
    ),
  );
}

Widget priceColumnWidget(String name, String price, DeliveryModel viewModel) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Text(
          name,
          style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: Globlas.deviceType == "phone" ? 14 : 24,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.33,
              color: const Color(0xff000000)),
        ),
      ),
      const SizedBox(
        height: 6,
      ),
      Padding(
        padding: const EdgeInsets.only(right: 25),
        child: viewModel.showLoaderForOrderTotal != null &&
                viewModel.showLoaderForOrderTotal
            ? ShimmerLoading(
                isLoading: true,
                child: Container(
                  width: 70,
                  height: 15,
                  decoration: BoxDecoration(
                      color: Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(6)),
                ))
            : Text(
                price,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: name == "Total Pay"
                        ? Globlas.deviceType == "phone"
                            ? 18
                            : 28
                        : Globlas.deviceType == "phone"
                            ? 14
                            : 24,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.33,
                    color: const Color(0xff000000)),
              ),
      )
    ],
  );
}
