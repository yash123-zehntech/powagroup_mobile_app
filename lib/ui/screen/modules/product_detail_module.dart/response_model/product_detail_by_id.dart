import 'package:hive/hive.dart';
import 'package:powagroup/ui/screen/modules/product_detail_module.dart/response_model/product_detail_model.dart';
part 'product_detail_by_id.g.dart';

@HiveType(typeId: 9)
class ProductDetailById {
  @HiveField(0)
  int? subCategoryId;

  @HiveField(1)
  ProductDetailsData? productDetails;

  ProductDetailById({
    this.subCategoryId,
    this.productDetails,
  });
}
