import 'package:hive/hive.dart';


import '../../home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
part 'cartItemList.g.dart';

@HiveType(typeId: 52)
class CartItemList {
  @HiveField(0)
  int userId;

  @HiveField(1)
  List<ProductData> data;

  CartItemList(this.userId, this.data);
}
