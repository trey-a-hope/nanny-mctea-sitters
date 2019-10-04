import 'package:flutter/material.dart';

class Customer {
  String id;
  String email;
  String default_source;

  Customer({@required this.id, @required this.default_source}){
    id = this.id;
    email = this.email;
    default_source = this.default_source;
  }
}