import 'package:flutter/material.dart';

class WavyHeaderImage extends StatelessWidget {
  const WavyHeaderImage({@required this.image});

  final Image image;


  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: image,
      clipper: BottomWaveClipper(),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height - 20);

    Offset firstControlPoint = Offset(size.width / 4, size.height);
    Offset firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    Offset secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    Offset secondEndPoint = Offset(size.width, size.height - 40);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
