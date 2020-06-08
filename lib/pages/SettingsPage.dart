import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/home/HomeEvent.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/subscription/Bloc.dart'
    as SubscriptionBP;
import 'package:nanny_mctea_sitters_flutter/blocs/paymentMethod/Bloc.dart'
    as PaymentMethodBP;
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
                              PaymentMethodBP.PaymentMethodBloc()
                                ..add(PaymentMethodBP.LoadPageEvent()),
                          child: PaymentMethodBP.PaymentMethodPage(),
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
                      locator<ModalService>().showAlert(
                          context: context,
                          title: 'Coming soon...',
                          message: 'Subscription Page.');
                      // Route route = MaterialPageRoute(
                      //   builder: (BuildContext context) => BlocProvider(
                      //     create: (BuildContext context) =>
                      //         SubscriptionBP.SubscriptionBloc()
                      //           ..add(SubscriptionBP.LoadPageEvent()),
                      //     child: SubscriptionBP.SubscriptionPage(),
                      //   ),
                      // );

                      // Navigator.push(context, route);
                    },
                  ),
                  Divider(),
                  //Subscriptions
                  ListTile(
                    leading: Icon(Icons.history, color: Colors.red.shade300),
                    title: Text('Payment History'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      locator<ModalService>().showAlert(
                          context: context,
                          title: 'Coming soon...',
                          message: 'Payment History Page.');
                      // Route route = MaterialPageRoute(
                      //   builder: (BuildContext context) => BlocProvider(
                      //     create: (BuildContext context) =>
                      //         SubscriptionBP.SubscriptionBloc()
                      //           ..add(SubscriptionBP.LoadPageEvent()),
                      //     child: SubscriptionBP.SubscriptionPage(),
                      //   ),
                      // );

                      // Navigator.push(context, route);
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
