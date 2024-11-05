import 'package:flutter/material.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';

class ButtonWidget extends StatelessWidget {
  final String? buttonTitle;
  final double? containerWidth;
  final double? containerHeigth;
  final bool? isBusy;
  final ProductDetailsData? productDetailsData;
  final dynamic viewModel;

  const ButtonWidget(
      {Key? key,
      this.buttonTitle,
      this.containerWidth,
      this.containerHeigth,
      this.isBusy,
      this.productDetailsData,
      this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buttonTitle != 'Checkout' || buttonTitle != 'Add To Truck'
        ? Container(
            width: containerWidth,
            height: containerHeigth,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: const Color(0xffD60505),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 32,
                      offset: Offset(1, 3),
                      color: Color.fromRGBO(222, 179, 175, 0.72))
                ],
                borderRadius: BorderRadius.circular(10)),
            child: isBusy!
                ? AppUtil.showProgress(const Color(0xffFFFFFF))
                : Text(
                    buttonTitle!,
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                        color: const Color(0xffFFFFFF)),
                  ),
          )
        : InkWell(
            onTap: () async {
              try {
                String loginToken = await AppUtil.getLoginToken();
                int userId = await AppUtil.getUserId();

                if (loginToken != null && loginToken.isNotEmpty) {
                  AppUtil.onAddToTruckClick(
                      ProductData(
                        userId: userId,
                        description: productDetailsData!.description,
                        yashValue: productDetailsData!.yashValue,
                        extraImages: productDetailsData!.extraImages,
                        id: productDetailsData!.id,
                        isFav: productDetailsData!.isFav,
                        mainImageUrl: productDetailsData!.mainImageUrl,
                        name: productDetailsData!.name,
                        price: productDetailsData!.price.toString(),
                        priceByQty: productDetailsData!.priceByQty.toString(),
                        priceDelivery:
                            productDetailsData!.priceDelivery!.toDouble(),
                        priceTax: productDetailsData!.priceTax,
                        priceTotal: productDetailsData!.qtyBreaks!.isEmpty
                            ? productDetailsData!.priceTotal
                            : productDetailsData!.qtyBreaks![0].price,
                        priceUntaxed: productDetailsData!.priceUntaxed,
                        qtyBreaks: productDetailsData!.qtyBreaks,
                        saleUom: productDetailsData!.saleUom,
                        sku: productDetailsData!.sku,
                      ),
                      false,
                      viewModel);
                  viewModel.notifyListeners();
                } else {
                  AppUtil.showLoginMessageDialog(AppUtil.getContext(),
                      'Please Sign In/Register to purchase products');
                }
              } catch (e) {}

              //paymentProvider.makePayment(amount: '122', currency: 'usd');
            },
            child: Container(
              width: containerWidth,
              height: containerHeigth,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: const Color(0xffD60505),
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 32,
                        offset: Offset(1, 3),
                        color: Color.fromRGBO(222, 179, 175, 0.72))
                  ],
                  borderRadius: BorderRadius.circular(10)),
              child: isBusy!
                  ? AppUtil.showProgress(const Color(0xffFFFFFF))
                  : Text(
                      buttonTitle!,
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                          color: const Color(0xffFFFFFF)),
                    ),
            ),
          );
  }
}
