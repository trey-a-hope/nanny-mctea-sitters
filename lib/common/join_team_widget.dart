import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/sitter.dart';
import 'package:nanny_mctea_sitters_flutter/services/url_launcher.dart';

import '../style/text.dart';

class JoinTeamWidget extends StatelessWidget {
  final AssetImage image;
  final String title;
  final String posted;
  final String description;
  // final String url;

  const JoinTeamWidget({Key key, @required this.image, @required this.title, @required this.posted, @required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(image: image, fit: BoxFit.cover)),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text(title), Text(posted)],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
                description),
          ),
          SizedBox(height: 20),
          MaterialButton(
            color: Colors.blue,
            child: Text('Apply Now', style: TextStyle(color: Colors.white),),
            onPressed: () {
              URLLauncher.launchUrl('https://docs.google.com/forms/d/e/1FAIpQLScLt5e0c-tGlMdFw9ALAMuDpYKKgKs0W_1DGVnxhZ351gDbwA/viewform?usp=sf_link');
            },
          )
        ],
      ),
    );
  }
}
