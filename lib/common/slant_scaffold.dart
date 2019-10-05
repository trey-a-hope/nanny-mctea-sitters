import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/common/clipper_slant.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';

class SlantScaffold extends StatelessWidget {
  SlantScaffold(
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
        ClipperSlant(
          child: Container(
            height: 250,
            color: Theme.of(context).primaryColor,
          ),
        ),
        simpleNavbar,
        Positioned(
          top: 100,
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

// import 'package:flutter/material.dart';

// class Spinner extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             backgroundColor: Colors.black,
//             strokeWidth: 3.0,
//           ),
//           SizedBox(height: 20),
//           Text(
//             'Loading',
//             style: TextStyle(fontSize: 15.0, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }
