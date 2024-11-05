import 'package:hive/hive.dart';
import 'package:powagroup/ui/screen/modules/home_module/home_module/model/review_model.dart';

part 'customer_reviews_by_product.g.dart';

@HiveType(typeId: 18)
class CustomerReviewByProduct {
  @HiveField(0)
  int? productId;

  @HiveField(1)
  List<UserReview>? customerReviewDetails;

  CustomerReviewByProduct({
    this.productId,
    this.customerReviewDetails,
  });
}
