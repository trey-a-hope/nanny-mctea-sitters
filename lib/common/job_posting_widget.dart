import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanny_mctea_sitters_flutter/models/sitter.dart';
import 'package:nanny_mctea_sitters_flutter/services/url_launcher.dart';

import '../style/text.dart';

class JobPostingWidget extends StatelessWidget {
  final String imgUrl;
  final String title;
  final DateTime posted;
  final String description;

  final String timeFormat = 'MMM d, yyyy';

  const JobPostingWidget(
      {Key key,
      @required this.imgUrl,
      @required this.title,
      @required this.posted,
      @required this.description})
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
              image: DecorationImage(image: CachedNetworkImageProvider(imgUrl), fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title),
                Text(
                  DateFormat(timeFormat).format(posted),
                )
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              description,
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
          MaterialButton(
            color: Colors.blue,
            child: Text(
              'APPLY NOW',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              URLLauncher.launchUrl(
                  'https://docs.google.com/forms/d/e/1FAIpQLScLt5e0c-tGlMdFw9ALAMuDpYKKgKs0W_1DGVnxhZ351gDbwA/viewform?usp=sf_link');
            },
          )
        ],
      ),
    );
  }
}
