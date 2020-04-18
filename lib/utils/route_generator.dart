import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/theme_picker.dart';
import '../pages/new_category.dart';
import '../pages/about.dart';
import '../pages/category_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;
    
    switch (settings.name) {
      case HomePage.routeName:
        return MaterialPageRoute(builder: (ctx) => HomePage());
      case (ThemePicker.routeName):
        return MaterialPageRoute(builder: (ctx) => ThemePicker());
      case (NewCategory.routeName):
        if (args == null)
          return MaterialPageRoute(builder: (ctx) => NewCategory());
        else {
          final cat = (args as Map)['category'];
          return MaterialPageRoute(builder: (ctx) => NewCategory(cat: cat));
        }
        break;
      case (AboutPage.routeName):
        return MaterialPageRoute(builder: (ctx) => AboutPage());
      case (CategoryPage.routeName):
        return MaterialPageRoute(builder: (ctx) => CategoryPage());
      default:
        return MaterialPageRoute(builder: (ctx) => HomePage());
    }
  }
}