// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_contact_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SiteContactAdapter extends TypeAdapter<SiteContact> {
  @override
  final int typeId = 33;

  @override
  SiteContact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SiteContact(
      id: fields[0] as dynamic,
      name: fields[1] as String?,
      email: fields[2] as String?,
      type: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SiteContact obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SiteContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
