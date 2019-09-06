import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ProfilePage extends StatefulWidget {
  final String id;

  ProfilePage(this.id);

  @override
  State createState() => ProfilePageState(this.id);
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final String id;
  bool _isLoading = true;

  ProfilePageState(this.id);

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Builder(
        builder: (context) => _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Text(this.id),
              ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('MY PROFILE'),
      centerTitle: true,
    );
  }
}
