// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesOrderDetailsAdapter extends TypeAdapter<SalesOrderDetails> {
  @override
  final int typeId = 25;

  @override
  SalesOrderDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesOrderDetails(
      order: fields[0] as Orders?,
      user: fields[1] as User?,
      statusCode: fields[2] as int?,
      error: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SalesOrderDetails obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.order)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.statusCode)
      ..writeByte(3)
      ..write(obj.error);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesOrderDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
