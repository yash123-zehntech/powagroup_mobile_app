// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubCategoryDataAdapter extends TypeAdapter<SubCategoryData> {
  @override
  final int typeId = 3;

  @override
  SubCategoryData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubCategoryData(
      subCategoryId: fields[0] as String?,
      productsList: (fields[1] as List?)?.cast<ProductData>(),
    );
  }

  @override
  void write(BinaryWriter writer, SubCategoryData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.subCategoryId)
      ..writeByte(1)
      ..write(obj.productsList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubCategoryDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductDataAdapter extends TypeAdapter<ProductData> {
  @override
  final int typeId = 1;

  @override
  ProductData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductData(
      id: fields[0] as int?,
      name: fields[1] as String?,
      sku: fields[2] as String?,
      saleUom: fields[3] as String?,
      priceUntaxed: fields[4] as double?,
      priceTax: fields[5] as double?,
      priceTotal: fields[6] as double?,
      priceDelivery: fields[7] as double?,
      qtyBreaks: (fields[8] as List?)?.cast<QtyBreak>(),
      mainImageUrl: fields[9] as String?,
      extraImages: (fields[10] as List?)?.cast<dynamic>(),
      description: fields[11] as String?,
      yashValue: fields[13] as String?,
      priceByQty: fields[15] as String?,
      price: fields[16] as String?,
      isFav: fields[12] as bool?,
      deliveryEx: fields[17] as dynamic,
      deliveryInc: fields[18] as dynamic,
      deliveryTax: fields[19] as dynamic,
      userId: fields[20] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductData obj) {
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
      ..write(obj.isFav)
      ..writeByte(13)
      ..write(obj.yashValue)
      ..writeByte(15)
      ..write(obj.priceByQty)
      ..writeByte(16)
      ..write(obj.price)
      ..writeByte(17)
      ..write(obj.deliveryEx)
      ..writeByte(18)
      ..write(obj.deliveryInc)
      ..writeByte(19)
      ..write(obj.deliveryTax)
      ..writeByte(20)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
