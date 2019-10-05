import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';

class SitterWidget extends StatelessWidget {
  final User sitter;

  const SitterWidget({Key key, @required this.sitter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 250,
                width: 150,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 1.0,
                      blurRadius: 4.0,
                      color: Colors.grey
                    )
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  image:
                      DecorationImage(image: CachedNetworkImageProvider(sitter.imgUrl), fit: BoxFit.cover),
                ),
              ),
              Container(
                height: 250,
                width: 150,
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
          Positioned(
              left: 10,
              bottom: 10,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: sitter.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                  TextSpan(text: '\n'),
                  TextSpan(text: sitter.details)
                ]),
              )
              )
        ],
      ),
    );
  }
}
