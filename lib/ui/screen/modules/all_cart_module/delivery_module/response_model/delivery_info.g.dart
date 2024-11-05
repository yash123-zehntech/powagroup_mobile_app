// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryInfoAdapter extends TypeAdapter<DeliveryInfo> {
  @override
  final int typeId = 19;

  @override
  DeliveryInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliveryInfo(
      id: fields[0] as int?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      type: fields[3] as String?,
      street1: fields[4] as String?,
      street2: fields[5] as String?,
      city: fields[6] as String?,
      state: fields[7] as String?,
      country: fields[8] as String?,
      completeAddress: fields[10] as String?,
      selected: fields[9] as bool?,
      phone: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DeliveryInfo obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.street1)
      ..writeByte(5)
      ..write(obj.street2)
      ..writeByte(6)
      ..write(obj.city)
      ..writeByte(7)
      ..write(obj.state)
      ..writeByte(8)
      ..write(obj.country)
      ..writeByte(9)
      ..write(obj.selected)
      ..writeByte(10)
      ..write(obj.completeAddress)
      ..writeByte(11)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
