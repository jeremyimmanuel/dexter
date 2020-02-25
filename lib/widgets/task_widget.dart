import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/task.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    Key key,
    @required this.t,
    @required this.index,
    @required this.isRight,
  }) : super(key: key);

  final Task t;
  final int index;
  final bool isRight;

  /// Build Checkbox
  Checkbox _buildCheckBox(BuildContext context) {
    return Checkbox(
      activeColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      checkColor: Theme.of(context).primaryColor,
      value: t.isDone,
      onChanged: (v) async {
        final tasks = Hive.box('tasks');
        this.t.isDone = v;
        await tasks.putAt(
          index,
          this.t,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // color box for the Category
    final colorBox = Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: t.isDone ? Colors.grey[500] : this.t.taskCategory.color,
      ),
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: ListTile(
        leading: this.isRight ? null : _buildCheckBox(context),
        trailing: !this.isRight ? null : _buildCheckBox(context),
        title: Text(
          '${this.t.event}',
          textAlign: this.isRight ? TextAlign.end : TextAlign.start,
          style: Theme.of(context).textTheme.body1.copyWith(
                color: this.t.isDone
                    ? Colors.grey[500]
                    : Theme.of(context).textTheme.body1.color,
                decoration: this.t.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
        ),
        subtitle: Row(
          mainAxisAlignment:
              isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            if (!isRight) colorBox,
            if (!isRight) SizedBox(width: 3),
            Text(
              '${this.t.taskCategory.name}',
              style: Theme.of(context).textTheme.subtitle.copyWith(
                    color: t.isDone
                        ? Colors.grey[500]
                        : Theme.of(context).textTheme.subtitle.color,
                  ),
            ),
            if (isRight) SizedBox(width: 3),
            if (isRight) colorBox,
          ],
        ),
      ),
    );
  }
}

/*
class TaskWidget extends StatefulWidget {
  TaskWidget({
    Key key,
    @required this.t,
    @required this.index,
    @required this.isRight,
  }) : super(key: key);

  final Task t;
  final int index;
  final bool isRight;

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  Checkbox _buildCheckBox() {
    return Checkbox(
        activeColor: Theme.of(context).accentColor,
        focusColor: Theme.of(context).accentColor,
        value: widget.t.isDone,
        onChanged: (v) async {
          final tasks = Hive.box('tasks');
          widget.t.isDone = v;
          await tasks.putAt(
            widget.index,
            widget.t,
          );
          var t = tasks.getAt(widget.index) as Task;
          print(t.isDone);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: ListTile(
        leading: widget.isRight ? null : _buildCheckBox(),
        trailing: !widget.isRight ? null : _buildCheckBox(),
        title: Text(
          '${widget.t.event}',
          textAlign: widget.isRight ? TextAlign.end : TextAlign.start,
          style: Theme.of(context).textTheme.body1.copyWith(
                color: widget.t.isDone
                    ? Colors.grey[500]
                    : Theme.of(context).textTheme.body1.color,
                decoration: widget.t.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
        ),
        subtitle: Row(
          mainAxisAlignment:
              widget.isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '${widget.t.taskCategory}',
              style: Theme.of(context).textTheme.subtitle.copyWith(
                    color: widget.t.isDone
                        ? Colors.grey[500]
                        : Theme.of(context).textTheme.subtitle.color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
