import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/clipper_slant.dart';
import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/ChargeModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeChargeService.dart';

class PaymentHistoryPage extends StatefulWidget {
  @override
  State createState() => PaymentHistoryPageState();
}

class PaymentHistoryPageState extends State<PaymentHistoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GetIt getIt = GetIt.instance;
  final int detailsCharLimit = 60;
  final String timeFormat = 'MMM d, yyyy';
  bool _isLoading = true;
  UserModel _currentUser;
  List<ChargeModel> _charges = List<ChargeModel>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() async {
    try {
      _currentUser = await getIt<AuthService>().getCurrentUser();
      // _charges = await getIt<StripeChargeService>()
      //     .listAll(customerID: _currentUser.customerID);

      setState(
        () {
          _isLoading = false;
        },
      );
    } catch (e) {
      setState(
        () {
          _isLoading = false;
        },
      );
      getIt<ModalService>().showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isLoading
          ? Spinner()
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ScaffoldClipper(
                    simpleNavbar: SimpleNavbar(
                      leftWidget:
                          Icon(MdiIcons.chevronLeft, color: Colors.white),
                      leftTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    title: 'Payment History',
                    subtitle: 'See how you\'ve been spending.',
                  ),
                  _charges.isEmpty
                      ? Center(
                          child: Text('No charges at the moment.'),
                        )
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _charges.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return _buildCharge(_charges[index]);
                          },
                        ),
                ],
              ),
            ),
    );
  }

  Widget _buildCharge(ChargeModel charge) {
    return ListTile(
      leading:
          Icon(MdiIcons.cash, color: Theme.of(context).primaryIconTheme.color),
      title: Text(
        FlutterMoneyFormatter(amount: charge.amount).output.symbolOnLeft +
            ' - ' +
            DateFormat(timeFormat).format(charge.created),
      ),
      subtitle: Text(charge.description.length > detailsCharLimit
          ? charge.description.substring(0, detailsCharLimit) + '...'
          : charge.description),
    );
  }
}
