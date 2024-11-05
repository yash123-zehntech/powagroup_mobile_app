// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_subcategory_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 12;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as dynamic,
      name: fields[1] as dynamic,
      sku: fields[2] as dynamic,
      saleUom: fields[3] as dynamic,
      priceUntaxed: fields[4] as double?,
      priceTax: fields[5] as double?,
      priceTotal: fields[6] as double?,
      priceDelivery: fields[7] as dynamic,
      qtyBreaks: (fields[8] as List?)?.cast<QtyBreak>(),
      mainImageUrl: fields[9] as dynamic,
      extraImages: (fields[10] as List?)?.cast<dynamic>(),
      description: fields[11] as dynamic,
      alternativeProducts: (fields[12] as List?)?.cast<dynamic>(),
      accessoryProducts: (fields[13] as List?)?.cast<dynamic>(),
      isFav: fields[14] as dynamic,
      reviewAvg: fields[15] as double?,
      totalReviewCount: fields[16] as dynamic,
      deliveryEx: fields[17] as dynamic,
      deliveryInc: fields[18] as dynamic,
      deliveryTax: fields[19] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.sku)
      ..writeByte(3)
      ..write(obj.saleUom)
      ..writeByte(4)
      ..write(obj.priceUntaxed)
      ..writeByte(5)
      ..write(obj.priceTax)
      ..writeByte(6)
      ..write(obj.priceTotal)
      ..writeByte(7)
      ..write(obj.priceDelivery)
      ..writeByte(8)
      ..write(obj.qtyBreaks)
      ..writeByte(9)
      ..write(obj.mainImageUrl)
      ..writeByte(10)
      ..write(obj.extraImages)
      ..writeByte(11)
      ..write(obj.description)
      ..writeByte(12)
      ..write(obj.alternativeProducts)
      ..writeByte(13)
      ..write(obj.accessoryProducts)
      ..writeByte(14)
      ..write(obj.isFav)
      ..writeByte(15)
      ..write(obj.reviewAvg)
      ..writeByte(16)
      ..write(obj.totalReviewCount)
      ..writeByte(17)
      ..write(obj.deliveryEx)
      ..writeByte(18)
      ..write(obj.deliveryInc)
      ..writeByte(19)
      ..write(obj.deliveryTax);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QtyBreakAdapter extends TypeAdapter<QtyBreak> {
  @override
  final int typeId = 2;

  @override
  QtyBreak read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QtyBreak(
      qty: fields[0] as dynamic,
      price: fields[1] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, QtyBreak obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.qty)
      ..writeByte(1)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QtyBreakAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
