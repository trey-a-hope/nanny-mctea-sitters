import 'package:get_it/get_it.dart';
import 'package:nanny_mctea_sitters_flutter/services/DBService.dart';
import 'package:nanny_mctea_sitters_flutter/services/MessageService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ValidatorService.dart';
import 'package:nanny_mctea_sitters_flutter/services/auth.dart';
import 'package:nanny_mctea_sitters_flutter/services/fcm_notification.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCardService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeChargeService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCouponService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCustomerService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeOrderService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripePlanService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeSkuService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeSubscriptionService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeTokenService.dart';
import 'package:nanny_mctea_sitters_flutter/services/url_launcher.dart';

GetIt locator = GetIt.I;

void setUpLocater() {
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => ValidatorService());
  locator.registerLazySingleton(() => ModalService());
  locator.registerLazySingleton(() => FCMNotificationService());
  locator.registerLazySingleton(() => URLLauncher());
  locator.registerLazySingleton(() => DBService());
  locator.registerLazySingleton(() => MessageService());
  //Stripe Services
  locator.registerLazySingleton(() => StripeCardService());
  locator.registerLazySingleton(() => StripeChargeService());
  locator.registerLazySingleton(() => StripeCouponService());
  locator.registerLazySingleton(() => StripeCustomerService());
  locator.registerLazySingleton(() => StripeOrderService());
  locator.registerLazySingleton(() => StripeSkuService());
  locator.registerLazySingleton(() => StripeTokenService());
  locator.registerLazySingleton(() => StripePlanService());
  locator.registerLazySingleton(() => StripeSubscriptionService());
}
