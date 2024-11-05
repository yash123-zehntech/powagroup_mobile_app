// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unitprice_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnitPriceExAdapter extends TypeAdapter<UnitPriceEx> {
  @override
  final int typeId = 35;

  @override
  UnitPriceEx read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnitPriceEx(
      baseTags: (fields[0] as List?)?.cast<int>(),
      taxes: (fields[1] as List?)?.cast<Tax>(),
      totalExcluded: fields[2] as double?,
      totalIncluded: fields[3] as double?,
      totalVoid: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, UnitPriceEx obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.baseTags)
      ..writeByte(1)
      ..write(obj.taxes)
      ..writeByte(2)
      ..write(obj.totalExcluded)
      ..writeByte(3)
      ..write(obj.totalIncluded)
      ..writeByte(4)
      ..write(obj.totalVoid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitPriceExAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
