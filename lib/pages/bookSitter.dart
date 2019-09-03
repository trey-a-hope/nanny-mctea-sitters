import 'package:flutter/material.dart';

class BookSitterPage extends StatefulWidget {
  @override
  State createState() => BookSitterPageState();
}

class BookSitterPageState extends State<BookSitterPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: Center(
        child: Text(''),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'BOOK A SITTER',
        style: TextStyle(letterSpacing: 2.0),
      ),
    );
  }
}
