import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/customer..dart';
import 'package:nanny_mctea_sitters_flutter/services/auth.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/customer.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/subscriptions.dart';

import '../asset_images.dart';

class PlansPricingPage extends StatefulWidget {
  @override
  State createState() => PlansPricingState();
}

class PlansPricingState extends State<PlansPricingPage> {
  bool _isLoading = true;
  final GetIt getIt = GetIt.I;
  Customer _customer;
  User _currentUser;

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() async {
    _currentUser = await getIt<Auth>().getCurrentUser();
    _customer = await getIt<StripeCustomer>()
        .retrieve(customerId: _currentUser.customerId);

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  void _startSubscription() async {
    if (_customer.isSubscribed) {
      getIt<Modal>().showAlert(
          context: context,
          title: 'Error',
          message: 'You are already apart of the subscription.');
      return;
    }

    bool confirm = await getIt<Modal>().showConfirmation(
        context: context,
        title: 'Start Subscription',
        text:
            'You will start your monthly plan today, and will be billed every month for \$100. Continue with plan?');
    if (confirm) {
      try {
        setState(() {
          _isLoading = true;
        });

        String subscriptionId = await getIt<StripeSubscription>().create(
            customerId: _currentUser.customerId, plan: STRIPE_GOLD_PLAN_ID);
        print(subscriptionId);

        setState(() {
          _isLoading = false;
        });

        getIt<Modal>().showAlert(
            context: context,
            title: 'Success',
            message: 'Your subscription has started.');
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        getIt<Modal>().showAlert(
          context: context,
          title: 'Error',
          message: e.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: asImgFloorCrayons,
                    fit: BoxFit.cover,
                    alignment: Alignment.center)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.7),
                    Colors.white.withOpacity(1)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1]),
            ),
          ),
          Center(
            child: Container(
              height: 520,
              width: screen_width * 0.9,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white, width: 2.0, style: BorderStyle.solid),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 4.0,
                      spreadRadius: 4.0)
                ],
                gradient: LinearGradient(
                  colors: [Colors.grey.shade800, Colors.grey.shade500],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 1],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Choose Your Pricing Plan',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sitter Membership',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '\$100',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 80,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Every month',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Get your life back, enjoy your secured sitter.',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  MaterialButton(
                    color: Colors.white,
                    child: Text('SELECT'),
                    onPressed: () {
                      _startSubscription();
                    },
                  ),
                  Divider(color: Colors.white),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      '*Unlimited week night sits after 5 pm',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      '*Unlimited weekend sits',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      '*Sitter must be given 32 hours before sit begins',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      '*You are required to pay your sitter the \$13 hourly rate',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('PLANS & PRICING'),
      centerTitle: true,
    );
  }
}
