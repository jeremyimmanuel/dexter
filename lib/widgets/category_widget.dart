import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../models/category.dart';
import '../models/task.dart';
import '../pages/new_category.dart';
import '../main.dart';

class CategoryWidget extends StatelessWidget {
  final Category cat;
  const CategoryWidget({
    Key key,
    @required this.cat,
  }) : super(key: key);

  Widget _buildTile(BuildContext context) {
    return Container(
      color: cat.color,
      child: Center(
        child: Text(
          cat.name,
          style: Theme.of(context).textTheme.body1.copyWith(
                color: cat.luminance > 0.5 ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Show to alert dialog telling users a warning
  Future<bool> _showDeleteWarning(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(
              'Delete ${cat.name}?',
            ),
            content: Text(
              'Deleting a category will also delete all tasks under that category.',
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              CupertinoDialogAction(
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: CupertinoColors.destructiveRed,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text(
              'Delete ${cat.name}?',
            ),
            content: Text(
              'Deleting a category will also delete all tasks under that category.',
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Delete'),
              )
            ],
          );
        }
      },
    );
  }

  // delete category in database
  Future<void> _deleteCategory(BuildContext context) async {
    bool confirm = await _showDeleteWarning(context);
    if (!confirm) return;

    // Delete all tasks under that category
    final taskBox = Hive.box(Task.boxName);
    final tbArr = taskBox.values.toList();
    final kArr = [];

    for (var i = 0; i < tbArr.length; i++) {
      final task = tbArr[i] as Task;
      if (task.taskCategory == this.cat) kArr.add(taskBox.keyAt(i));
    }
    taskBox.deleteAll(kArr);

    // Delete that category
    final catBox = Hive.box(Category.boxName);
    catBox.delete(cat.cid);
  }

  Widget _previewBuilder(
      BuildContext context, Animation<double> animation, Widget w) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35 * animation.value),
      child: Container(
        color: cat.color,
        child: Center(
          child: Text(
            cat.name,
            style: Theme.of(context).textTheme.body1.copyWith(
                  color: cat.luminance > 0.5 ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 60 * animation.value,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// Show bottom sheet for edit and delete functions
  void _showActions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (ctx) {
          return Container(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(NewCategory.routeName,
                          arguments: {'category': this.cat});
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Delete'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await _deleteCategory(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    const IconData cuperPencil = const IconData(
      0xf37e,
      fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage,
    );
    var menuActions = <Widget>[
      // Edit
      CupertinoContextMenuAction(
        child: Text(
          'Edit',
          style: TextStyle(color: Colors.black),
        ),
        trailingIcon: cuperPencil,
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(NewCategory.routeName,
              arguments: {'category': this.cat});
        },
      ),
      // Delete
      CupertinoContextMenuAction(
        isDestructiveAction: true,
        child: const Text(
          'Delete',
          style: TextStyle(color: CupertinoColors.destructiveRed),
        ),
        trailingIcon: CupertinoIcons.delete,
        onPressed: () async {
          Navigator.of(context).pop();
          await _deleteCategory(context);
        },
      ),
    ];

    // ? Default categories cannot be edited or deleted
    if (DEFAULT_CATEGORIES.contains(cat.name))
      return _buildTile(context);
    else if (Platform.isIOS) {
      return CupertinoContextMenu(
        previewBuilder: _previewBuilder,
        actions: menuActions,
        child: _buildTile(context),
      );
    } else {
      return GestureDetector(
        child: _buildTile(context),
        onTap: () {
          _showActions(context);
        },
      );
    }
  }
}
