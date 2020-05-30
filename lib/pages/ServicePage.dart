import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicePage extends StatelessWidget {
  ServicePage(
      {Key key,
      @required this.serviceTitle,
      @required this.serviceUrl,
      @required this.buttonTitle,
      @required this.paragraphTexts});

  final String serviceTitle;
  final String serviceUrl;
  final String buttonTitle;
  final List<String> paragraphTexts;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //Build paragraph widgets.
    List<Widget> paragraphWidgets = paragraphTexts
        .map(
          (paragraphText) => Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Text(
              paragraphText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        )
        .toList();
        
    return Scaffold(
      appBar: AppBar(
        title: Text(
          serviceTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (await canLaunch(serviceUrl)) {
            await launch(serviceUrl);
          } else {
            throw 'Could not launch $serviceUrl';
          }
        },
        label: Row(
          children: <Widget>[
            Icon(Icons.open_in_browser),
            SizedBox(
              width: 5,
            ),
            Text(
              'Open Form',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
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
          Padding(
            padding: EdgeInsets.all(30),
            child: Column(children: paragraphWidgets),
          ),
        ],
      ),
    );
  }
}
