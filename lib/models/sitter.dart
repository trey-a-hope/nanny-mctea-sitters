import 'package:flutter/rendering.dart';

class Sitter {
  String name;
  String info;
  AssetImage image;

  Sitter(name, info, image){
    this.name = name;
    this.info = info;
    this.image = image;
  }
}