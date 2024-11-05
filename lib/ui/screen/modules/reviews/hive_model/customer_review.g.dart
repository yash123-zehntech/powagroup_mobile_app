// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_review.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerReviewOfProductAdapter
    extends TypeAdapter<CustomerReviewOfProduct> {
  @override
  final int typeId = 19;

  @override
  CustomerReviewOfProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerReviewOfProduct(
      productId: fields[0] as int?,
      customerReviewDetails: (fields[1] as List?)?.cast<UserReview>(),
    );
  }

  @override
  void write(BinaryWriter writer, CustomerReviewOfProduct obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.customerReviewDetails);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerReviewOfProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
