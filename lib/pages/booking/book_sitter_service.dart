import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/book_sitter_tile_widget.dart';
import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';

class BookSitterServicePage extends StatefulWidget {
  @override
  State createState() => BookSitterServicePageState();
}

class BookSitterServicePageState extends State<BookSitterServicePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  int selectedIndex = 0;

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isLoading
          ? Spinner()
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ScaffoldClipper(
                    simpleNavbar: SimpleNavbar(
                      leftWidget:
                          Icon(MdiIcons.chevronLeft, color: Colors.white),
                      leftTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    title: 'Book Sitter',
                    subtitle: 'Select a service.',
                  ),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          RaisedButton(
                            child: Text('Child Care Service'),
                            onPressed: () {
                              setState(
                                () {
                                  selectedIndex = 0;
                                },
                              );
                            },
                          ),
                          SizedBox(width: 20),
                          RaisedButton(
                            child: Text('Fees & Registration'),
                            onPressed: () {
                              setState(
                                () {
                                  selectedIndex = 1;
                                },
                              );
                            },
                          ),
                          SizedBox(width: 20),
                          RaisedButton(
                            child: Text('Monthly Sitter Membership'),
                            onPressed: () {
                              setState(
                                () {
                                  selectedIndex = 2;
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  selectedIndex == 0
                      ? Text('Child Care Service',
                          style: Theme.of(context).primaryTextTheme.title)
                      : selectedIndex == 1
                          ? Text('Fees & Registration',
                              style: Theme.of(context).primaryTextTheme.title)
                          : Text('Monthly Sitter Membership',
                              style: Theme.of(context).primaryTextTheme.title),
                  selectedIndex == 0
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: childCareServices.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return childCareServices[index];
                          },
                        )
                      : selectedIndex == 1
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: feesRegistration.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return feesRegistration[index];
                              },
                            )
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: monthlySitterMembership.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return monthlySitterMembership[index];
                              },
                            )
                ],
              ),
            ),
    );
    // return DefaultTabController(
    //   length: 3,
    //   child: Scaffold(
    //     key: _scaffoldKey,
    //     appBar: _buildAppBar(),
    //     body: TabBarView(
    //       children: [
    //         ListView.builder(
    //           itemCount: childCareServices.length,
    //           itemBuilder: (BuildContext ctxt, int index) {
    //             return childCareServices[index];
    //           },
    //         ),
    //         ListView.builder(
    //           itemCount: feesRegistration.length,
    //           itemBuilder: (BuildContext ctxt, int index) {
    //             return feesRegistration[index];
    //           },
    //         ),
    //         ListView.builder(
    //           itemCount: monthlySitterMembership.length,
    //           itemBuilder: (BuildContext ctxt, int index) {
    //             return monthlySitterMembership[index];
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  // _buildAppBar() {
  //   return AppBar(
  //     bottom: TabBar(
  //       tabs: [
  //         Tab(
  //           child: Text(
  //             'Child Care Service',
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //         Tab(
  //           child: Text(
  //             'Fees & Registration',
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //         Tab(
  //           child: Text(
  //             'Monthly Sitter Membership',
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //       ],
  //     ),
  //     title: Text(
  //       'BOOK A SITTER',
  //       style: TextStyle(color: Colors.white),
  //     ),
  //     centerTitle: true,
  //   );
  // }
}
