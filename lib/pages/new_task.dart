import 'dart:core';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../models/task.dart';
import '../models/category.dart';

class NewTask extends StatefulWidget {
  NewTask({Key key}) : super(key: key);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  TextEditingController _eventController = TextEditingController();
  Category _dropDownCat = Hive.box(Category.boxName)
      .get(Hive.box('settings').get('lastDropDown') ?? 'Home');

  FocusNode _eventFocusNode = FocusNode();
  FocusNode _categoryFocusNode = FocusNode();

  @override
  void dispose() {
    _eventController.dispose();
    _categoryFocusNode.dispose();
    super.dispose();
  }

  /// Validate input
  ///
  /// 1. Cannot be empty
  bool _validate() {
    if (_eventController.text.trim().isEmpty) {
      const text = 'Task must not be empty!';
      const ok = 'OK';
      showDialog(
        context: context,
        builder: (context) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: const Text(text),
              actions: <Widget>[
                CupertinoDialogAction(
                    child: const Text(ok),
                    onPressed: () => Navigator.of(context).pop()),
              ],
            );
          } else {
            return AlertDialog(
              title: Text(
                text,
                style: Theme.of(context).textTheme.body1,
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(ok),
                )
              ],
            );
          }
        },
      );
      return false;
    }
    return true;
  }

  /// Add Task to database
  void _addTask() {
    if (!_validate()) return;

    Task task = Task(
      tid: DateTime.now().toString(),
      event: _eventController.text,
      taskCategory: _dropDownCat,
    );
    Hive.box('tasks').put(task.tid, task);
    Navigator.of(context).pop();
  }

  /// Build text field for Task event
  Widget _buildTextField() {
    final b = UnderlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).accentColor,
      ),
    );
    return TextField(
      controller: _eventController,
      autofocus: true,
      focusNode: _eventFocusNode,
      cursorColor: Theme.of(context).accentColor,
      textInputAction: TextInputAction.next,
      onSubmitted: (s) {
        _eventFocusNode.unfocus();
      },
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Task',
        border: b,
        enabledBorder: b,
        focusedBorder: b,
      ),
    );
  }

  /// Build drop down category selector
  DropdownButton _buildDropDown() {
    final catBox = Hive.box(Category.boxName);
    _dropDownCat ??= catBox.get('Home');
    return DropdownButton(
        focusNode: _categoryFocusNode,
        value: _dropDownCat,
        icon: const Icon(
          Icons.arrow_drop_down,
        ),
        items: catBox.values.toList().map(
          (cat) {
            return DropdownMenuItem<Category>(
              value: cat,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: cat.color,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text(cat.name),
                ],
              ),
            );
          },
        ).toList(),
        onChanged: (v) {
          setState(() {
            _dropDownCat = v;
            if (v.name == 'Home' ||
                v.name == 'Family' ||
                v.name == 'Work' ||
                v.name == 'Other')
              Hive.box('settings').put('lastDropDown', (v as Category).name);
            else
              Hive.box('settings').put('lastDropDown', (v as Category).cid);
          });
        });
  }

  /// Build add button
  ///
  /// When clicked, app adds the newly created
  /// category to the database
  FloatingActionButton _buildAddButton() {
    return FloatingActionButton.extended(
      label: Text(
        'Add',
        style: Theme.of(context).textTheme.subtitle,
      ),
      icon: Icon(
        Icons.add,
        color: Theme.of(context).accentColor,
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).accentColor.withOpacity(0.5),
          width: 2,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      onPressed: _addTask,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Title
            const Text(
              'Add new task',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Event Text Field
            _buildTextField(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildDropDown(),
                _buildAddButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
