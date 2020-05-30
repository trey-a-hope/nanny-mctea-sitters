// import 'package:flutter/material.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
// import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
// import 'package:nanny_mctea_sitters_flutter/pages/payments/payment_method.dart';
// import 'package:nanny_mctea_sitters_flutter/pages/payments/paymet_history_page.dart';
// class SettingsPage extends StatefulWidget {
//   @override
//   State createState() => SettingsPageState();
// }

// class SettingsPageState extends State<SettingsPage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             ScaffoldClipper(
//               simpleNavbar: SimpleNavbar(
//                 leftWidget: Icon(MdiIcons.chevronLeft, color: Colors.white),
//                 leftTap: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               title: 'Settings',
//               subtitle: 'Just how you like it.',
//             ),
//             ListTile(
//               leading: Icon(Icons.credit_card,
//                   color: Theme.of(context).primaryIconTheme.color),
//               title: Text('Payment Method'),
//               subtitle: Text('Manage your payment method.'),
//               trailing: Icon(Icons.chevron_right),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => PaymentMethodPage(),
//                   ),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.history,
//                   color: Theme.of(context).primaryIconTheme.color),
//               title: Text('Payment History'),
//               subtitle: Text('View your past transactions.'),
//               trailing: Icon(Icons.chevron_right),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => PaymentHistoryPage(),
//                   ),
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        backgroundColor: Colors.red,
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
                      locator<ModalService>().showAlert(
                          context: context,
                          title: 'To Do',
                          message: 'Navigate to payment methods.');
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PaymentMethodPage(),
                      //   ),
                      // );
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
                          title: 'To Do',
                          message: 'Navigate to subscription page.');
                      // Route route = MaterialPageRoute(
                      //   builder: (BuildContext context) => BlocProvider(
                      //     create: (BuildContext context) =>
                      //         SubscriptionBloc()..add(LoadPageEvent()),
                      //     child: SubscriptionPage(),
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
                      // locator<ModalService>().showAlert(
                      //     context: context,
                      //     title: 'Contact Admin',
                      //     message:
                      //         'This requires extra steps from the admin team.');
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.security, color: Colors.red.shade300),
                    title: Text('Admin'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => AdminPage(),
                      //   ),
                      // );
                    },
                  )
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
