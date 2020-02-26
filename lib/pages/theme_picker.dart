import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

import '../utils/theme.dart';

/// Theme Picker page
/// 
/// A page that consists of the available theme options (Light & dark)
class ThemePicker extends StatefulWidget {
  static const routeName = '/themePicker';

  ThemePicker({Key key}) : super(key: key);

  @override
  _ThemePickerState createState() => _ThemePickerState();
}

class _ThemePickerState extends State<ThemePicker> {
  int selected;

  @override
  void initState() { 
    super.initState();
    Timer(Duration.zero, () {
      setState(() {
        selected = Provider.of<DexterTheme>(context, listen: false).selected;    
      });
    });
    
  }

  List<Widget> _buildThemeRadioTiles(DexterTheme d) {
    final themeArr = ['Light', 'Dark',];
    final settingBox = Hive.box('settings');

    return themeArr.map((t) {
      return Column(
        children: <Widget>[
          RadioListTile(
            value: themeArr.indexOf(t),
            groupValue: selected,
            title: Text(
              t,
              style: Theme.of(context).textTheme.body1,
            ),
            onChanged: (v) => setState(() {
              selected = v;
              d.selectTheme = v;
              settingBox.put('theme', v);
            }),
            activeColor: Theme.of(context).accentColor,
            controlAffinity: ListTileControlAffinity.trailing,
          ),
          Divider(
            color: Theme.of(context).accentColor.withOpacity(0.8),
            thickness: 2,
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    DexterTheme d = Provider.of<DexterTheme>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Picker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 30,
        ),
        child: Column(
          children: _buildThemeRadioTiles(d),
        ),
      ),
    );
  }
}
