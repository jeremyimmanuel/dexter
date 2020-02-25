import 'package:dexter/widgets/task_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../models/task.dart';
import '../pages/new_task.dart';
import '../pages/app_drawer.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<SharedPreferences> fPref = SharedPreferences.getInstance();
  bool _isRight;

  @override
  void initState() {
    super.initState();
    fPref.then((pref) {
      setState(() {
        _isRight = pref.getBool('isRight') ?? true;
      });
    });
  }

  /// Shows the new task pop up from the bottom
  /// of the screen
  void _showAddNewTask() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return NewTask();
      },
    );
  }

  // void _updateMyItems(int oldIdx, int newIdx) {
  //   if (newIdx > oldIdx) newIdx -= 1;

  //   final Task t = tl.removeAt(oldIdx);
  //   tl.insert(newIdx, t);
  // }

  void _deleteTask(int i) {
    final taskBox = Hive.box('tasks');
    taskBox.deleteAt(i);
  }

  Widget _buildListView(bool isRight) {
    final taskBox = Hive.box('tasks');
    // taskBox.watch(key: 'tasks');
    return ValueListenableBuilder(
      valueListenable: taskBox.listenable(),
      builder: (ctx, Box box, widget) {
        if (box.values.isEmpty)
          return Center(
            child: Text('No Tasks Yet!'),
          );
        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (ctx, index) {
            final task = box.getAt(index) as Task;
            // final task = taskList[index];
            return Dismissible(
              child: TaskWidget(
                t: task,
                index: index,
                isRight: isRight,
              ),
              key: Key(box.keyAt(index).toString()),
              onDismissed: (_) => _deleteTask(index),
              direction: isRight
                  ? DismissDirection.startToEnd
                  : DismissDirection.endToStart,
              background: Container(
                color: Colors.red[600],
                alignment: Alignment(
                  isRight ? -0.8 : 0.8,
                  0,
                ),
                child: const Icon(
                  Icons.delete_forever,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            );
          },
        );
      },
    );
  }

  FloatingActionButton _buildAddButton() {
    return FloatingActionButton(
      heroTag: null,
      elevation: 0,
      child: Icon(
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
      onPressed: _showAddNewTask,
    );
  }

  // build left right UI switcher button
  Positioned _buildLRButton(BuildContext context) {
    return Positioned(
      left: _isRight ? 0 : null,
      right: !_isRight ? 0 : null,
      top: MediaQuery.of(context).size.height * 0.6,
      child: FloatingActionButton(
        elevation: 1,
        mini: true,
        child: Icon(
          _isRight ? Icons.arrow_right : Icons.arrow_left,
          color: Theme.of(context).primaryColor,
          size: 25,
        ),
        backgroundColor: Theme.of(context).accentColor.withOpacity(0.8),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
              // _isRight
              bottomLeft: _isRight ? Radius.circular(20) : Radius.zero,
              topRight: _isRight ? Radius.circular(20) : Radius.zero,
              // not _isRight
              bottomRight: !_isRight ? Radius.circular(20) : Radius.zero,
              topLeft: !_isRight ? Radius.circular(20) : Radius.zero),
        ),
        onPressed: () async {
          setState(() {
            _isRight = !_isRight;
            print('isRight : $_isRight');
          });
          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setBool('isRight', _isRight);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isRight == null)
      return const Center(
        child: SpinKitRotatingCircle(
          color: Colors.black,
          size: 50.0,
        ),
      );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks'),
      ),
      // negation kinda tricky
      drawer: !_isRight ? AppDrawer() : null,
      endDrawer: _isRight ? AppDrawer.right() : null,
      body: Stack(
        children: <Widget>[
          _buildListView(_isRight),
          _buildLRButton(context),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildAddButton(),
    );
  }
}


