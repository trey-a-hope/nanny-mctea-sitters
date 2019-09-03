import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nanny_mctea_sitters_flutter/common/drawer_widget.dart';
import 'package:nanny_mctea_sitters_flutter/common/content_heading_widget.dart';
import 'package:nanny_mctea_sitters_flutter/common/photo_widget.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';

import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:nanny_mctea_sitters_flutter/common/sitter_widget.dart';
import 'package:nanny_mctea_sitters_flutter/common/review_widget.dart';
import 'package:nanny_mctea_sitters_flutter/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final _db = Firestore.instance;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    loadPage();
  }

  void loadPage() async {
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
      drawer: DrawerWidget(),
      body: Builder(
        builder: (context) => _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: group_nannies,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Nanny McTea Sitters',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    ContentHeadingWidget(
                      heading: 'About',
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Material(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(about,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                      ),
                    ),
                    ContentHeadingWidget(
                      heading: 'Meet the Team',
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          for (var i = 0; i < sitters.length; i++)
                            InkWell(
                              child: SitterWidget(
                                sitter: sitters[i],
                              ),
                              onTap: () {
                                Modal.showInSnackBar(
                                    _scaffoldKey, 'Clicked ' + sitters[i].name);
                              },
                            )
                        ],
                      ),
                    ),
                    ContentHeadingWidget(
                      heading: 'Photos',
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          for (var i = 0; i < images.length; i++)
                            InkWell(
                              child: PhotoWidget(
                                title: 'Test', image: images[i],
                              ),
                              onTap: () {
                                Modal.showInSnackBar(
                                    _scaffoldKey, 'Clicked ' + sitters[i].name);
                              },
                            )
                        ],
                      ),
                    ),
                    ContentHeadingWidget(
                      heading: 'Reviews',
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          for (var i = 0; i < reviews.length; i++)
                            InkWell(
                              child: ReviewWidget(
                                review: reviews[i].review, author: reviews[i].author,
                              ),
                              onTap: () {
                                Modal.showInSnackBar(
                                    _scaffoldKey, 'Clicked ' + sitters[i].name);
                              },
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Home',
        style: TextStyle(letterSpacing: 2.0),
      ),
      actions: [
        // IconButton(
        //   icon: Icon(Icons.search),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => SearchPage(),
        //       ),
        //     );
        //   },
        // )
      ],
    );
  }
}
