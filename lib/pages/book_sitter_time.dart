import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/book_sitter_tile_widget.dart';
import 'package:nanny_mctea_sitters_flutter/common/join_team_widget.dart';
import 'package:nanny_mctea_sitters_flutter/pages/book_sitter_sitter.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/pages/book_sitter_calendar.dart';

import '../constants.dart';

class BookSitterTimePage extends StatefulWidget {
  final List<dynamic> _slots;

  BookSitterTimePage(this._slots);

  @override
  State createState() => BookSitterTimePageState(this._slots);
}

class BookSitterTimePageState extends State<BookSitterTimePage>
    with SingleTickerProviderStateMixin {
  final List<dynamic> _slots;

  BookSitterTimePageState(this._slots);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  dynamic _selected;

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _slots.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return _buildSlot(
                  _slots[index],
                );
              },
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Container _buildBottomNavigationBar() {
    return _selected == null ? Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        onPressed: () {
        },
        color: Colors.grey.shade200,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                MdiIcons.faceAgent,
                color: Colors.black,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                'PICK A TIME',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    ): Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookSitterSitterPage(),
            ),
          );
        },
        color: Colors.grey.shade200,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                MdiIcons.faceAgent,
                color: Colors.black,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                'PICK A SITTER',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text('PICK A TIME'),
      centerTitle: true,
    );
  }

  Widget _buildSlot(dynamic slot) {
    return InkWell(
      child: ListTile(
        title: Text(
          slot.toString(),
        ),
        leading: CircleAvatar(
          child: _selected == slot ? Icon(Icons.check) : Icon(Icons.close),
        ),
      ),
      onTap: () {
        setState(
          () {
            _selected = slot;
          },
        );
      },
    );
    // return Container(
    //   decoration: BoxDecoration(
    //     border: Border.all(width: 0.8),
    //     borderRadius: BorderRadius.circular(12.0),
    //   ),
    //   margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    //   child: ListTile(
    //     title: Text(
    //       slot.toString(),
    //     ),
    //   ),
    // );
  }
}
