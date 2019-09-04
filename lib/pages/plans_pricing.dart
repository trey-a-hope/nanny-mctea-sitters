import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PlansPricingPage extends StatefulWidget {


  @override
  State createState() => PlansPricingState();
}

class PlansPricingState extends State<PlansPricingPage>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PLANS AND PRICING'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('Pricing Goes Here')
          ],
        ),
      ),
    );
  }
}
