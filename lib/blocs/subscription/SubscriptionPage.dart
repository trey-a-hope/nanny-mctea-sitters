import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/common/HexColor.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/PlanModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/SubscriptionModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/FormatterService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import '../../ServiceLocator.dart';
import '../../constants.dart';
import 'Bloc.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  State createState() => SubscriptionPageState();
}

class SubscriptionPageState extends State<SubscriptionPage>
    implements SubscriptionBlocDelegate {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  SubscriptionBloc _bloc;
  double screenHeight, screenWidth;

  final Color colorGold = HexColor('#D4AF37');
  final Color colorSilver = HexColor('#C0C0C0');

  @override
  void initState() {
    //Create BLoC instance and set delegate.
    _bloc = BlocProvider.of<SubscriptionBloc>(context);
    _bloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  // @override
  // void onSuccess() {
  //   // e.g.: Show a dialog or navigate to other screen
  // }

  // @override
  // void onError(String message) {
  //   locator<ModalService>()
  //       .showInSnackBar(scaffoldKey: scaffoldKey, message: message);
  // }

  @override
  void openSubscribeModal({@required String planID}) async {
    //If gold, subscribe to gold.
    if (planID == GOLD_HEART_30_PLAN_ID) {
      bool confirm = await locator<ModalService>().showConfirmation(
          context: context,
          title: 'Subscribe to Gold Plan',
          message: 'You wil now have 30 free messages weekly. Are you sure?');

      if (confirm) {
        _bloc.add(
          SubscribeEvent(planID: GOLD_HEART_30_PLAN_ID),
        );
      }
    }
    //Else, subscribe to silver.
    else if (planID == SILVER_HEART_15_PLAN_ID) {
      bool confirm = await locator<ModalService>().showConfirmation(
          context: context,
          title: 'Subscribe to Silver Plan',
          message: 'You wil now have 15 free messages weekly. Are you sure?');

      if (confirm) {
        _bloc.add(
          SubscribeEvent(planID: SILVER_HEART_15_PLAN_ID),
        );
      }
    }
  }

  @override
  void openUnsubscribeModal() async {
    bool confirm = await locator<ModalService>().showConfirmation(
        context: context,
        title: 'Cancel Subscription',
        message:
            'You will no longer receieve benefits of this plan. Are you sure?');

    if (confirm) {
      _bloc.add(
        UnsubscribeEvent(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    _bloc = BlocProvider.of<SubscriptionBloc>(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Subscription',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: BlocConsumer<SubscriptionBloc, SubscriptionState>(
            listener: (BuildContext context, SubscriptionState state) async {},
            builder: (BuildContext context, SubscriptionState state) {
              if (state is UnsubscribedState) {
                return buildUnsubscribedView(
                    goldPlan: state.goldPlan, silverPlan: state.silverPlan);
              }
              if (state is SubscribedState) {
                return buildSubscribedView(
                    plan: state.plan, subscription: state.subscription);
              }
              if (state is LoadingState) {
                return Spinner();
              }
              if (state is ErrorState) {
                return Center(
                  child: Text('Error: ${state.error.toString()}'),
                );
              } else {
                return Center(
                  child: Text(
                    'You should NEVER see this.',
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildUnsubscribedView(
      {@required PlanModel goldPlan, @required PlanModel silverPlan}) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: 'Silver Plan',
                style: TextStyle(color: colorSilver),
              ),
              TextSpan(
                text: ' / ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: 'Gold Plan',
                style: TextStyle(color: colorGold),
              ),
            ],
          ),
        ),
        Image.asset(
          'assets/images/black_man_phone.png',
          height: screenHeight * 0.4,
        ),
        Spacer(),
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${locator<FormatterService>().money(amount: silverPlan.amount)}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '/mo',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Silver Plan - Get silver discounts.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Text('Subscribe Now'),
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () {
                        _bloc.add(
                          OpenModalSubscribeEvent(
                              planID: SILVER_HEART_15_PLAN_ID),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${locator<FormatterService>().money(amount: goldPlan.amount)}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: '/mo',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Gold Plan - Get Gold discounts.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Text('Subscribe Now'),
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () {
                        _bloc.add(
                          OpenModalSubscribeEvent(
                              planID: GOLD_HEART_30_PLAN_ID),
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildSubscribedView(
      {@required PlanModel plan, @required SubscriptionModel subscription}) {
    return Column(
      children: [
        Text(
          'You Are Currently On The ${plan.id == GOLD_HEART_30_PLAN_ID ? 'Gold' : 'Silver'} Plan',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        Image.asset(
          'assets/images/black_men_office.jpg',
          height: screenHeight * 0.4,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text:
                    '${locator<FormatterService>().money(amount: plan.amount)}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              TextSpan(
                  text: '/mo',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold))
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Receieve ${plan.id == GOLD_HEART_30_PLAN_ID ? '30' : '15'} free messages weekly from our hot shots!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        buildSubscriptionStatus(status: subscription.status),
        Spacer(),
        RaisedButton(
          color: Colors.red,
          textColor: Colors.white,
          child: Text('Unsubscribe'),
          onPressed: () {
            _bloc.add(
              OpenModalUnsubscribeEvent(),
            );
          },
        )
      ],
    );
  }

  Widget buildSubscriptionStatus({@required String status}) {
    switch (status) {
      case 'active':
        return Text(
          'Subscription Status: ACTIVE',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        );
      case 'incomplete':
        return Text(
          'Subscription Status: INCOMPLETE',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        );

      case 'incomplete_expired':
        return Text(
          'Subscription Status: INCOMPLETE EXPIRED',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        );

      case 'trialing':
        return Text(
          'Subscription Status: TRIAL',
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        );

      case 'past_due':
        return Text(
          'Subscription Status: PAST DUE',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        );

      case 'canceled':
        return Text(
          'Subscription Status: CANCELED',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        );

      case 'unpaid':
        return Text(
          'Subscription Status: UNPAID',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        );

      default:
        return Text(
          'Error, no status found.',
          style: TextStyle(color: Colors.red),
        );
    }
  }
}
