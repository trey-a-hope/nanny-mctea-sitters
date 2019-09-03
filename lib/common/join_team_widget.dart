import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/sitter.dart';
import 'package:nanny_mctea_sitters_flutter/services/urlLauncher.dart';

import '../style/text.dart';

class JoinTeamWidget extends StatelessWidget {
  final AssetImage image;
  final String title;
  // final String posted;
  // final String text;
  // final String url;

  const JoinTeamWidget({Key key, @required this.image, @required this.title})
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
              children: <Widget>[Text(title), Text('Aug 3rd, 2019')],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
                'Norwood / Montgomery families seeking Full Time long term nanny to join the team.  Families are seeking fun, reliable nanny.  Care will take place in host families home in Montgomery with 2 sometimes 3 infants. Hours are 7:30 am - 5:30 pm. Pay starts at \$15/hr'),
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