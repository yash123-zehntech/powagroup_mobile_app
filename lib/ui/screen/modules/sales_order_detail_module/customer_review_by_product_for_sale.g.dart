// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_review_by_product_for_sale.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerReviewByProductForSaleAdapter
    extends TypeAdapter<CustomerReviewByProductForSale> {
  @override
  final int typeId = 39;

  @override
  CustomerReviewByProductForSale read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerReviewByProductForSale(
      productId: fields[0] as int?,
      customerReviewDetailsForSale: (fields[1] as List?)?.cast<Message>(),
    );
  }

  @override
  void write(BinaryWriter writer, CustomerReviewByProductForSale obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.customerReviewDetailsForSale);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerReviewByProductForSaleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
