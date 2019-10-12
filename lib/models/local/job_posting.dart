import 'package:flutter/material.dart';

class JobPosting {
  String title;
  String description;
  String url;
  DateTime posted;
  String imgUrl;

  JobPosting(
      {@required String title,
      @required String description,
      @required String url,
      @required DateTime posted, 
      @required String imgUrl}) {
    this.title = title;
    this.description = description;
    this.url = url;
    this.posted = posted;
    this.imgUrl = imgUrl;
  }
}
