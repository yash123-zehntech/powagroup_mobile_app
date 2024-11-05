import 'package:hive/hive.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/quotation_review_model.dart';
part 'customer_reviews_by_product_for_quote.g.dart';

@HiveType(typeId: 37)
class CustomerReviewByProductForQuote {
  @HiveField(0)
  int? productId;

  @HiveField(1)
  List<Message>? customerReviewDetailsForQuote;

  CustomerReviewByProductForQuote({
    this.productId,
    this.customerReviewDetailsForQuote,
  });
}
