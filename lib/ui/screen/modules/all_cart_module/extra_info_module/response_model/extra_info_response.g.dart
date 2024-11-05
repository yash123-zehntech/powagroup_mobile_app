// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extra_info_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExtraInfoDataAdapter extends TypeAdapter<ExtraInfoData> {
  @override
  final int typeId = 15;

  @override
  ExtraInfoData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExtraInfoData(
      id: fields[0] as String?,
      siteContect: fields[1] as String?,
      refernceNumber: fields[2] as String?,
      deliveryNotes: fields[3] as String?,
      officialPurchesOrder: fields[4] as String?,
      zipCode: fields[5] as String?,
      country: fields[6] as String?,
      stateProvice: fields[7] as String?,
      imagePath: fields[8] as String?,
      warehouseId: fields[9] as String?,
      warehouseName: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExtraInfoData obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.siteContect)
      ..writeByte(2)
      ..write(obj.refernceNumber)
      ..writeByte(3)
      ..write(obj.deliveryNotes)
      ..writeByte(4)
      ..write(obj.officialPurchesOrder)
      ..writeByte(5)
      ..write(obj.zipCode)
      ..writeByte(6)
      ..write(obj.country)
      ..writeByte(7)
      ..write(obj.stateProvice)
      ..writeByte(8)
      ..write(obj.imagePath)
      ..writeByte(9)
      ..write(obj.warehouseId)
      ..writeByte(10)
      ..write(obj.warehouseName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtraInfoDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
