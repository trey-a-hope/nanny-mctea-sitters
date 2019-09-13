import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: Center(
        child: Text('Test'),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('EDIT PROFILE'),
      centerTitle: true,
    );
  }
}
