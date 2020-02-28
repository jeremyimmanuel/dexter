import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import './utils/theme.dart';
import './pages/home_page.dart';
import './models/task.dart';
import './models/category.dart';
import './utils/route_generator.dart';

const DEFAULT_CATEGORIES = ['Home', 'Work', 'Family', 'Other'];

/// Make default Categories
///
/// 1. Home
/// 2. Work
/// 3. Family
/// 4. Other
List<Category> _makeDefaultCategories() {
  Category home = Category(
    name: 'Home',
    colorVal: Colors.blue.value,
  );
  Category work = Category(
    name: 'Work',
    colorVal: Colors.red.value,
  );
  Category family = Category(
    name: 'Family',
    colorVal: Colors.green.value,
  );
  Category other = Category(
    name: 'Other',
    colorVal: Colors.black.value,
  );
  return [home, work, family, other];
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(CategoryAdapter());

  // Open Boxes
  await Hive.openBox(Task.boxName);
  await Hive.openBox(Category.boxName, compactionStrategy: (entries, deleted) {
    return deleted > 5;
  });
  await Hive.openBox('settings');

  // Put Default Category values
  final catBox = Hive.box(Category.boxName);
  final defaultCategories = _makeDefaultCategories();
  for (Category cat in defaultCategories) {
    catBox.put(cat.name, cat);
  }
  runApp(Dexter());
}

class Dexter extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _DexterState createState() => _DexterState();
}

class _DexterState extends State<Dexter> {
  @override
  void dispose() {
    Hive.box(Task.boxName).compact();
    Hive.box(Category.boxName).compact();
    Hive.box('settings');
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Hive.box('settings').get('theme') ?? 0;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DexterTheme(selected: currTheme)),
      ],
      child: Consumer<DexterTheme>(
        builder: (context, dt, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: dt.theme,
            onGenerateRoute: RouteGenerator.generateRoute,
            home: FutureBuilder(
              future: Hive.openBox(
                Task.boxName,
                compactionStrategy: (entries, deleted) {
                  return deleted > 10;
                },
              ),
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError)
                    return Text(snapshot.error.toString());
                  else
                    return HomePage();
                } else {
                  return CupertinoActivityIndicator();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
