import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/services/api_client.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_category_module/product_category_view_model.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import '../../../../../helper_widget/shimmer_loading.dart';

class ProductCategoryView extends StatelessWidget {
  const ProductCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductCategoryViewModel>.reactive(
      viewModelBuilder: () => ProductCategoryViewModel(),
      onViewModelReady: (viewModel) {
        viewModel.getCategories();
      },
      builder: (context, viewModel, child) => Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: AppBarWidget(
              backIcon: null,
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
            ),
          ),
          backgroundColor: const Color(0xffEFF1F2),
          body: Stack(
            children: [
              logoWidget(),
              SizedBox(
                height: 50.h,
              ),
              Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.07),
                  child: productCategoriesList(viewModel)),
            ],
          )),
    );
  }

  // Return Product Categories List
  Widget productCategoriesList(ProductCategoryViewModel viewModel) {
    return GridView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          left: 12,
          bottom: 16,
          right: 12,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 170.h,
            crossAxisCount: 2,
            crossAxisSpacing: 12.h,
            mainAxisSpacing: 12.h),
        itemCount: viewModel.isBusy ? 10 : viewModel.categoriesList.length,
        itemBuilder: (BuildContext context, int index) {
          return viewModel.isBusy
              ? ShimmerLoading(
                  isLoading: true,
                  child: Container(
                    margin: const EdgeInsets.only(right: 4),
                    width: AppUtil.getDeviceWidth() * 0.8,
                    height: 140.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[100],
                    ),
                  ))
              : productCategoryItem(viewModel, index, context);
        });
  }

  // Return Product Category Item by index
  Widget productCategoryItem(
      ProductCategoryViewModel viewModel, int index, BuildContext context) {
    return InkWell(
      onTap: () {
        viewModel.onProductCategoryItemClick(
            viewModel.categoriesList[index], index, context);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
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
                imageUrl: ApiClient.BASE_URL +
                    viewModel.categoriesList[index].imageUrl!,
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
            SizedBox(
              height: 20.h,
            ),
            Expanded(
              child: Text(
                viewModel.categoriesList[index].name!.isNotEmpty
                    ? viewModel.categoriesList[index].name!
                    : '',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Raleway',
                    //fontSize: 13.0.sp,
                    fontSize: Globlas.deviceType == "phone" ? 12 : 22,
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
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                ),
                child: Text(
                  'Product Categories',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.33,
                      fontSize: Globlas.deviceType == 'phone' ? 20 : 30,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xff1B1D1E)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
