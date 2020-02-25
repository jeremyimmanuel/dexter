import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category {
  static const boxName = 'categories';
  @HiveField(0)
  String cid;

  @HiveField(1)
  String name;

  @HiveField(2)
  int colorVal;

  Color get color => Color(colorVal);

  double get luminance =>
      (0.299 * color.red +
          0.587 * color.green +
          0.114 * color.blue) /
      255.0;

  Category({
    this.name,
    this.colorVal,
  }) {
    this.cid = DateTime.now().toString();
  }

  


  @override
  bool operator==(other){
    return other is Category && this.name == other.name;
  }

  @override
  int get hashCode {
    return this.name.length;
  }

  
}