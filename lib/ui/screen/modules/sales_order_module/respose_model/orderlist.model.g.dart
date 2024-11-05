// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orderlist.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 13;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      id: fields[0] as int?,
      name: fields[1] as String?,
      customerId: fields[2] as int?,
      customerName: fields[3] as String?,
      customer: fields[4] as Customer?,
      invoiceAddress: fields[5] as Address?,
      shippingAddress: fields[6] as Address?,
      siteContact: fields[7] as SiteContact?,
      orderDate: fields[8] as String?,
      expiryDate: fields[9] as String?,
      paymentStatus: fields[10] as String?,
      shippingStatus: fields[11] as String?,
      shippingDetails: fields[12] as ShippingDetails?,
      state: fields[13] as String?,
      invoices: (fields[14] as List?)?.cast<Invoice>(),
      deliveries: (fields[15] as List?)?.cast<Delivery>(),
      deliveryEx: fields[16] as double?,
      subtotalExDelivery: fields[17] as double?,
      tax: fields[18] as double?,
      subtotal: fields[19] as double?,
      total: fields[20] as double?,
      isExpand: fields[21] as bool?,
      lines: (fields[22] as List?)?.cast<Line>(),
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(23)
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
      ..write(obj.shippingDetails)
      ..writeByte(13)
      ..write(obj.state)
      ..writeByte(14)
      ..write(obj.invoices)
      ..writeByte(15)
      ..write(obj.deliveries)
      ..writeByte(16)
      ..write(obj.deliveryEx)
      ..writeByte(17)
      ..write(obj.subtotalExDelivery)
      ..writeByte(18)
      ..write(obj.tax)
      ..writeByte(19)
      ..write(obj.subtotal)
      ..writeByte(20)
      ..write(obj.total)
      ..writeByte(21)
      ..write(obj.isExpand)
      ..writeByte(22)
      ..write(obj.lines);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
