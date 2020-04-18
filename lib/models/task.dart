import 'package:hive/hive.dart';

import 'package:dexter/models/category.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  static const boxName = 'tasks';

  // Unique ID usually just Datetime of creation
  @HiveField(0)
  String tid;

  // Task event
  @HiveField(1) 
  String event;

  // Category of event 
  @HiveField(2)
  Category taskCategory;

  // bool
  @HiveField(3)
  bool isDone;

  // Constructor
  Task({
    this.tid,
    this.event,
    this.taskCategory,
    this.isDone = false,
  });

  

  Task.copyWith({Task task, this.isDone}){
    this.tid = task.tid;
    this.event = task.event;
    this.taskCategory = task.taskCategory;
  }

  
  // From Map Constructor
  // Task.fromMap(Map<String, dynamic> m){
  //   // Key should follow column name in database
  //   this.tid = m['tid'];
  //   this.event = m['event'];
  //   this.taskCategory = m['task_category'];
  //   this.isDone = _intToBool(m['isDone']);
  // }



  // // integer getter of b
  // int get isDoneInt {
  //   return isDone ? 1 : 0;
  // }


  // bool _intToBool(int i){
  //   return i == 1 ? true : false;
  // }


  // Used by map so it returns an integer
  // Map<String, dynamic> toMap(){
  //   return {
  //     'tid' : this.tid,
  //     'event' : this.event,
  //     'task_category' : this.taskCategory,
  //     'isDone' : this.isDoneInt,
  //   };
  // }
}