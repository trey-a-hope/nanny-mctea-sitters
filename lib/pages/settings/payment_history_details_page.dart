import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:intl/intl.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/charge.dart';

class PaymentHistoryDetailsPage extends StatefulWidget {
  const PaymentHistoryDetailsPage({@required this.charge});
  final Charge charge;
  @override
  State createState() => PaymentHistoryDetailsPageState(this.charge);
}

class PaymentHistoryDetailsPageState extends State<PaymentHistoryDetailsPage> {
  PaymentHistoryDetailsPageState(this.charge);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final Charge charge;
  final String timeFormat = 'MMM d, yyyy hh:mm:s a';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Text('ID'),
          Text(charge.id),
          Text('Description'),
          Text(charge.description),
          Text('Created'),
          Text(DateFormat(timeFormat).format(charge.created)),
          Text('Amount'),
          Text(FlutterMoneyFormatter(amount: charge.amount).output.symbolOnLeft)
        ]),
      ),
    );
  }
}
