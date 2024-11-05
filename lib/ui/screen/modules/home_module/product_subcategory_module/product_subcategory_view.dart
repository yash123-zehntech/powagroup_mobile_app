import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/services/api_client.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_category_module/response_model/product_categories_response.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_module/product_subcategory_view_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:stacked/stacked.dart';

class ProductSubCategoryView extends StatelessWidget {
  Category? categoryObj;
  List<Category>? subCategoryList;
  ProductSubCategoryView(
      {Key? key, @required this.categoryObj, @required this.subCategoryList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductSubCategoryViewModel>.reactive(
      viewModelBuilder: () => ProductSubCategoryViewModel(),
      onViewModelReady: (viewModel) {
        // if (categoryObj != null && categoryObj!.parentPath != null) {
        //   viewModel.getProductSubCategories(categoryObj!.parentPath);
        // }
      },
      builder: (context, viewModel, child) => Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarWidget(
              title: '',
              actionIcon: IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                padding: EdgeInsets.only(right: 20.h),
                icon: Icon(
                  PowaGroupIcon.search_icon,
                  size: 24.h,
                  color: const Color(0xff36393C),
                ),
                onPressed: () {
                  viewModel.onSearchIconClick(context);
                },
              ),
              backIcon: IconButton(
                padding: const EdgeInsets.only(left: 5),
                icon: Icon(
                  PowaGroupIcon.back,
                  size: 24.h,
                  color: const Color(0xff36393C),
                ),
                onPressed: () {
                  //viewModel.navigationService.back();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          backgroundColor: const Color(0xffEFF1F2),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              logoWidget(),
              SizedBox(height: 10.h),
              productCategoriesList(viewModel),
            ],
          )

          // Stack(
          //   children: [
          //     logoWidget(),
          //     Container(
          //         padding: EdgeInsets.only(
          //             top: MediaQuery.of(context).size.height * 0.08),
          //         child: productCategoriesList(viewModel)),
          //   ],
          // )
          ),
    );
  }

  // Return Product Categories List
  Widget productCategoriesList(ProductSubCategoryViewModel viewModel) {
    return Expanded(
      child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 12, bottom: 16, right: 12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 185.h,
              crossAxisCount: 2,
              crossAxisSpacing: 12.h,
              mainAxisSpacing: 12.h),
          itemCount: subCategoryList!.length,
          itemBuilder: (BuildContext context, int index) {
            return productCategoryItem(viewModel, index, context);
          }),
    );
  }

  // Return Product Category Item by index
  Widget productCategoryItem(
      ProductSubCategoryViewModel viewModel, int index, BuildContext context) {
    return InkWell(
      onTap: () {
        // viewModel.onProductSubCategoryItemClick(
        //     subCategoryList![index], context);

        viewModel.onProductSubCategoryItemClick(
            subCategoryList![index], context);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl:
                    ApiClient.BASE_URL + subCategoryList![index].imageUrl!,
                fit: BoxFit.cover,
                width: 155.h,
                height: 100.h,
                errorWidget: ((context, url, error) {
                  return Image.asset(
                    'assets/icon/dummy.png',
                    width: 155.h,
                    height: 100.h,
                    fit: BoxFit.cover,
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Text(
                subCategoryList![index].name!.isNotEmpty
                    ? subCategoryList![index].name!
                    : '',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Raleway',
                    //fontSize: 13.0.sp,
                    fontSize: Globlas.deviceType == "phone" ? 13 : 23,
                    letterSpacing: -0.33,
                    color: const Color(0xff1B1D1E)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Return top logo widget
  Widget logoWidget() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 5),
                  child: Text(
                    categoryObj!.name != null && categoryObj!.name!.isNotEmpty
                        ? categoryObj!.name!
                        : '',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.33,
                        fontSize: Globlas.deviceType == "phone" ? 20 : 30,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xff1B1D1E)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
