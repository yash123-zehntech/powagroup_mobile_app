// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_methods_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryMethodAdapter extends TypeAdapter<DeliveryMethod> {
  @override
  final int typeId = 51;

  @override
  DeliveryMethod read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliveryMethod(
      id: fields[0] as int?,
      description: fields[1] as String?,
      name: fields[2] as String?,
      deliveryEx: fields[3] as dynamic,
      deliveryInc: fields[4] as dynamic,
      deliveryTax: fields[5] as dynamic,
      pickup: fields[6] as bool?,
      isSelected: fields[7] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, DeliveryMethod obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.deliveryEx)
      ..writeByte(4)
      ..write(obj.deliveryInc)
      ..writeByte(5)
      ..write(obj.deliveryTax)
      ..writeByte(6)
      ..write(obj.pickup)
      ..writeByte(7)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryMethodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
