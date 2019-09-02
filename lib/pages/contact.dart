import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  @override
  State createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage>
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
        'CONTACT US',
        style: TextStyle(letterSpacing: 2.0),
      ),
    );
  }
}
