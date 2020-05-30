import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/contact/ContactPage.dart';
import 'package:nanny_mctea_sitters_flutter/common/nav_drawer.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/clipper_wavy.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/pages/services/professional_nannies.dart';
import 'package:nanny_mctea_sitters_flutter/pages/services/event_services.dart';
import 'package:nanny_mctea_sitters_flutter/pages/services/sitter_services.dart';
import 'package:nanny_mctea_sitters_flutter/pages/sitter_details.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:nanny_mctea_sitters_flutter/common/sitter_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Bloc.dart' as homeBloc;
import 'package:nanny_mctea_sitters_flutter/blocs/contact/Bloc.dart'
    as contactBloc;

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  final TextStyle _headLineStyle =
      TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold);
  final TextStyle _bodyStyle = TextStyle(color: Colors.black, fontSize: 20);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      floatingActionButton: FloatingActionButton(
        elevation: Theme.of(context).floatingActionButtonTheme.elevation,
        backgroundColor: Colors.blue,
        child: Icon(Icons.arrow_upward, color: Colors.white),
        onPressed: () {
          _scrollController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: Duration(milliseconds: 300),
          );
        },
      ),
      body: BlocConsumer<homeBloc.HomeBloc, homeBloc.HomeState>(
        listener: (BuildContext context, homeBloc.HomeState state) {},
        builder: (BuildContext context, homeBloc.HomeState state) {
          if (state is homeBloc.LoadingState) {
            return Spinner();
          } else if (state is homeBloc.LoadedState) {
            return ListView(
              controller: _scrollController,
              padding: EdgeInsets.only(top: 0),
              children: <Widget>[
                Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    ClipPath(
                      clipper: DiagonalPathClipperTwo(),
                      child: Container(
                        height: 400,
                        color: Colors.blue,
                      ),
                    ),
                    SimpleNavbar(
                      leftWidget: Icon(MdiIcons.menu, color: Colors.white),
                      leftTap: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                      rightWidget: Icon(MdiIcons.phone, color: Colors.white),
                      rightTap: () {
                        Route route = MaterialPageRoute(
                          builder: (BuildContext context) => BlocProvider(
                            create: (BuildContext context) =>
                                contactBloc.ContactBloc(),
                            child: ContactPage(),
                          ),
                        );
                        Navigator.push(context, route);
                      },
                    ),
                    Positioned(
                      top: 200,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2.0,
                                  blurRadius: 4.0,
                                  color: Colors.grey)
                            ],
                            border: Border.all(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 5.0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                            image: DecorationImage(
                              image: asImgGroup_nannies,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 32,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Nanny McTea Sitters',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Sitting made simple.',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'About',
                        style: _headLineStyle,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'It shouldn’t be difficult to find capable, reliable and trustworthy childcare. That\'s what I said when I started Nanny McTea Sitters. Drawing on my own personal nanny experiences as well the other experiences of professional nannies within our team, we established a full child care agency that ensures rigorous screening and customized matching. With years of collective experience in childcare, We\'ve learned what families want and are proud to share this with you.',
                    style: _bodyStyle,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ClipperWavy(
                  child: imgPikeStreet,
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Row(
                    children: <Widget>[Text('Services', style: _headLineStyle)],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Event Services',
                        style: _bodyStyle,
                      ),
                      RaisedButton(
                        color: Theme.of(context).buttonColor,
                        child: Text(
                          'Read More',
                          // style: Theme.of(context).accentTextTheme.button,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventServicesPage(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Sitter Services',
                        style: _bodyStyle,
                      ),
                      RaisedButton(
                        color: Theme.of(context).buttonColor,
                        child: Text(
                          'Read More',
                          // style: Theme.of(context).accentTextTheme.button,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SitterServicesPage(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Professional Nannies',
                        style: _bodyStyle,
                      ),
                      RaisedButton(
                        color: Theme.of(context).buttonColor,
                        child: Text(
                          'Read More',
                          // style: Theme.of(context).accentTextTheme.button,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfessionalNanniesPage(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ClipperWavy(child: imgGroup),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Row(
                    children: <Widget>[
                      Text('Meet The Team', style: _headLineStyle)
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: state.sitters.map(
                      (sitter) {
                        return InkWell(
                          child: SitterWidget(
                            sitter: sitter,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SitterDetailsPage(
                                  sitter,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),
                SizedBox(height: 40),
                ClipperWavy(child: imgDispicableMe),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Row(
                    children: <Widget>[Text('Reviews', style: _headLineStyle)],
                  ),
                ),
                //Review 1
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              '\"I cannot say enough about Nanny McTea and the fantastic caregivers here! We have someone that we trust who loves our kiddo, takes care in planning fun activities, provides guidance for listening skills, and is available on date nights as well.\"',
                          style: _bodyStyle,
                        ),
                        TextSpan(text: '\n\n'),
                        TextSpan(text: '~Morales Family', style: _bodyStyle),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Divider(),
                SizedBox(height: 30),
                //Review 2
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              '\"We loved Nanny McTea! We had just moved to the area and were in a pinch. She came prepared! She had felt books for my 1 year old and made slime with my 3.5 year old! I love how she focuses on learning and activities rather than screen time! That was only my 2nd time my kids have had a sitter other than family and and they loved her even my emotional 1 year old! Would recommend to anyone!\"',
                          style: _bodyStyle,
                        ),
                        TextSpan(text: '\n\n'),
                        TextSpan(text: '~Cady  Family', style: _bodyStyle),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Divider(),
                SizedBox(height: 30),

                //Review 3
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              '\"Love how easy it is to book and set up a caregiver with set prices for a set time.  Very Easy to work with, great caregivers!\"',
                          style: _bodyStyle,
                        ),
                        TextSpan(text: '\n\n'),
                        TextSpan(text: '~Eavenson Family', style: _bodyStyle),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),

                ClipperWavy(child: imgQueenCity),

                Padding(
                  padding: EdgeInsets.all(30),
                  child: Row(
                    children: <Widget>[
                      Text('Social Media', style: _headLineStyle)
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: InkWell(
                        child: Icon(
                          MdiIcons.facebook,
                          color: Colors.red,
                        ),
                        onTap: () async {
                          String url = 'https://www.facebook.com/nannymctea';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: InkWell(
                        child: Icon(
                          MdiIcons.instagram,
                          color: Colors.red,
                        ),
                        onTap: () async {
                          String url =
                              'https://www.instagram.com/nannymcteasitters';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    )
                  ],
                )
              ],
            );
          } else if (state is homeBloc.ErrorState) {
            return Center(child: Text('Error: ${state.error.toString()}'));
          } else {
            return Center(
              child: Text('You should NEVER see this.'),
            );
          }
        },
      ),
    );
  }
}
