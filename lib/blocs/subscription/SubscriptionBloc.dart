import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/subscription/Bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/CustomerModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/PlanModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/SubscriptionModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCustomerService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripePlanService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeSubscriptionService.dart';
import '../../ServiceLocator.dart';
import '../../constants.dart';
import 'SubscriptionEvent.dart';
import 'SubscriptionState.dart';

abstract class SubscriptionBlocDelegate {
  void openSubscribeModal({@required String planID});
  void openUnsubscribeModal();
}

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  CustomerModel _customer;
  UserModel _currentUser;
  SubscriptionModel _subscription;
  PlanModel _goldPlan;
  PlanModel _silverPlan;
  SubscriptionBlocDelegate _delegate;

  void setDelegate({@required SubscriptionBlocDelegate delegate}) {
    this._delegate = delegate;
  }

  Future<void> loadData() async {
    try {
      //Fetch user.
      _currentUser = await locator<AuthService>().getCurrentUser();

      //Fetch plans.
      _goldPlan = await locator<StripePlanService>()
          .retrieve(planID: GOLD_HEART_30_PLAN_ID);
      _silverPlan = await locator<StripePlanService>()
          .retrieve(planID: SILVER_HEART_15_PLAN_ID);

      //Fetch customer if the user has a customer account.
      if (_currentUser.customerID != null) {
        _customer = await locator<StripeCustomerService>()
            .retrieve(customerID: _currentUser.customerID);
      }

      //Fetch subscription if the user has a subscription.
      if (_currentUser.subscriptionID != null) {
        _subscription = await locator<StripeSubscriptionService>()
            .retrieve(subscriptionID: _currentUser.subscriptionID);
      }
      return;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  SubscriptionState get initialState => LoadingState(text: 'Loading...');

  @override
  Stream<SubscriptionState> mapEventToState(SubscriptionEvent event) async* {
    //Load page data for initial view.
    if (event is LoadPageEvent) {
      //Display spinner.
      yield LoadingState(text: 'Loading...');

      try {
        //Fetch updated data.
        await loadData();

        //If the user does not have a customer account or a subscription, yield UnsubscribedState state.
        if (_customer == null || _subscription == null) {
          yield UnsubscribedState(goldPlan: _goldPlan, silverPlan: _silverPlan);
        } else {
          if (_subscription.plan == GOLD_HEART_30_PLAN_ID) {
            yield SubscribedState(plan: _goldPlan, subscription: _subscription);
          }
          if (_subscription.plan == SILVER_HEART_15_PLAN_ID) {
            yield SubscribedState(
                plan: _silverPlan, subscription: _subscription);
          }
        }
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is OpenModalSubscribeEvent) {
      _delegate.openSubscribeModal(planID: event.planID);
    }

    if (event is OpenModalUnsubscribeEvent) {
      _delegate.openUnsubscribeModal();
    }

    //Subscribe user.
    if (event is SubscribeEvent) {
      //Display spinner.
      yield LoadingState(text: 'Subscribing, one moment please...');

      try {
        //Create subscription ID;
        String subscriptionID;

        //Subcribe user to Gold Plan.
        if (event.planID == GOLD_HEART_30_PLAN_ID) {
          subscriptionID = await locator<StripeSubscriptionService>()
              .create(customerID: _customer.id, planID: GOLD_HEART_30_PLAN_ID);
        }

        //Subcribe user to Silver Plan.
        if (event.planID == SILVER_HEART_15_PLAN_ID) {
          subscriptionID = await locator<StripeSubscriptionService>().create(
              customerID: _customer.id, planID: SILVER_HEART_15_PLAN_ID);
        }

        //Update subscription ID and free message count in firebase.
        await locator<UserService>().updateUser(userID: _currentUser.id, data: {
          'subscriptionID': subscriptionID,
          // 'freeMessageCount': event.planID == GOLD_HEART_30_PLAN_ID ? 30 : 15
        });

        //Fetch updated data.
        await loadData();

        //Display Subscribed State with respective plan.
        if (_subscription.plan == GOLD_HEART_30_PLAN_ID) {
          yield SubscribedState(plan: _goldPlan, subscription: _subscription);
        }
        if (_subscription.plan == SILVER_HEART_15_PLAN_ID) {
          yield SubscribedState(plan: _silverPlan, subscription: _subscription);
        }
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is UnsubscribeEvent) {
      //Display spinner.
      yield LoadingState(text: 'Unsubscribing, one moment please...');

      try {
        //Cancel subscription for this user.
        await locator<StripeSubscriptionService>().cancel(
            subscriptionID: _currentUser.subscriptionID,
            invoiceNow: true,
            prorate: true);

        //Update subscription ID and free message count in firebase.
        await locator<UserService>().updateUser(
          userID: _currentUser.id,
          data: {'subscriptionID': null, 'freeMessageCount': 3},
        );

        //Fetch updated data.
        await loadData();

        yield UnsubscribedState(goldPlan: _goldPlan, silverPlan: _silverPlan);
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
