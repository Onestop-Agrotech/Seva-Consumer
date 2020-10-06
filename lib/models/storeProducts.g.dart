// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storeProducts.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreProductAdapter extends TypeAdapter<StoreProduct> {
  @override
  final int typeId = 1;

  @override
  StoreProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoreProduct(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      uniqueId: fields[3] as String,
      description: fields[4] as String,
      pictureURL: fields[5] as String,
      details: (fields[6] as List)?.cast<Details>(),
      totalPrice: fields[7] as double,
      totalQuantity: fields[8] as double,
    );
  }

  @override
  void write(BinaryWriter writer, StoreProduct obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.uniqueId)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.pictureURL)
      ..writeByte(6)
      ..write(obj.details)
      ..writeByte(7)
      ..write(obj.totalPrice)
      ..writeByte(8)
      ..write(obj.totalQuantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DetailsAdapter extends TypeAdapter<Details> {
  @override
  final int typeId = 2;

  @override
  Details read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Details(
      quantity: fields[0] as Quantity,
      id: fields[1] as String,
      hubid: fields[2] as String,
      price: fields[3] as int,
      outOfStock: fields[4] as bool,
      bestseller: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Details obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.quantity)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.hubid)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.outOfStock)
      ..writeByte(5)
      ..write(obj.bestseller);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuantityAdapter extends TypeAdapter<Quantity> {
  @override
  final int typeId = 3;

  @override
  Quantity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quantity(
      quantityValue: fields[0] as int,
      quantityMetric: fields[1] as String,
      allowedQuantities: (fields[2] as List)?.cast<AllowedQuantity>(),
    );
  }

  @override
  void write(BinaryWriter writer, Quantity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.quantityValue)
      ..writeByte(1)
      ..write(obj.quantityMetric)
      ..writeByte(2)
      ..write(obj.allowedQuantities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuantityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AllowedQuantityAdapter extends TypeAdapter<AllowedQuantity> {
  @override
  final int typeId = 4;

  @override
  AllowedQuantity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllowedQuantity(
      id: fields[0] as String,
      value: fields[1] as int,
      metric: fields[2] as String,
      qty: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AllowedQuantity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.metric)
      ..writeByte(3)
      ..write(obj.qty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllowedQuantityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
