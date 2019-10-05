import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:nanny_mctea_sitters_flutter/pages/home_page.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/card.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/charge.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/customer.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/subscriptions.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/token.dart';

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

final String _testSecretKey =
    'sk_test_IM9ti8gurtw7BjCPCtm9hRar'; //THIS IS SCORBORDS!
final String _testPublishableKey = '?';
final String _liveSecretKey = '?';
final String _livePublishableKey = '?';
final String _endpoint =
    'https://us-central1-hidden-gems-e481d.cloudfunctions.net/';

void main() {
  //Register services.
  getIt.registerSingleton<StripeCard>(
      StripeCardImplementation(apiKey: _testSecretKey, endpoint: _endpoint),
      signalsReady: true);
  getIt.registerSingleton<StripeCharge>(
      StripeChargeImplementation(apiKey: _testSecretKey, endpoint: _endpoint),
      signalsReady: true);
  getIt.registerSingleton<StripeCustomer>(
      StripeCustomerImplementation(apiKey: _testSecretKey, endpoint: _endpoint),
      signalsReady: true);
  getIt.registerSingleton<StripeSubscription>(
      StripeSubscriptionImplementation(
          apiKey: _testSecretKey, endpoint: _endpoint),
      signalsReady: true);
  getIt.registerSingleton<StripeToken>(
      StripeTokenImplementation(apiKey: _testSecretKey, endpoint: _endpoint),
      signalsReady: true);

  runApp(MyApp());
}

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
        accentColor: Colors.yellow[50],
        accentIconTheme: IconThemeData(color: Colors.white),
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
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue, elevation: 4.0),
        primaryColor: Colors.blue,
        primaryIconTheme: IconThemeData(color: Colors.red[700]),
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
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.amber, textTheme: ButtonTextTheme.normal),
        buttonColor: Colors.red,
      ),
      home: HomePage(),
    );
  }
}
