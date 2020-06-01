import 'package:flutter/material.dart';

class ResourceModel {
  int id;
  String name;

  ResourceModel({
    @required int id,
    @required String name,
  }) {
    this.id = id;
    this.name = name;
  }

  factory ResourceModel.fromJSON(Map data) {
    return ResourceModel(
      id: data['id'],
      name: data['name'],
    );
  }
}
