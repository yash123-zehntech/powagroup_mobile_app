// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sitecontact_info_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SiteContactInfoAdapter extends TypeAdapter<SiteContactInfo> {
  @override
  final int typeId = 21;

  @override
  SiteContactInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SiteContactInfo(
      id: fields[0] as int?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      type: fields[3] as String?,
      street1: fields[4] as String?,
      street2: fields[5] as String?,
      city: fields[6] as String?,
      state: fields[7] as String?,
      country: fields[8] as String?,
      selected: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SiteContactInfo obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.selected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SiteContactInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
