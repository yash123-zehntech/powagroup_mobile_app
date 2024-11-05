import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/helper_widget/traingleshape.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/cart_module/cart_view_model.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/contact_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/invoice_info.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../services/globals.dart';
import '../ui/screen/modules/address_module/response_model/address_response.dart';
import '../util/util.dart';

class StepperClass extends StatefulWidget {
  List<AddressData>? addressList;
  int? selectedTapIndex = 0;
  String? selectedTapString = '';

  String? value;
  bool? extraInfo;
  CartViewModel? viewModel;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  Function(int? value)? changeOnTap;

  StepperClass(
      {Function(int? value)? changeOnTap,
      String? selectedTapString,
      int? selectedTapIndex,
      Key? key,
      this.backgroundColor,
      this.selectedItemColor,
      this.viewModel,
      this.extraInfo,
      this.unselectedItemColor,
      this.value})
      : super(key: key) {
    this.changeOnTap = changeOnTap ?? (int? value) {};
    this.selectedTapString = selectedTapString ?? '';
    this.selectedTapIndex = selectedTapIndex ?? 0;
  }

  @override
  State<StepperClass> createState() => _StepperClassState();
}

class _StepperClassState extends State<StepperClass> {
  @override
  void initState() {
    // getCartBoarLists();
    //widget.value!;
    super.initState();
  }

  var questionIndex = 0;
  final navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CartViewModel>.reactive(
        viewModelBuilder: () => CartViewModel(),
        onViewModelReady: (viewModel) async {
          viewModel.checkCardboardList = await AppUtil.getCartList();

          viewModel.checkDeliveryList.clear();
          viewModel.checkInvoiceList.clear();

          viewModel.checkDeliveryList = await AppUtil.getDeliveryList();
          viewModel.checkInvoiceList = await AppUtil.getInvoiceList();
          viewModel.checkContactList = await AppUtil.getContactList();
          viewModel.extraInfo = await AppUtil.getSavedExtraInformation();

          viewModel.checkCardboardList.isEmpty
              ? Globals.value = "Review Order"
              : Globals.value = widget.value!;
        },
        builder: (context, viewModel, child) => Container(
              height: 65.h,
              color: const Color(0xffEFF1F2),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
              width: double.infinity,
              child: getTextWidgetss(
                  Globals.cartBoardList,
                  context,
                  widget.selectedTapIndex!,
                  widget.changeOnTap!,
                  viewModel.checkCardboardList,
                  viewModel.checkDeliveryList,
                  viewModel.checkInvoiceList,
                  viewModel.checkContactList,
                  viewModel.extraInfo,
                  viewModel.shippingAddressList,
                  viewModel.billingAddressList),
            ));
  }

  Widget getTextWidgetss(
      List<String> cartBoardList,
      BuildContext context,
      int selectedTapIndex,
      Function(int? value) changeOnTap,
      List<ProductData> cartProductList,
      List<DeliveryInfo> deliveryListData,
      List<InvoiceInfo> invoiceListData,
      List<ContactInfo> contactListData,
      bool extraInfo,
      List<AddressData> shippingAddressList,
      List<AddressData> billingAddressList) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: cartBoardList.map((
          item,
        ) {
          int index = cartBoardList.indexOf(item);
          int lastIndex = cartBoardList.length - 1;
          return Expanded(
            child: InkWell(
              child: item != "Review Order"
                  ? Container(
                      height: 40.h,
                      child: CustomPaint(
                        painter: DrawClipper(
                            sized: Size(92.w, 40.h),
                            borderThickness:
                                item.contains(Globals.value) ? 1.5 : 2,
                            backgroundColor: item.contains(Globals.value)
                                ? Colors.transparent
                                : const Color(0xff33A3E4),
                            borderColor: item.contains(Globals.value)
                                ? const Color(0xffBDC2C6)
                                : const Color(0xff33A3E4)),
                        child: Center(
                          child: Text(
                            item,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontStyle: FontStyle.normal,
                                fontSize:
                                    Globlas.deviceType == "phone" ? 10 : 19,
                                letterSpacing: -0.33,
                                fontWeight: FontWeight.w600,
                                color: item.contains(Globals.value)
                                    ? const Color(0xff1B1D1E)
                                    : Colors.white
                                //Color(0xff1B1D1E)
                                ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 40.h,
                      child: CustomPaint(
                        painter: DrawArrowClipper(
                            sized: Size(92.w, 40.h),
                            backgroundColor: item.contains(Globals.value)
                                ? Colors.transparent
                                : const Color(0xff33A3E4),
                            //Colors.transparent
                            borderColor: item.contains(Globals.value)
                                ? const Color(0xffBDC2C6)
                                : const Color(0xff33A3E4),
                            borderThickness:
                                item.contains(Globals.value) ? 1.5 : 2),
                        child: Center(
                          child: Text(
                            item,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontStyle: FontStyle.normal,
                                fontSize:
                                    Globlas.deviceType == "phone" ? 10 : 19,
                                letterSpacing: -0.33,
                                fontWeight: FontWeight.w600,
                                color: item.contains(Globals.value)
                                    ? const Color(0xff1B1D1E)
                                    : Colors.white), //const Color(0xff1B1D1E)
                          ),
                        ),
                      ),
                    ),
              onTap: () async {
                deliveryListData.clear();
                invoiceListData.clear();
                cartProductList = await AppUtil.getCartList();
                deliveryListData = await AppUtil.getDeliveryList();
                invoiceListData = await AppUtil.getInvoiceList();
                contactListData = await AppUtil.getContactList();
                extraInfo = await AppUtil.getSavedExtraInformation();

                setState(() {
                  cartProductList.isEmpty
                      ? Globals.value = "Review Order"
                      : Globals.value =
                          // addressList.isNotEmpty &&
                          deliveryListData
                                      .any((element) => element.selected!) &&
                                  invoiceListData.any(
                                      (element) => element.selectedForBilling!)
                              ? Globals.value = !extraInfo
                                  ? item
                                  : item == "Review Order"
                                      ? "Review Order"
                                      : item == "Address"
                                          ? "Address"
                                          : "Extra Info"
                              : item == "Review Order"
                                  ? "Review Order"
                                  : "Address";
                  // Globals.value = item;

                  changeOnTap(index);
                });
              },
            ),
          );
        }).toList());
  }
}
