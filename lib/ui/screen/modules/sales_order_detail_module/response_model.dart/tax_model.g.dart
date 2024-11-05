// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaxAdapter extends TypeAdapter<Tax> {
  @override
  final int typeId = 34;

  @override
  Tax read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tax(
      id: fields[0] as int?,
      name: fields[1] as String?,
      amount: fields[2] as double?,
      base: fields[3] as double?,
      sequence: fields[4] as int?,
      accountId: fields[5] as int?,
      analytic: fields[6] as bool?,
      priceInclude: fields[7] as bool?,
      taxExigibility: fields[8] as String?,
      taxRepartitionLineId: fields[9] as int?,
      group: fields[10] as dynamic,
      tagIds: (fields[11] as List?)?.cast<int>(),
      taxIds: (fields[12] as List?)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Tax obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.base)
      ..writeByte(4)
      ..write(obj.sequence)
      ..writeByte(5)
      ..write(obj.accountId)
      ..writeByte(6)
      ..write(obj.analytic)
      ..writeByte(7)
      ..write(obj.priceInclude)
      ..writeByte(8)
      ..write(obj.taxExigibility)
      ..writeByte(9)
      ..write(obj.taxRepartitionLineId)
      ..writeByte(10)
      ..write(obj.group)
      ..writeByte(11)
      ..write(obj.tagIds)
      ..writeByte(12)
      ..write(obj.taxIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
