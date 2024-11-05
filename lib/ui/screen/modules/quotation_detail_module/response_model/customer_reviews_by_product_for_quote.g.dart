// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_reviews_by_product_for_quote.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerReviewByProductForQuoteAdapter
    extends TypeAdapter<CustomerReviewByProductForQuote> {
  @override
  final int typeId = 37;

  @override
  CustomerReviewByProductForQuote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerReviewByProductForQuote(
      productId: fields[0] as int?,
      customerReviewDetailsForQuote: (fields[1] as List?)?.cast<Message>(),
    );
  }

  @override
  void write(BinaryWriter writer, CustomerReviewByProductForQuote obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.customerReviewDetailsForQuote);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerReviewByProductForQuoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
