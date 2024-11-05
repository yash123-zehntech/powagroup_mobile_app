// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartItemList.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemListAdapter extends TypeAdapter<CartItemList> {
  @override
  final int typeId = 52;

  @override
  CartItemList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemList(
      fields[0] as int,
      (fields[1] as List).cast<ProductData>(),
    );
  }

  @override
  void write(BinaryWriter writer, CartItemList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
