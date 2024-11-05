// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductDetailsDataAdapter extends TypeAdapter<ProductDetailsData> {
  @override
  final int typeId = 6;

  @override
  ProductDetailsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductDetailsData(
      id: fields[0] as int?,
      name: fields[1] as String?,
      sku: fields[2] as String?,
      saleUom: fields[3] as String?,
      priceUntaxed: fields[4] as double?,
      priceTax: fields[5] as double?,
      priceTotal: fields[6] as double?,
      priceDelivery: fields[7] as int?,
      qtyBreaks: (fields[8] as List?)?.cast<QtyBreak>(),
      mainImageUrl: fields[9] as String?,
      extraImages: (fields[10] as List?)?.cast<dynamic>(),
      description: fields[11] as String?,
      alternativeProducts: (fields[12] as List?)?.cast<AlternativeProduct>(),
      accessoryProducts: (fields[13] as List?)?.cast<AccessoryProduct>(),
      yashValue: fields[14] as String?,
      priceByQty: fields[15] as double?,
      price: fields[16] as int?,
      isFav: fields[17] as bool?,
      totalReviewCount: fields[19] as int?,
      deliveryEx: fields[20] as dynamic,
      deliveryInc: fields[21] as dynamic,
      deliveryTax: fields[22] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ProductDetailsData obj) {
    writer
      ..writeByte(22)
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
      ..write(obj.yashValue)
      ..writeByte(15)
      ..write(obj.priceByQty)
      ..writeByte(16)
      ..write(obj.price)
      ..writeByte(17)
      ..write(obj.isFav)
      ..writeByte(19)
      ..write(obj.totalReviewCount)
      ..writeByte(20)
      ..write(obj.deliveryEx)
      ..writeByte(21)
      ..write(obj.deliveryInc)
      ..writeByte(22)
      ..write(obj.deliveryTax);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDetailsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccessoryProductAdapter extends TypeAdapter<AccessoryProduct> {
  @override
  final int typeId = 7;

  @override
  AccessoryProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccessoryProduct(
      id: fields[0] as int?,
      name: fields[1] as String?,
      defaultCode: fields[2] as String?,
      mainImageUrl: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AccessoryProduct obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.defaultCode)
      ..writeByte(3)
      ..write(obj.mainImageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessoryProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AlternativeProductAdapter extends TypeAdapter<AlternativeProduct> {
  @override
  final int typeId = 8;

  @override
  AlternativeProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlternativeProduct(
      id: fields[0] as int?,
      name: fields[1] as String?,
      defaultCode: fields[2] as String?,
      mainImageUrl: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AlternativeProduct obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.defaultCode)
      ..writeByte(3)
      ..write(obj.mainImageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlternativeProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
