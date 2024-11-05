// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_selected_qty.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartSelectedValueAdapter extends TypeAdapter<CartSelectedValue> {
  @override
  final int typeId = 40;

  @override
  CartSelectedValue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartSelectedValue(
      productId: fields[0] as int?,
      qty: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CartSelectedValue obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.qty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartSelectedValueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
