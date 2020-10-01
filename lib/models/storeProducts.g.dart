// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storeProducts.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreProductAdapter extends TypeAdapter<StoreProduct> {
  @override
  final int typeId = 0;

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
      details: (fields[8] as List)?.cast<Details>(),
      totalPrice: fields[6] as double,
      totalQuantity: fields[7] as double,
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
      ..write(obj.totalPrice)
      ..writeByte(7)
      ..write(obj.totalQuantity)
      ..writeByte(8)
      ..write(obj.details);
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
