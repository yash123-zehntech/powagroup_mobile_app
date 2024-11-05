// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Customer_review_for_pagination.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerReviewForPaginationAdapter
    extends TypeAdapter<CustomerReviewForPagination> {
  @override
  final int typeId = 22;

  @override
  CustomerReviewForPagination read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerReviewForPagination(
      productId: fields[0] as int?,
      customerReviewDetails: (fields[1] as List?)?.cast<UserReview>(),
    );
  }

  @override
  void write(BinaryWriter writer, CustomerReviewForPagination obj) {
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
      other is CustomerReviewForPaginationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
