// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserReviewAdapter extends TypeAdapter<UserReview> {
  @override
  final int typeId = 16;

  @override
  UserReview read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserReview(
      title: fields[0] as String?,
      review: fields[1] as String?,
      rating: fields[2] as int?,
      reviewedBy: fields[3] as ReviewedBy?,
      date: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserReview obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.review)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.reviewedBy)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserReviewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReviewedByAdapter extends TypeAdapter<ReviewedBy> {
  @override
  final int typeId = 17;

  @override
  ReviewedBy read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewedBy(
      id: fields[0] as int?,
      name: fields[1] as String?,
      company: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ReviewedBy obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.company);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewedByAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
