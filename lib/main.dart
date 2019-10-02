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
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
        //Light Color
        accentColor: Colors.yellow[50],
        //Dark Color
        primaryColor: Colors.blue,
        //Dark Icon
        primaryIconTheme: IconThemeData(color: Colors.red[700]),
        //Light Icon
        accentIconTheme: IconThemeData(color: Colors.white),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue, elevation: 4.0),
        //Dark Text Theme
        primaryTextTheme: TextTheme(
          body1: TextStyle(color: Colors.black, fontSize: 20),
          body2: TextStyle(color: Colors.black, fontSize: 15),
          button: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          headline: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          display1: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
          subtitle: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          title: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        //Light Text Theme
        accentTextTheme: TextTheme(
          body1: TextStyle(color: Colors.white, fontSize: 20),
          body2: TextStyle(color: Colors.white, fontSize: 15),
          button: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          headline: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          display1: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          subtitle: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          title: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.amber, textTheme: ButtonTextTheme.normal),
        buttonColor: Colors.red,
      ),
      home: HomePage(),
    );
  }
}
