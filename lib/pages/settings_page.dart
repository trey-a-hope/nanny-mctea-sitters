import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/pages/settings/payment_method.dart';
import 'package:nanny_mctea_sitters_flutter/pages/settings/paymet_history_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  State createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ScaffoldClipper(
              simpleNavbar: SimpleNavbar(
                leftWidget: Icon(MdiIcons.chevronLeft, color: Colors.white),
                leftTap: () {
                  Navigator.of(context).pop();
                },
              ),
              title: 'Settings',
              subtitle: 'Just how you like it.',
            ),
            ListTile(
              leading: Icon(Icons.credit_card,
                  color: Theme.of(context).primaryIconTheme.color),
              title: Text('Payment Method'),
              subtitle: Text('Manage your payment method.'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentMethodPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history,
                  color: Theme.of(context).primaryIconTheme.color),
              title: Text('Payment History'),
              subtitle: Text('View your past transactions.'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentHistoryPage(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
