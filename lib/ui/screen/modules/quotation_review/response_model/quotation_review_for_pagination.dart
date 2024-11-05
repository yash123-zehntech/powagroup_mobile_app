import 'package:hive/hive.dart';

import '../../quotation_detail_module/quotation_review_model.dart';
part 'quotation_review_for_pagination.g.dart';

@HiveType(typeId: 38)
class QuotationPageReviewForPagination {
  @HiveField(0)
  int? productId;

  @HiveField(1)
  List<Message>? customerReviewDetailsForQuoteList;

  QuotationPageReviewForPagination({
    this.productId,
    this.customerReviewDetailsForQuoteList,
  });
}
