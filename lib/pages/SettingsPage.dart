import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/subscription/Bloc.dart'
    as SUBSCRIPTION_BLOC;
import 'package:nanny_mctea_sitters_flutter/blocs/paymentMethod/Bloc.dart'
    as PAYMENT_METHOD_BLOC;
import 'package:nanny_mctea_sitters_flutter/blocs/paymentHistory/Bloc.dart'
    as PAYMENT_HISTORY_BLOC;
import 'package:nanny_mctea_sitters_flutter/blocs/profile/Bloc.dart'
    as PROFILE_BLOC;
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import '../ServiceLocator.dart';

class SettingsPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextStyle headerStyle = TextStyle(
    color: Colors.grey.shade800,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Payments",
              style: headerStyle,
            ),
            Card(
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 0,
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading:
                        Icon(Icons.credit_card, color: Colors.red.shade300),
                    title: Text('Payment Method'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Route route = MaterialPageRoute(
                        builder: (BuildContext context) => BlocProvider(
                          create: (BuildContext context) =>
                              PAYMENT_METHOD_BLOC.PaymentMethodBloc()
                                ..add(PAYMENT_METHOD_BLOC.LoadPageEvent()),
                          child: PAYMENT_METHOD_BLOC.PaymentMethodPage(),
                        ),
                      );

                      Navigator.push(context, route);
                    },
                  ),
                  Divider(),
                  //Subscriptions
                  ListTile(
                    leading: Icon(Icons.book, color: Colors.red.shade300),
                    title: Text('Subscription'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Route route = MaterialPageRoute(
                        builder: (BuildContext context) => BlocProvider(
                          create: (BuildContext context) =>
                              SUBSCRIPTION_BLOC.SubscriptionBloc()
                                ..add(SUBSCRIPTION_BLOC.LoadPageEvent()),
                          child: SUBSCRIPTION_BLOC.SubscriptionPage(),
                        ),
                      );

                      Navigator.push(context, route);
                    },
                  ),
                  Divider(),
                  //Subscriptions
                  ListTile(
                    leading: Icon(Icons.history, color: Colors.red.shade300),
                    title: Text('Payment History'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Route route = MaterialPageRoute(
                        builder: (BuildContext context) => BlocProvider(
                          create: (BuildContext context) =>
                              PAYMENT_HISTORY_BLOC.PaymentHistoryBloc()
                                ..add(PAYMENT_HISTORY_BLOC.LoadPageEvent()),
                          child: PAYMENT_HISTORY_BLOC.PaymentHistoryPage(),
                        ),
                      );

                      Navigator.push(context, route);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              "Other",
              style: headerStyle,
            ),
            Card(
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 0,
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.delete, color: Colors.red.shade300),
                    title: Text('Delete Account'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () async {
                      locator<ModalService>().showAlert(
                          context: context,
                          title: 'Contact Admin',
                          message:
                              'This requires extra steps from the admin team.');
                    },
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 0,
              ),
              child: ListTile(
                trailing: Icon(Icons.exit_to_app),
                title: Text("Logout"),
                onTap: () async {
                  bool confirm = await locator<ModalService>().showConfirmation(
                      context: context,
                      title: 'Log Out',
                      message: 'Are you sure?');
                  if (confirm) {
                    try {
                      await locator<AuthService>().signOut();
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(Navigator.defaultRouteName),
                      );
                    } catch (e) {
                      locator<ModalService>().showAlert(
                        context: context,
                        title: 'Error',
                        message: e.message(),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
