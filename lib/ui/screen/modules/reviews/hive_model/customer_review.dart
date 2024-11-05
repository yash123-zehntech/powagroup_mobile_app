import 'package:hive/hive.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/review_model.dart';

part 'customer_review.g.dart';

@HiveType(typeId: 19)
class CustomerReviewOfProduct {
  @HiveField(0)
  int? productId;

  @HiveField(1)
  List<UserReview>? customerReviewDetails;

  CustomerReviewOfProduct({
    this.productId,
    this.customerReviewDetails,
  });
}
