import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class BlogPage extends StatefulWidget {

  BlogPage();

  @override
  State createState() => BlogPageState();
}

class BlogPageState extends State<BlogPage>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLOG'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('Blog Posts Go Here.')
          ],
        ),
      ),
    );
  }
}
