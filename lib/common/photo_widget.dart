import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/sitter.dart';

import '../style/text.dart';

class PhotoWidget extends StatelessWidget {
  final AssetImage image;
  final String title;

  const PhotoWidget({Key key, @required this.image, @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Container(
            height: 200,
            width: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                image: DecorationImage(image: image, fit: BoxFit.cover)),
          ),
          Positioned(
              left: 10,
              bottom: 10,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  // TextSpan(text: '\n'),
                  // TextSpan(text: sitter.info)
                ]),
              ))
        ],
      ),
    );
  }
}
