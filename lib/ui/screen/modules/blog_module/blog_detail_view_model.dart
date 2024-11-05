import 'package:powagroup/app/locator.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/blog_detail.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'responseModel/blogdetails_id.dart';

class BlogDetailViewModel extends BaseViewModel {
  Api apiCall = locator<Api>();
  BlogDetailByIndex? blogDetailModel;
  final navigationService = locator<NavigationService>();
  int _itemCount = 0;
  bool _isCalling = false;
  bool _isAlreadyCalled = false;
  bool _isLocalDBAlreadyCalled = false;
  bool _isAPIError = false;
  int get itemCount => _itemCount;
  set itemCount(int itemCount) {
    _itemCount = itemCount;
    notifyListeners();
  }

  bool get isCalling => _isCalling;
  set isCalling(bool isCalling) {
    _isCalling = isCalling;
    notifyListeners();
  }

  bool get isAlreadyCalled => _isAlreadyCalled;

  set isAlreadyCalled(bool isAlreadyCalled) {
    _isAlreadyCalled = isAlreadyCalled;

    try {
      Future.delayed(const Duration(seconds: 4), () {
        notifyListeners();
      });
    } catch (error) {}
  }

  BlogPostData? _productDetails = BlogPostData();

  BlogPostData get productDetails => _productDetails!;

  set productDetails(BlogPostData productDetails) {
    _productDetails = productDetails;
    notifyListeners();
  }

  bool get isAPIError => _isAPIError;
  set isAPIError(bool isAPIError) {
    _isAPIError = isAPIError;
    notifyListeners();
  }

  getBlogDetailPageItems(var blogId) async {
    blogDetailModel = await apiCall.getBlogDetailPage(blogId);

    switch (blogDetailModel!.statusCode) {
      case Constants.sucessCode:
        _productDetails = blogDetailModel!.blogPost;

        break;
      case Constants.wrongError:
        isAPIError = true;
        AppUtil.showDialogbox(
            AppUtil.getContext(), 'Oops Something went wrong');

        break;
      case Constants.networkErroCode:
        isAPIError = true;
        AppUtil.showDialogbox(
            AppUtil.getContext(), 'Oops Something went wrong');
        break;
      default:
        break;
    }
    setBusy(false);
  }
}
