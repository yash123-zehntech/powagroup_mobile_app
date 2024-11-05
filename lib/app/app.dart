import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/ui/screen/modules/address_module/address_view.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/cart_module/cart_view.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/confirm_order_module/confirm_order_view.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/delivery_view.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/extra_info_module/extra_info_view.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/review_module/review_view.dart';
import 'package:powagroup/ui/screen/modules/blog_module/blog_detail_view.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/all_product_module/favorite_view.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/confirmation_module/confirmation_view.dart';
import 'package:powagroup/ui/screen/modules/favorite_module/job_product_item_module/job_product_item_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/home_page_data_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_page_module/home_page_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_category_module/product_category_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/product_subcategory_item_view.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_module/product_subcategory_view.dart';
import 'package:powagroup/ui/screen/modules/prefrence_module/communication_references_module/communication_view.dart';
import 'package:powagroup/ui/screen/modules/prefrence_module/help_contect_module/help_contect_view.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/product_detail_view.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/quotation_detial_view.dart';
import 'package:powagroup/ui/screen/modules/quotation_module/quotation_view.dart';
import 'package:powagroup/ui/screen/modules/quotation_review/quotation_review.dart';
import 'package:powagroup/ui/screen/modules/return_module/return_view.dart';
import 'package:powagroup/ui/screen/modules/reviews/review_view.dart';
import 'package:powagroup/ui/screen/modules/rewards_module/rewards_view.dart';
import 'package:powagroup/ui/screen/modules/sales_order_detail_module/sales_order_detail_view.dart';
import 'package:powagroup/ui/screen/modules/sales_order_module/sales_order_view.dart';
import 'package:powagroup/ui/screen/modules/search_module/search_view.dart';
import 'package:powagroup/ui/screen/modules/splash_module/splash/splash_view.dart';
import 'package:powagroup/ui/screen/modules/successfull_module/success_view.dart';
import 'package:powagroup/ui/screen/modules/user_module/delete_user_account/delete_user_account_view.dart';
import 'package:powagroup/ui/screen/modules/user_module/forgot_password/forgot_password_view.dart';
import 'package:powagroup/ui/screen/modules/user_module/login/login_view.dart';
import 'package:powagroup/ui/screen/modules/user_module/profile/profile_view.dart';
import 'package:powagroup/ui/screen/modules/user_module/register/register_view.dart';
import 'package:powagroup/ui/screen/modules/user_module/submit_request/submit_request_view.dart';
import 'package:stacked/stacked_annotations.dart';

import '../ui/screen/modules/favorite_module/create_jobList_dropdown model/create_job_list_selected.dart';

@StackedApp(routes: [
  StackedRoute(page: SplashView, initial: true),
  StackedRoute(page: LoginView),
  StackedRoute(page: ProductCategoryView),
  StackedRoute(page: ProductSubCategoryView),
  StackedRoute(page: ProductSubCategoryItemView),
  StackedRoute(page: ProfileView),
  StackedRoute(page: CommunicationRefrencesView),
  StackedRoute(page: HelpContectView),
  StackedRoute(page: HomePageView),
  StackedRoute(page: FavoriteView),
  StackedRoute(page: JobProductItemView),
  //StackedRoute(page: ConfirmationView),
  StackedRoute(page: ProductDetialView),
  StackedRoute(page: SalesOrderView),
  StackedRoute(page: SalesOrderDetialView),
  StackedRoute(page: QuotationView),
  StackedRoute(page: QuotationDetialView),
  StackedRoute(page: HomePageDataView),
  StackedRoute(page: RegisterView),
  StackedRoute(page: SubmitRegisterView),
  StackedRoute(page: ForgotPasswordView),
  StackedRoute(page: SuccessView),
  StackedRoute(page: SearchView),
  StackedRoute(page: RewardsView),
  StackedRoute(page: ReturnView),
  StackedRoute(page: AddressView),
  StackedRoute(page: DeliveryPage),
  StackedRoute(page: CartView),
  StackedRoute(page: ExtraInfoView),
  StackedRoute(page: ReviewPage),
  StackedRoute(page: ConfirmOrderPage),
  StackedRoute(page: CreateJoblistSelected),
  StackedRoute(page: BlogDetailView),
  StackedRoute(page: CustomerReviewView),
  StackedRoute(page: CustomerReviewViewForQuotation),
  StackedRoute(page: DeleteAccountView),
])
class App {
  /** This class has no puporse besides housing the annotation that generates the required functionality **/
}
