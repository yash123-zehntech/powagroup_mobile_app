// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LineAdapter extends TypeAdapter<Line> {
  @override
  final int typeId = 27;

  @override
  Line read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Line(
      id: fields[0] as int?,
      description: fields[1] as String?,
      qty: fields[2] as dynamic,
      uom: fields[3] as String?,
      unitPriceEx: fields[4] as UnitPriceEx?,
      subtotal: fields[5] as double?,
      total: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Line obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.qty)
      ..writeByte(3)
      ..write(obj.uom)
      ..writeByte(4)
      ..write(obj.unitPriceEx)
      ..writeByte(5)
      ..write(obj.subtotal)
      ..writeByte(6)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
