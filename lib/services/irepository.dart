abstract class IRepository<T> {
  Future<List<T>>? getData();

  Future<T?> get();

  Future<void> addData(T object);

  Future<void> putListData(dynamic object);

  Future<void> close();

  Future<void> clear();

  Future<void> putData(key, dynamic object);
}
