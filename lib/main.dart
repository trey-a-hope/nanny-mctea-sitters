import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanny_mctea_sitters_flutter/pages/home.dart';

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
        accentColor: Colors.green,
        primaryColor: Colors.greenAccent,
        fontFamily: 'SourceSansPro',
        textTheme: TextTheme(
          // headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          // title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          // body1: TextStyle(fontSize: 14.0),
          // subhead: TextStyle(color: Colors.black, fontSize: 16),
          // caption: TextStyle(color: Colors.white, fontSize: 30)
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.red
        )
      ),
      home: HomePage(),
    );
  }
}
