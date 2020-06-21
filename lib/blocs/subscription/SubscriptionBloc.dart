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
  CustomerModel customer; //Customer associated with this subscription.
  UserModel currentUser; //The user account.
  SubscriptionModel subscription; //Current subscripton.
  PlanModel goldPlan;
  PlanModel silverPlan;

  SubscriptionBlocDelegate _delegate;

  // void openSubscribeModal({@required String planID}) {
  //   if (customer == null || customer.defaultSource == null) {
  //     delegate.onError('Error: No active payment methods found.');
  //   } else {
  //     delegate.openSubscribeModal(planID: planID);
  //   }
  // }

  // void openUnsubscribeModal() {
  //   delegate.openUnsubscribeModal();
  // }

  void setDelegate({@required SubscriptionBlocDelegate delegate}) {
    this._delegate = delegate;
  }

  Future<void> loadData() async {
    try {
      //Fetch user.
      currentUser = await locator<AuthService>().getCurrentUser();

      //Fetch plans.
      goldPlan = await locator<StripePlanService>()
          .retrieve(planID: GOLD_HEART_30_PLAN_ID);
      silverPlan = await locator<StripePlanService>()
          .retrieve(planID: SILVER_HEART_15_PLAN_ID);

      //Fetch customer if the user has a customer account.
      if (currentUser.customerID != null) {
        customer = await locator<StripeCustomerService>()
            .retrieve(customerID: currentUser.customerID);
      }

      //Fetch subscription if the user has a subscription.
      if (currentUser.subscriptionID != null) {
        subscription = await locator<StripeSubscriptionService>()
            .retrieve(subscriptionID: currentUser.subscriptionID);
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
        if (customer == null || subscription == null) {
          yield UnsubscribedState(goldPlan: goldPlan, silverPlan: silverPlan);
        } else {
          if (subscription.plan == GOLD_HEART_30_PLAN_ID) {
            yield SubscribedState(plan: goldPlan, subscription: subscription);
          }
          if (subscription.plan == SILVER_HEART_15_PLAN_ID) {
            yield SubscribedState(plan: silverPlan, subscription: subscription);
          }
        }
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is OpenModalSubscribeEvent) {
      _delegate.openSubscribeModal(planID: event.planID);
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
              .create(customerID: customer.id, planID: GOLD_HEART_30_PLAN_ID);
        }

        //Subcribe user to Silver Plan.
        if (event.planID == SILVER_HEART_15_PLAN_ID) {
          subscriptionID = await locator<StripeSubscriptionService>()
              .create(customerID: customer.id, planID: SILVER_HEART_15_PLAN_ID);
        }

        //Update subscription ID and free message count in firebase.
        await locator<UserService>().updateUser(userID: currentUser.id, data: {
          'subscriptionID': subscriptionID,
          // 'freeMessageCount': event.planID == GOLD_HEART_30_PLAN_ID ? 30 : 15
        });

        //Fetch updated data.
        await loadData();

        //Display Subscribed State with respective plan.
        if (subscription.plan == GOLD_HEART_30_PLAN_ID) {
          yield SubscribedState(plan: goldPlan, subscription: subscription);
        }
        if (subscription.plan == SILVER_HEART_15_PLAN_ID) {
          yield SubscribedState(plan: silverPlan, subscription: subscription);
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
            subscriptionID: currentUser.subscriptionID,
            invoiceNow: true,
            prorate: true);

        //Update subscription ID and free message count in firebase.
        await locator<UserService>().updateUser(
          userID: currentUser.id,
          data: {'subscriptionID': null, 'freeMessageCount': 3},
        );

        //Fetch updated data.
        await loadData();

        yield UnsubscribedState(goldPlan: goldPlan, silverPlan: silverPlan);
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
