// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final typeId = 0;

  @override
  Task read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      tid: fields[0] as String,
      event: fields[1] as String,
      taskCategory: fields[2] as Category,
      isDone: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.tid)
      ..writeByte(1)
      ..write(obj.event)
      ..writeByte(2)
      ..write(obj.taskCategory)
      ..writeByte(3)
      ..write(obj.isDone);
  }
}
