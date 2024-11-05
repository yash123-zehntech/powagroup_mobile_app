import 'package:hive/hive.dart';
import 'package:powagroup/services/irepository.dart';
import 'package:powagroup/ui/screen/modules/sales_order_detail_module/response_model.dart/sales_details_model.dart';

class HiveDbServices<T> extends IRepository<T> {
  Box<T>? box;
  String tableName;

  HiveDbServices(this.tableName);

  openBox(String tableName) async {
    box = await Hive.openBox<T>(tableName);
  }

  @override
  Future<void> addData(T object) async {
    if (boxIsClosed) {
      await openBox(tableName);
    }
    box!.add(object);
  }

  @override
  Future<void> putListData(dynamic object) async {
    if (boxIsClosed) {
      await openBox(tableName);
    }
    box!.addAll(object);
  }

  @override
  Future<List<T>> getData() async {
    if (boxIsClosed) {
      await openBox(tableName);
    }
    final list = box!.values.toList();
    return list;
  }

  @override
  Future<void> clear() async {
    if (boxIsClosed) {
      await openBox(tableName);
    }
    await box!.deleteAll(box!.keys);
  }

  @override
  Future<void> close() async {
    await box!.close();
  }

  Future<void> putAt(int index, T object) async {
    if (boxIsClosed) {
      await openBox(tableName);
    }
    box!.putAt(index, object);
  }

  Future<void> deleteAt(
    int index,
  ) async {
    if (boxIsClosed) {
      await openBox(tableName);
    }
    box!.deleteAt(
      index,
    );
  }

  bool get boxIsClosed => !(box != null && box!.isOpen);

  @override
  Future<void> putData(key, object) async {
    if (boxIsClosed) {
      await openBox(tableName);
    }
    box!.put(tableName, object);
  }

  @override
  Future<T?> get() async {
    if (boxIsClosed) {
      await openBox(tableName);
    }
    T? object = box!.get(tableName);
    if (object != null) {
      return object;
    } else {
      return null;
    }
  }
}
