// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShippingDetailsAdapter extends TypeAdapter<ShippingDetails> {
  @override
  final int typeId = 50;

  @override
  ShippingDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShippingDetails(
      name: fields[0] as dynamic,
      driverName: fields[1] as String?,
      arrivalTimePlanned: fields[2] as String?,
      arrivalTimeCompleted: fields[3] as String?,
      status: fields[4] as String?,
      failReason: fields[5] as String?,
      failComment: fields[6] as String?,
      currentPosition: fields[7] as String?,
      longitude: fields[8] as dynamic,
      latitude: fields[9] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ShippingDetails obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.driverName)
      ..writeByte(2)
      ..write(obj.arrivalTimePlanned)
      ..writeByte(3)
      ..write(obj.arrivalTimeCompleted)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.failReason)
      ..writeByte(6)
      ..write(obj.failComment)
      ..writeByte(7)
      ..write(obj.currentPosition)
      ..writeByte(8)
      ..write(obj.longitude)
      ..writeByte(9)
      ..write(obj.latitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShippingDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
