import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/drawer_widget.dart';
import 'package:nanny_mctea_sitters_flutter/common/content_heading_widget.dart';
import 'package:nanny_mctea_sitters_flutter/common/photo_widget.dart';
import 'package:nanny_mctea_sitters_flutter/pages/professional_nannies.dart';
import 'package:nanny_mctea_sitters_flutter/pages/sitter_services.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/pages/event_services.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:nanny_mctea_sitters_flutter/common/sitter_widget.dart';
import 'package:nanny_mctea_sitters_flutter/common/review_widget.dart';
import 'package:nanny_mctea_sitters_flutter/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nanny_mctea_sitters_flutter/services/url_launcher.dart';
import 'package:nanny_mctea_sitters_flutter/style/text.dart';

import 'contact.dart';

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
            : ListView(
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
                  _buildAboutWidget(),
                  Divider(),
                  ContentHeadingWidget(
                    heading: 'Services',
                  ),
                  _buildServicesWidget(),
                  SizedBox(height: 20),
                  Divider(),
                  ContentHeadingWidget(
                    heading: 'Meet the Team',
                  ),
                  _buildTeamWidget(),
                  ContentHeadingWidget(
                    heading: 'Photos',
                  ),
                  _buildPhotosWidget(),
                  ContentHeadingWidget(
                    heading: 'Reviews',
                  ),
                  _buildReviewsWidget(),
                  ContentHeadingWidget(
                    heading: 'Social Media',
                  ),
                  _buildSocialMedias()
                ],
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
        IconButton(
          icon: Icon(MdiIcons.email),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactPage(),
              ),
            );
          },
        )
      ],
    );
  }

  _buildServicesWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              child: Container(
                child: Center(
                  child: Text(
                    'Event Services',
                    style: serviceButtonStyle,
                  ),
                ),
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[800], Colors.green[400]],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, 1],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventServicesPage(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              child: Container(
                child: Center(
                  child: Text(
                    'Sitter Services',
                    style: serviceButtonStyle,
                  ),
                ),
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[800], Colors.blue[400]],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, 1],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SitterServicesPage(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              child: Container(
                child: Center(
                  child: Text(
                    'Professinal Nannies',
                    style: serviceButtonStyle,
                  ),
                ),
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple[800], Colors.purple[400]],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, 1],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfessionalNanniesPage(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  _buildReviewsWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (var i = 0; i < reviews.length; i++)
            InkWell(
              child: ReviewWidget(
                review: reviews[i].review,
                author: reviews[i].author,
              ),
              onTap: () {
                Modal.showInSnackBar(
                    _scaffoldKey, 'Clicked ' + sitters[i].name);
              },
            )
        ],
      ),
    );
  }

  _buildTeamWidget() {
    return SingleChildScrollView(
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
    );
  }

  _buildAboutWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        about,
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
    );
  }

  _buildPhotosWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (var i = 0; i < images.length; i++)
            InkWell(
              child: PhotoWidget(
                title: 'Test',
                image: images[i],
              ),
              onTap: () {
                Modal.showInSnackBar(
                    _scaffoldKey, 'Clicked ' + sitters[i].name);
              },
            )
        ],
      ),
    );
  }

  _buildSocialMedias() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(30),
          child: InkWell(
            child: Icon(MdiIcons.facebook),
            onTap: () {
              URLLauncher.launchUrl('https://www.facebook.com/nannymctea/');
            },
          ),
        )
      ],
    );
  }
}
