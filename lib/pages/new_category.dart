import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';
import 'package:random_color/random_color.dart';

import '../models/category.dart';
import '../models/task.dart';

class NewCategory extends StatefulWidget {
  static const routeName = '/newCategory';
  NewCategory({
    Key key,
    this.cat,
  }) : super(key: key);

  final Category cat;

  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {

  TextEditingController _nameController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();

  bool _isEditMode;
  String _oldName;

  final catBox = Hive.box(Category.boxName);

  Color _currentColor;
  double get _luminance =>
      (0.299 * _currentColor.red +
          0.587 * _currentColor.green +
          0.114 * _currentColor.blue) /
      255.0;

  String currentName = "";

  @override
  void initState() {
    super.initState();

    _isEditMode = widget.cat != null;
    if (_isEditMode) {
      _oldName = widget.cat.name;
      _currentColor = widget.cat.color;
      _nameController.text = _oldName;
    } else {
      _currentColor = RandomColor().randomColor();
    }

  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  /// Build Category Name Field
  TextField _buildNameField() {
    final b = UnderlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).accentColor,
      ),
    );
    return TextField(
      controller: _nameController,
      autocorrect: false,
      autofocus: true,
      focusNode: _nameFocusNode,
      cursorColor: Theme.of(context).accentColor,
      textInputAction: TextInputAction.next,
      maxLength: 20,
      // inputFormatters: [
      //   BlacklistingTextInputFormatter(RegExp('[^\x00-\x7F]+')) // Keyboard only
      // ],
      onChanged: (newS) {
        setState(() {
          currentName = newS;
        });
      },
      onSubmitted: (s) {
        _nameFocusNode.unfocus();
        // FocusScope.of(context).requestFocus(_categoryFocusNode);
      },
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Category Name',
        labelStyle: TextStyle(
          color: Theme.of(context).accentColor,
        ),
        contentPadding: const EdgeInsets.only(top: 5),
        border: b,
        enabledBorder: b,
        focusedBorder: b,
      ),
    );
  }

  // Show Color Picker
  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _currentColor,
              onColorChanged: (newColor) {
                setState(() {
                  _currentColor = newColor;
                });
              },
              colorPickerWidth: 300.0,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: false,
              displayThumbColor: true,
              showLabel: true,
              paletteType: PaletteType.hsv,
              pickerAreaBorderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(2.0),
                topRight: const Radius.circular(2.0),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 25,
          width: 25,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: _currentColor,
          ),
        ),
        RaisedButton(
          onPressed: _showColorPicker,
          elevation: 0,
          child: const Text('Pick Color'),
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              style: BorderStyle.solid,
            ),
          ),
        ),
      ],
    );
  }

  FloatingActionButton _buildAddUpdateButton() {
    return FloatingActionButton.extended(
      elevation: 0,
      label: Text(
        _isEditMode ? 'Update' : 'Add',
        style: Theme.of(context).textTheme.subtitle,
      ),
      icon: _isEditMode
          ? null
          : Icon(
              Icons.add,
              color: Theme.of(context).accentColor,
            ),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.black.withOpacity(0.5),
          width: 1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      onPressed: _addCategory,
    );
  }

  // Build Color container at the top
  Widget _buildColorContainer() {
    return Container(
      child: Center(
        child: Text(
          _nameController.text,
          style: TextStyle(
            color: _luminance > 0.5 ? Colors.black : Colors.white,
          ),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _currentColor,
        // gradient: LinearGradient(
        //   colors: [
        //     _currentColor,
        //     Theme.of(context).primaryColor,
        //   ],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   stops: [0.8, 1],
        // ),
      ),
    );
  }

  // Category is duplicate if have same cat name
  bool _checkDuplicate() {
    for (var cat in catBox.values) {
      if (cat.name == _nameController.text.trim()) {
        print('cat.name : ${cat.name}');
        print('_nameController.text.trim() : ${_nameController.text.trim()}');
        return true;
      }
    }
    return false;
  }

  /// Validating the user inputs
  ///
  /// 1. Cannot be empty string even after trimming the string
  /// 2. Cannot be a duplicate category name
  bool _validate() {
    final name = _nameController.text.trim().toLowerCase();

    const ok = 'OK';
    
    // 1. Check for empty white spaces
    if (name.isEmpty) {
      const emptyWarning = 'Category name cannot be empty!';
      showDialog(
        context: context,
        builder: (context) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: const Text(emptyWarning),
              actions: <Widget>[
                CupertinoDialogAction(
                    child: const Text(ok),
                    onPressed: () => Navigator.of(context).pop()),
              ],
            );
          } else {
            return AlertDialog(
              title: const Text(emptyWarning),
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

    if (_isEditMode) {
      // user didn't change the category name
      if (name == _oldName.toLowerCase()) return true;
    }

    // 2. Check for duplicates db;
    // if (catBox.get(name) != null) {
    if (_checkDuplicate()) {
      final duplicateWarning = 'Category "${_nameController.text.trim()}" already exists!';
      showDialog(
        context: context,
        builder: (context) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: Text(duplicateWarning),
              actions: <Widget>[
                CupertinoDialogAction(
                    child: const Text(ok),
                    onPressed: () => Navigator.of(context).pop()),
              ],
            );
          } else {
            return AlertDialog(
              title: Text(duplicateWarning),
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

  /// Adds Category to the database
  void _addCategory() {
    if (!_validate()) return;

    final newC = Category(
      name: _nameController.text.trim(),
      colorVal: _currentColor.value,
    );

    // delete old category if in edit mode
    if (_isEditMode) {
      newC.cid = widget.cat.cid;
      final taskBox = Hive.box(Task.boxName);
      final tbArr = taskBox.values.toList();
      for (var i = 0; i < tbArr.length; i++) {
        final task = tbArr[i] as Task;
        if (task.taskCategory.cid == widget.cat.cid) {
          taskBox.delete(task.tid);
          task.taskCategory = newC;
          taskBox.put(task.tid, task);
        }
      }
      catBox.delete(widget.cat.cid);
    }

    // put new category to box
    catBox.put(newC.cid, newC);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildColorContainer(),
            Container(
              // margin: EdgeInsets.only(top: deviceHeight * 0.15),
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  _buildNameField(),
                  const SizedBox(height: 20),
                  _buildColorPicker(),
                  const SizedBox(height: 20),
                  _buildAddUpdateButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
