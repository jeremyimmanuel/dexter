import 'package:flutter/material.dart';

import '../pages/theme_picker.dart';
import '../pages/category_page.dart';
import '../pages/about.dart';

/// App Drawer for Dexter
///
/// Adaptively builds left or right version
/// of app drawer
class AppDrawer extends StatelessWidget {
  // Left version of app drawer (Default)
  const AppDrawer({
    Key key,
    this.isRight = false,
  }) : super(key: key);

  // Right version of app drawer
  const AppDrawer.right({
    Key key,
    this.isRight = true,
  });

  final bool isRight;

  // Build menu items for app drawer
  List<Widget> _buildMenuItems(BuildContext context, bool isRight) {
    const homeIcon = Icon(Icons.home);
    const settingsIcon = Icon(Icons.format_paint);
    const addIcon = Icon(Icons.add);
    return [
      // Home (Tasks)
      ListTile(
        leading: isRight ? homeIcon : null,
        title: Text(
          'Home',
          textAlign: isRight ? TextAlign.start : TextAlign.end,
          style:
              Theme.of(context).textTheme.subtitle.copyWith(fontFamily: 'Muli'),
        ),
        trailing: !isRight ? homeIcon : null,
        onTap: () => Navigator.of(context).pop(),
      ),
      // Theme Picker
      ListTile(
        leading: isRight ? settingsIcon : null,
        title: Text(
          'Theme',
          textAlign: isRight ? TextAlign.start : TextAlign.end,
          style:
              Theme.of(context).textTheme.subtitle.copyWith(fontFamily: 'Muli'),
        ),
        trailing: !isRight ? settingsIcon : null,
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(ThemePicker.routeName);
        },
      ),
      // Categories
      ListTile(
        leading: isRight ? addIcon : null,
        title: Text(
          'Categories',
          textAlign: isRight ? TextAlign.start : TextAlign.end,
          style:
              Theme.of(context).textTheme.subtitle.copyWith(fontFamily: 'Muli'),
        ),
        trailing: !isRight ? addIcon : null,
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(CategoryPage.routeName);
        },
      ),
    ];
  }

  // Build App Drawer Header
  Widget _buildHeader(BuildContext context, bool isRight) {
    return DrawerHeader(
      child: Align(
        alignment: isRight ? Alignment.bottomLeft : Alignment.bottomRight,
        child: Text(
          'Dexter',
          style: Theme.of(context).appBarTheme.textTheme.title,
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  _buildHeader(context, isRight),
                  Divider(thickness: 10),
                  ..._buildMenuItems(context, isRight),
                ],
              ),
            ),
            Container(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ListTile(
                  leading: isRight ? Icon(Icons.info) : null,
                  title: Text(
                    'About',
                    textAlign: isRight ? TextAlign.start : TextAlign.end,
                    style: Theme.of(context).textTheme.subtitle.copyWith(
                          fontFamily: 'Muli',
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  trailing: !isRight ? Icon(Icons.info) : null,
                  onTap: () =>
                      Navigator.of(context).pushNamed(AboutPage.routeName),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
