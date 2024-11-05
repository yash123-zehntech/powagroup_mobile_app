// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
// import 'package:powagroup/helper_widget/add_cart_widget.dart';
// import 'package:powagroup/helper_widget/appbar_widget.dart';
// import 'package:powagroup/helper_widget/button_widget.dart';
// import 'package:powagroup/ui/screen/modules/favorite_module/confirmation_module/confirmation_view_model.dart';
// import 'package:powagroup/ui/screen/modules/favorite_module/job_product_item_module/job_product_item_view_model.dart';
// import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
// import 'package:powagroup/util/globleData.dart';
// import 'package:powagroup/util/util.dart';
// import 'package:stacked/stacked.dart';

// class ConfirmationView extends StatelessWidget {
//   ProductData? searchList;
//   String? title;
//   ConfirmationView({Key? key, this.title, this.searchList}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<ConfirmationViewModel>.reactive(
//       viewModelBuilder: () => ConfirmationViewModel(),
//       onViewModelReady: (viewModel) {},
//       builder: (context, viewModel, child) => Scaffold(
//           backgroundColor: const Color(0xffD8D8D9).withOpacity(0.72),
//           body: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               confirmationView(viewModel, title, context),
//             ],
//           )),
//     );
//   }

//   // Return Confirmation View
//   Widget confirmationView(ConfirmationViewModel viewModel, String? titleClick,
//       BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 30.h),
//       decoration: BoxDecoration(
//           color: const Color(0xffFFFFFF),
//           borderRadius: BorderRadius.circular(10.r)),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   PowaGroupIcon.cross,
//                   size: 24.h,
//                   color: const Color(0xff36393C),
//                 ),
//                 onPressed: () {
//                   //viewModel.navigationService.back();
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//           Image.asset('assets/icon/alert.png'),
//           const SizedBox(
//             height: 40,
//           ),
//           Text(
//             'Add to A Job Product List?',
//             style: TextStyle(
//                 fontFamily: 'Raleway',
//                 fontStyle: FontStyle.normal,
//                 letterSpacing: -0.33,
//                 fontSize: Globlas.deviceType == "phone" ? 20 : 30,
//                 fontWeight: FontWeight.w700,
//                 color: const Color(0xff1B1D1E)),
//           ),
//           SizedBox(
//             height: 40.h,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 30, right: 30),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               mainAxisSize: MainAxisSize.max,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 buttonWidget('Yes', const Color(0xffD60505),
//                     const Color(0xffFFFFFF), viewModel, titleClick, context),
//                 SizedBox(
//                   width: 20.w,
//                 ),
//                 buttonWidget('No', const Color(0xff858D93),
//                     const Color(0xffFFFFFF), viewModel, titleClick, context),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 40.h,
//           ),
//         ],
//       ),
//     );
//   }

//   // Return Button Widget
//   Widget buttonWidget(
//       String title,
//       Color color,
//       Color textColor,
//       ConfirmationViewModel viewModel,
//       String? titleClick,
//       BuildContext context) {
//     return Expanded(
//       child: InkWell(
//         onTap: () {
//           titleClick == "search"
//               ? viewModel.clickForJob(searchList != null ? searchList : null)
//               : title == 'Yes'
//                   ? viewModel.onYesButtonActionClick(context)
//                   : Navigator.pop(context);
//           //viewModel.navigationService.back();
//         },
//         child: Container(
//           height: 58.h,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: const [
//                 BoxShadow(
//                     blurRadius: 32,
//                     offset: Offset(1, 3),
//                     color: Color.fromRGBO(222, 179, 175, 0.72))
//               ]),
//           child: Text(
//             title,
//             style: TextStyle(
//                 fontFamily: 'Raleway',
//                 fontSize: Globlas.deviceType == "phone" ? 14 : 24,
//                 letterSpacing: 0.2,
//                 color: textColor,
//                 fontStyle: FontStyle.normal,
//                 fontWeight: FontWeight.w600),
//           ),
//         ),
//       ),
//     );
//   }
// }
