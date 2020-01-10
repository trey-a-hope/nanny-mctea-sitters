import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:nanny_mctea_sitters_flutter/pages/home_page.dart';
import 'package:nanny_mctea_sitters_flutter/services/auth.dart';
import 'package:nanny_mctea_sitters_flutter/services/db.dart';
import 'package:nanny_mctea_sitters_flutter/services/message.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/services/fcm_notification.dart';
import 'package:nanny_mctea_sitters_flutter/services/package_device_info.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/card.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/charge.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/customer.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/subscriptions.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/token.dart';
import 'package:nanny_mctea_sitters_flutter/services/validator.dart';

// This is our global ServiceLocator
final GetIt getIt = GetIt.instance;

final String _testSecretKey = 'sk_test_5B3wICOi014K7omjGCUpMbAc';
final String _testPublishableKey = 'pk_test_JZxKU5yXf6wdHXOJOWhDWeB8';
final String _liveSecretKey = 'sk_live_78VVUPikPfBgHz1BxLh08zS9';
final String _livePublishableKey = 'pk_live_t9mv71BpBrsCt6oZ8ulDFGfG';
final String _endpoint =
    'https://us-central1-hidden-gems-e481d.cloudfunctions.net/';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //Stripe Card
  getIt.registerSingleton<StripeCard>(
      StripeCardImplementation(apiKey: _testSecretKey, endpoint: _endpoint),
      signalsReady: true);
  //Stripe Charge
  getIt.registerSingleton<StripeCharge>(
      StripeChargeImplementation(apiKey: _testSecretKey, endpoint: _endpoint),
      signalsReady: true);
  //Stripe Customer
  getIt.registerSingleton<StripeCustomer>(
      StripeCustomerImplementation(apiKey: _testSecretKey, endpoint: _endpoint),
      signalsReady: true);
  //Stripe Subscriptions
  getIt.registerSingleton<StripeSubscription>(
      StripeSubscriptionImplementation(
          apiKey: _testSecretKey, endpoint: _endpoint),
      signalsReady: true);
  //Stripe Token
  getIt.registerSingleton<StripeToken>(
      StripeTokenImplementation(apiKey: _testSecretKey, endpoint: _endpoint),
      signalsReady: true);
  //Auth
  getIt.registerSingleton<Auth>(AuthImplementation(), signalsReady: true);
  //Message
  getIt.registerSingleton<Message>(MessageImplementation(), signalsReady: true);

  //Modal
  getIt.registerSingleton<Modal>(ModalImplementation(), signalsReady: true);
  //Notification
  getIt.registerSingleton<FCMNotification>(FCMNotificationImplementation(),
      signalsReady: true);
  //Package Device Info
  getIt.registerSingleton<PackageDeviceInfo>(PackageDeviceInfoImplementation(),
      signalsReady: true);
  //Validator
  getIt.registerSingleton<Validator>(ValidatorImplementation(),
      signalsReady: true);
  //Database
  getIt.registerSingleton<DB>(DBImplementation(), signalsReady: true);

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
        accentColor: Colors.red,
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
        buttonColor: Colors.amber,
      ),
      home: HomePage(),
    );
  }
}
