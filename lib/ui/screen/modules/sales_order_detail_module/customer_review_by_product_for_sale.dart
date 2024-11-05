import 'package:hive/hive.dart';
import 'package:powagroup/ui/screen/modules/quotation_detail_module/quotation_review_model.dart';
part 'customer_review_by_product_for_sale.g.dart';

@HiveType(typeId: 39)
class CustomerReviewByProductForSale {
  @HiveField(0)
  int? productId;

  @HiveField(1)
  List<Message>? customerReviewDetailsForSale;

  CustomerReviewByProductForSale({
    this.productId,
    this.customerReviewDetailsForSale,
  });
}
