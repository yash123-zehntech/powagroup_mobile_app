import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/stepper_cart_widget.dart';
import 'package:powagroup/services/globals.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/cart_module/cart_view_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';

class CartView extends StatefulWidget {
  int index = 0;
  String? value = "Review Order";

  CartView({Key? key, this.value, required this.index}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  bool confirm = false;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CartViewModel>.reactive(
        viewModelBuilder: () => CartViewModel(),
        onViewModelReady: (viewModel) async {
          widget.index ?? 0;
          viewModel.checkDeliveryList.clear();
          viewModel.checkInvoiceList.clear();
          viewModel.index = widget.index;
          viewModel.checkCardboardList = await AppUtil.getCartList();
          viewModel.checkDeliveryList = await AppUtil.getDeliveryList();
          viewModel.checkInvoiceList = await AppUtil.getInvoiceList();
          viewModel.checkContactList = await AppUtil.getContactList();

          viewModel.extraInfo = await AppUtil.getSavedExtraInformation();
        },
        builder: (context, viewModel, child) => Scaffold(
            backgroundColor: const Color(0xffEFF1F2),
            body: Scaffold(
              appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(Globlas.deviceType == "phone" ? 36 : 56),
                child: viewModel.index == 0
                    ? const AppBarWidget()
                    : AppBarWidget(
                        title: viewModel.index == 3
                            ? 'Confirm Order'
                            : viewModel.index == 2
                                ? 'Extra Info'
                                : viewModel.index == 1
                                    ? 'Delivery Address'
                                    : '',
                        backIcon: IconButton(
                          padding: const EdgeInsets.only(left: 5),
                          icon: Icon(
                            PowaGroupIcon.arrow_back,
                            size: 24.h,
                            color: const Color(0xff36393C),
                          ),
                          onPressed: () {
                            viewModel.index == 3
                                ? PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: CartView(
                                      index: 2,
                                    ))
                                : viewModel.index == 2
                                    ? PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: CartView(
                                          index: 1,
                                        ))
                                    : PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: CartView(
                                          index: 0,
                                        ));
                          },
                        )),
              ),
              body: Column(
                children: [
                  StepperClass(
                    viewModel: viewModel,
                    value: viewModel.index == 3
                        ? Globals.cartBoardList[3]
                        : viewModel.index == 2
                            ? Globals.cartBoardList[2]
                            : viewModel.index == 1
                                ? Globals.cartBoardList[1]
                                : viewModel.index == 0
                                    ? Globals.cartBoardList[0]
                                    : Globals.cartBoardList[0],
                    selectedTapString: Globals.cartBoardList[0],
                    changeOnTap: (value) async {
                      viewModel.checkDeliveryList.clear();
                      viewModel.checkInvoiceList.clear();
                      viewModel.checkCardboardList =
                          await AppUtil.getCartList();
                      viewModel.checkDeliveryList =
                          await AppUtil.getDeliveryList();
                      viewModel.checkInvoiceList =
                          await AppUtil.getInvoiceList();
                      viewModel.checkContactList =
                          await AppUtil.getContactList();
                      ;
                      viewModel.extraInfo =
                          await AppUtil.getSavedExtraInformation();

                      ;

                      viewModel.checkCardboardList.isEmpty
                          ? viewModel.index = 0
                          : viewModel.checkDeliveryList
                                      .any((element) => element.selected!) &&
                                  viewModel.checkInvoiceList.any(
                                      (element) => element.selectedForBilling!)
                              ? !viewModel.extraInfo
                                  ? viewModel.index = value!
                                  : value == 0
                                      ? viewModel.index = 0
                                      : value == 1
                                          ? viewModel.index = 1
                                          : viewModel.index = 2
                              : value == 0
                                  ? viewModel.index = 0
                                  : viewModel.index = 1;
                      if (viewModel.checkCardboardList.isNotEmpty &&
                          (viewModel.checkDeliveryList.isNotEmpty &&
                              viewModel.checkInvoiceList.isNotEmpty) &&
                          value == 2) {
                        Future.delayed(const Duration(seconds: 5));
                        if (viewModel.isPickup == "0") {
                          if (viewModel.checkDeliveryList
                                  .any((element) => element.selected == true) &&
                              viewModel.checkInvoiceList.any((element) =>
                                  element.selectedForBilling == true)) {
                          } else {
                            AppUtil.showSnackBar(
                                'Please select Shipping address');
                          }
                        }
                      }

                      viewModel.notifyListeners();
                    },
                  ),
                  Expanded(
                      child: Container(
                    width: double.infinity,
                    child: viewModel.getBody(
                      viewModel.index,
                      viewModel.cartProductList,
                    ),
                  ))
                ],
              ),
            )));
  }
}
