import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanny_mctea_sitters_flutter/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nanny McTea Sitters',
      theme: ThemeData(
        brightness: Brightness.light,
        accentColor: Colors.blue,
        primaryColor: Colors.blueAccent,
        fontFamily: 'Montserrat',
      ),
      home: HomePage(),
    );
  }
}
