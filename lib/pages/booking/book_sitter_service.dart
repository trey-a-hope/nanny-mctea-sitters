import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/common/book_sitter_tile_widget.dart';
import 'package:nanny_mctea_sitters_flutter/common/job_posting_widget.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/pages/booking/book_sitter_calendar.dart';

import '../../constants.dart';

class BookSitterServicePage extends StatefulWidget {
  @override
  State createState() => BookSitterServicePageState();
}

class BookSitterServicePageState extends State<BookSitterServicePage> {
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: childCareServices.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return childCareServices[index];
              },
            ),
            ListView.builder(
              itemCount: feesRegistration.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return feesRegistration[index];
              },
            ),
            ListView.builder(
              itemCount: monthlySitterMembership.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return monthlySitterMembership[index];
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      bottom: TabBar(
        tabs: [
          Tab(
            child: Text(
              'Child Care Service',
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
              child: Text(
            'Fees & Registration',
            textAlign: TextAlign.center,
          )),
          Tab(
              child: Text(
            'Monthly Sitter Membership',
            textAlign: TextAlign.center,
          )),
        ],
      ),
      title: Text('BOOK A SITTER'),
      centerTitle: true,
    );
  }
}
