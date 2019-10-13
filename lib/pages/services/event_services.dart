import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/services/url_launcher.dart';

class EventServicesPage extends StatefulWidget {
  @override
  State createState() => EventServicesPageState();
}

class EventServicesPageState extends State<EventServicesPage> {
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
                        }),
                    title: 'Event Services',
                    subtitle: '',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: asImgGroup_nannies,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Nanny McTea Sitters  provides a fun-filled atmosphere for  kids and teens so that you can party in peace! From small event sitting to groups, our  sitters provide an amazing experience.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Having an adult-only event but don\'t want to tell your guests that they can\'t bring the kids or do you need some help planning your childs birthday party?  Our "Kids Party" is THE solution to your dilemma. Our professional and fun loving sitters know how to get the party started and keep the kids engaged all night long.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'We travel to any venue in the tri state area to provide your guest with professional on - site childcare. We understand that every event is unique,  so our  Kids Party Packages can be customized and quotes are based on the number of children in attendance and hours of service needed.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Packages can include any of the following: YARN ACTIVITIES, AGE APPROPRIATE MOVIES/TV, BRACELET MAKING, CUPCAKE DECORATIN, COOKIE DECORATING, VIDEO GAMES, BUBBLE STATION, CANVAS PAINTINGS, PLAY DOH STATION, KID\'S PHOTO BOTH/TAKE HOME POLAROIDS, SLIME STATION, CRAFT STATION',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Please fill out the request form below and someone will be in touch. We request a non refundable \$150 deposit to secure your date.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20)
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        onPressed: () {
          URLLauncher.launchUrl(
              'https://docs.google.com/forms/d/e/1FAIpQLSdAMrVxgoEDLzcfy-hC9X3h_HNsGVYzXCPubTB-5sssB4BAjA/viewform');
        },
        color: Theme.of(context).buttonColor,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                MdiIcons.faceAgent,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                'KIDS PARTY REQUEST FORM',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
