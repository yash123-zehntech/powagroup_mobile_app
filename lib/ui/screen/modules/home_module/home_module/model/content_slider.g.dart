// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_slider.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SliderDataAdapter extends TypeAdapter<SliderData> {
  @override
  final int typeId = 48;

  @override
  SliderData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SliderData(
      sequence: fields[0] as int,
      title: fields[1] as String,
      subtitle: fields[2] as dynamic,
      buttonText: fields[3] as String,
      buttonUrl: fields[4] as String,
      imageUrl: fields[5] as String,
      isPublished: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SliderData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.sequence)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.buttonText)
      ..writeByte(4)
      ..write(obj.buttonUrl)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.isPublished);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SliderDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
