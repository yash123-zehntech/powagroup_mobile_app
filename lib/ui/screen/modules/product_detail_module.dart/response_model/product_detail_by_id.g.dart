// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_by_id.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductDetailByIdAdapter extends TypeAdapter<ProductDetailById> {
  @override
  final int typeId = 9;

  @override
  ProductDetailById read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductDetailById(
      subCategoryId: fields[0] as int?,
      productDetails: fields[1] as ProductDetailsData?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductDetailById obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.subCategoryId)
      ..writeByte(1)
      ..write(obj.productDetails);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDetailByIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
