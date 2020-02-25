import 'package:flutter/material.dart';

/// Theme List for this app
/// 
/// 0. Light theme
/// 1. Dark theme
class DexterTheme with ChangeNotifier {
  int selected;

  DexterTheme({this.selected = 0});

  set selectTheme(int newVal){
    if(newVal < 0 || newVal > 1)
      selected = 0;
    selected = newVal;
    notifyListeners();
  }

  ThemeData get theme {
    switch (selected) { 
      case 0:
        return light;
      case 1:
        return dark;
      default:
        return dark;
    }
  }

  ThemeData get light {
    final ThemeData base = ThemeData.light();
    Color mainColor = Colors.white;

    Color dexterColor = Color(0xFF00eaff);
    return base.copyWith(
      // accentColor: Colors.cyan[300],
      
      accentColor: Colors.black,
      primaryColor: mainColor,
      appBarTheme: base.appBarTheme.copyWith(
        color: mainColor,
        textTheme: TextTheme(
          title: TextStyle(
            fontFamily: 'Muli',
            fontWeight: FontWeight.w300,
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        backgroundColor: mainColor,
        elevation: 0,
      ),

      textTheme: base.textTheme.copyWith(
        body1: TextStyle(
          fontFamily: 'Abel',
          fontSize: 20,
          color: Colors.black,
        ),
        subtitle: TextStyle(
          fontFamily: 'Encode Sans',
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        title: TextStyle(
          fontFamily: 'Encode Sans',
          fontSize: 50,
          color: Colors.black,
          fontWeight: FontWeight.w900,
        )
        
      ),
    );
  }

  ThemeData get dark {
    final ThemeData base = ThemeData.dark();
    Color mainColor = base.primaryColor;
    return base.copyWith(
      // accentColor: Colors.cyan[300],
      accentColor: Colors.white,
      primaryColor: mainColor,
      appBarTheme: base.appBarTheme.copyWith(
        color: mainColor,
        textTheme: TextTheme(
          title: TextStyle(
            fontFamily: 'Muli',
            fontWeight: FontWeight.w300,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        elevation: 1,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),

      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        backgroundColor: mainColor,
      ),

      textTheme: base.textTheme.copyWith(
        body1: TextStyle(
          fontFamily: 'Abel',
          fontSize: 20,
          color: Colors.white,
        ),
        subtitle: TextStyle(
          fontFamily: 'San Serif',
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        title: TextStyle(
          fontFamily: 'Encode Sans',
          fontSize: 50,
          color: Colors.white,
          fontWeight: FontWeight.w900,
        )
      ),
    );
  }
}
