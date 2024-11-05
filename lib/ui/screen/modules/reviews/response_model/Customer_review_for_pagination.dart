import 'package:hive/hive.dart';

import '../../home_module/home_module/model/review_model.dart';
part 'Customer_review_for_pagination.g.dart';

@HiveType(typeId: 22)
class CustomerReviewForPagination {
  @HiveField(0)
  int? productId;

  @HiveField(1)
  List<UserReview>? customerReviewDetails;

  CustomerReviewForPagination({
    this.productId,
    this.customerReviewDetails,
  });
}
