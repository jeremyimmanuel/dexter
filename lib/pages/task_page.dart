import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/task.dart';

class TaskPage extends StatefulWidget {
  static const routeName = '/task';

  TaskPage({Key key, this.task}) : super(key: key);

  final Task task;

  @override
  
  _TaskPageState createState() => _TaskPageState();
}


class _TaskPageState extends State<TaskPage> {
  

  @override
  Widget build(BuildContext context) {
    return Center(
       child: Text(
         'Task Page'
       ),
    );
  }
}