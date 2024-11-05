// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 42;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      user: fields[0] as UserObject?,
      error: fields[1] as String?,
      statusCode: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.user)
      ..writeByte(1)
      ..write(obj.error)
      ..writeByte(2)
      ..write(obj.statusCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserObjectAdapter extends TypeAdapter<UserObject> {
  @override
  final int typeId = 41;

  @override
  UserObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserObject(
      userId: fields[0] as int?,
      partnerId: fields[1] as int?,
      name: fields[2] as String?,
      email: fields[3] as String?,
      isLoggedIn: fields[4] as bool?,
      priceListId: fields[5] as int?,
      priceListName: fields[6] as String?,
      paymentTermId: fields[7] as dynamic,
      paymentTermName: fields[8] as dynamic,
      preferredDeliveryMethodId: fields[9] as dynamic,
      preferredDeliveryMethodName: fields[10] as dynamic,
      id: fields[11] as int?,
      phone: fields[12] as String?,
      mobile: fields[13] as String?,
      type: fields[14] as String?,
      street1: fields[15] as String?,
      street2: fields[16] as String?,
      city: fields[17] as String?,
      state: fields[18] as String?,
      country: fields[19] as String?,
      showPricing: fields[20] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserObject obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.partnerId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.isLoggedIn)
      ..writeByte(5)
      ..write(obj.priceListId)
      ..writeByte(6)
      ..write(obj.priceListName)
      ..writeByte(7)
      ..write(obj.paymentTermId)
      ..writeByte(8)
      ..write(obj.paymentTermName)
      ..writeByte(9)
      ..write(obj.preferredDeliveryMethodId)
      ..writeByte(10)
      ..write(obj.preferredDeliveryMethodName)
      ..writeByte(11)
      ..write(obj.id)
      ..writeByte(12)
      ..write(obj.phone)
      ..writeByte(13)
      ..write(obj.mobile)
      ..writeByte(14)
      ..write(obj.type)
      ..writeByte(15)
      ..write(obj.street1)
      ..writeByte(16)
      ..write(obj.street2)
      ..writeByte(17)
      ..write(obj.city)
      ..writeByte(18)
      ..write(obj.state)
      ..writeByte(19)
      ..write(obj.country)
      ..writeByte(20)
      ..write(obj.showPricing);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
