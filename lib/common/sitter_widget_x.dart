import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';

import '../style/text.dart';

class SitterWidgetX extends StatelessWidget {
  final Sitter sitter;

  const SitterWidgetX({Key key, @required this.sitter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 200,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  image:
                      DecorationImage(image: CachedNetworkImageProvider(sitter.imgUrl), fit: BoxFit.cover),
                ),
              ),
              Container(
                height: 200,
                width: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 1],
                    colors: [
                      Colors.white.withOpacity(0),
                      Colors.black.withOpacity(0.4)
                    ]
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
