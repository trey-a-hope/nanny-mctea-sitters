import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:nanny_mctea_sitters_flutter/services/url_launcher.dart';

class SitterServicesPage extends StatefulWidget {
  @override
  State createState() => SitterServicesPageState();
}

class SitterServicesPageState extends State<SitterServicesPage>
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
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
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
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Sitter Services',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'We’ve Got You Covered',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Everyone doesn\'t need a nanny, sometimes you just need a break to breath, relax, go to the store, go on a date, even take a nap. Whatever the reason we are prepared. Nanny McTea Sitters offers a variety of sitter services, all available for your family.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '1. Planned Sitter Service -- This service you can book directly on our website under the book us tab! This service is for planned events like your cousins wedding or your anniversary, anything that you know the date prior to. A  non refundable \$25 booking fee is required to secure your date in advance. The day of your sit you are required to pay your sitter \$13 per hour. We have a 4 hour minimum.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '2. Last Minute Sitter Service -- A last minute is a sit scheduled within 36 hours of its start time. For this service you must fill out the Last Minute Sitter Request form found at the bottom of the page. We will receive your information and call promptly to confirm your request. Once request is confirmed we will dial out to our sitters. If a sitter is available you will pay that sitter \$17 per hour the day of the sit and charged a \$35 booking fee.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '3. Sick Care Service  --  For this service you must fill out the  Last Minute Sitter Request form found at the bottom of the page. We will receive your information and call promptly to confirm your request. Once request is confirmed we will dial out to our sitters. If a sitter is available you will pay that sitter \$17 per hour the day of the sit and charged a \$35 booking fee.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '4. Monthly Sitter Membership --  This awesome service helps eliminate the booking fee for the above mentioned planned sitter service. If you know you are consistently going to be receiving care you\'ll want to book the membership. This membership guarantee you unlimited week nights after 5 and unlimited weekend sits. You\'ll pay a monthly fee of \$100 and pay your sitter their hourly rate of \$13 whenever you use them. ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text(''),
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
        color: Colors.redAccent,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                MdiIcons.faceAgent,
                color: Colors.white,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                'LAST MINUTE/SICK CARE SITTER REQUEST',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
