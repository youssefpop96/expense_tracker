// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoanAdapter extends TypeAdapter<Loan> {
  @override
  final int typeId = 1;

  @override
  Loan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Loan(
      description: fields[0] as String,
      originalAmount: fields[1] as double,
      remainingAmount: fields[2] as double,
      dueDate: fields[3] as DateTime,
      isBorrowing: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Loan obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.originalAmount)
      ..writeByte(2)
      ..write(obj.remainingAmount)
      ..writeByte(3)
      ..write(obj.dueDate)
      ..writeByte(4)
      ..write(obj.isBorrowing);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
