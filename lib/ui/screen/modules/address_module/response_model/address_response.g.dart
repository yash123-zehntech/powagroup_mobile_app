// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressDataAdapter extends TypeAdapter<AddressData> {
  @override
  final int typeId = 5;

  @override
  AddressData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddressData(
      id: fields[0] as String?,
      addressName: fields[1] as String?,
      emailAddress: fields[2] as String?,
      mobileNumber: fields[3] as String?,
      streetNameNumber: fields[4] as String?,
      streetNameOther: fields[5] as String?,
      code: fields[6] as String?,
      country: fields[7] as String?,
      state: fields[8] as String?,
      city: fields[9] as String?,
      siteContactPhoneNumber: fields[10] as String?,
      addressType: fields[11] as String?,
      completeAddress: fields[12] as String?,
      isSelect: fields[13] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AddressData obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.addressName)
      ..writeByte(2)
      ..write(obj.emailAddress)
      ..writeByte(3)
      ..write(obj.mobileNumber)
      ..writeByte(4)
      ..write(obj.streetNameNumber)
      ..writeByte(5)
      ..write(obj.streetNameOther)
      ..writeByte(6)
      ..write(obj.code)
      ..writeByte(7)
      ..write(obj.country)
      ..writeByte(8)
      ..write(obj.state)
      ..writeByte(9)
      ..write(obj.city)
      ..writeByte(10)
      ..write(obj.siteContactPhoneNumber)
      ..writeByte(11)
      ..write(obj.addressType)
      ..writeByte(12)
      ..write(obj.completeAddress)
      ..writeByte(13)
      ..write(obj.isSelect);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
