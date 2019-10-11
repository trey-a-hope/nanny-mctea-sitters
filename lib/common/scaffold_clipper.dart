import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';

class ScaffoldClipper extends StatelessWidget {
  ScaffoldClipper(
      {@required this.simpleNavbar,
      @required this.title,
      @required this.subtitle});
  final SimpleNavbar simpleNavbar;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        ClipPath(
          clipper: WaveClipperOne(),
          child: Container(
            height: 200,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            // child: Center(
            //   child: Text("SideCutClipper()"),
            // ),
          ),
        ),
        simpleNavbar,
        Positioned(
          top: 90,
          left: 32,
          right: 0,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: Theme.of(context).accentTextTheme.headline,
                ),
                TextSpan(
                  text: '\n',
                ),
                TextSpan(
                  text: subtitle,
                  style: Theme.of(context).accentTextTheme.body1,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
