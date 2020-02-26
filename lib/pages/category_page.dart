import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/category.dart';
import '../widgets/category_widget.dart';
import '../pages/new_category.dart';

class CategoryPage extends StatelessWidget {
  static const routeName = '/categories';

  const CategoryPage({Key key}) : super(key: key);

  /// build add tile at the end of the GridView
  Widget _buildAddTile(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(NewCategory.routeName),
      child: const Center(
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(Category.boxName).listenable(),
        builder: (context, Box box, widget) {
          return GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
            ),
            children: [
              ...box.values.toList().map(
                (cat) {
                  return CategoryWidget(
                    key: Key(cat.name),
                    cat: cat,
                  );
                },
              ).toList(),
               _buildAddTile(context),
            ],
          );
        },
      ),
    );
  }
}
