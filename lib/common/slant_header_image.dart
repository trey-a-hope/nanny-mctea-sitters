import 'package:flutter/material.dart';

class SlantHeaderImage extends StatelessWidget {
  const SlantHeaderImage({@required this.image});

  final Image image;


  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: image,
      clipper: BottomSlantClipper(),
    );
  }
}

class BottomSlantClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height - 0);
    path.lineTo(size.width, size.height - 100);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
