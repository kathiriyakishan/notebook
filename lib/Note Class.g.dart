// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Note Class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class noteAdapter extends TypeAdapter<note> {
  @override
  final int typeId = 0;

  @override
  note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return note(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, note obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.subtitle)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is noteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
