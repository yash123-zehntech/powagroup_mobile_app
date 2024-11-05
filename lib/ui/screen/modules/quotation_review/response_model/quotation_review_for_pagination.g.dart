// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_review_for_pagination.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuotationPageReviewForPaginationAdapter
    extends TypeAdapter<QuotationPageReviewForPagination> {
  @override
  final int typeId = 38;

  @override
  QuotationPageReviewForPagination read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuotationPageReviewForPagination(
      productId: fields[0] as int?,
      customerReviewDetailsForQuoteList: (fields[1] as List?)?.cast<Message>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuotationPageReviewForPagination obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.customerReviewDetailsForQuoteList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuotationPageReviewForPaginationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
