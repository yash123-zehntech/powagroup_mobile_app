// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuotationOrderAdapter extends TypeAdapter<QuotationOrder> {
  @override
  final int typeId = 14;

  @override
  QuotationOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuotationOrder(
      id: fields[0] as int?,
      name: fields[1] as String?,
      customerId: fields[2] as int?,
      customerName: fields[3] as String?,
      customer: fields[4] as Customer?,
      invoiceAddress: fields[5] as Address?,
      shippingAddress: fields[6] as Address?,
      siteContact: fields[7] as SiteContact?,
      orderDate: fields[8] as String?,
      expiryDate: fields[9] as dynamic,
      paymentStatus: fields[10] as String?,
      shippingStatus: fields[11] as String?,
      state: fields[12] as String?,
      invoices: (fields[13] as List?)?.cast<dynamic>(),
      deliveries: (fields[14] as List?)?.cast<dynamic>(),
      deliveryEx: fields[15] as dynamic,
      subtotalExDelivery: fields[16] as double?,
      tax: fields[17] as double?,
      subtotal: fields[18] as double?,
      total: fields[19] as double?,
      isExpand: fields[20] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, QuotationOrder obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.customerId)
      ..writeByte(3)
      ..write(obj.customerName)
      ..writeByte(4)
      ..write(obj.customer)
      ..writeByte(5)
      ..write(obj.invoiceAddress)
      ..writeByte(6)
      ..write(obj.shippingAddress)
      ..writeByte(7)
      ..write(obj.siteContact)
      ..writeByte(8)
      ..write(obj.orderDate)
      ..writeByte(9)
      ..write(obj.expiryDate)
      ..writeByte(10)
      ..write(obj.paymentStatus)
      ..writeByte(11)
      ..write(obj.shippingStatus)
      ..writeByte(12)
      ..write(obj.state)
      ..writeByte(13)
      ..write(obj.invoices)
      ..writeByte(14)
      ..write(obj.deliveries)
      ..writeByte(15)
      ..write(obj.deliveryEx)
      ..writeByte(16)
      ..write(obj.subtotalExDelivery)
      ..writeByte(17)
      ..write(obj.tax)
      ..writeByte(18)
      ..write(obj.subtotal)
      ..writeByte(19)
      ..write(obj.total)
      ..writeByte(20)
      ..write(obj.isExpand);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuotationOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
