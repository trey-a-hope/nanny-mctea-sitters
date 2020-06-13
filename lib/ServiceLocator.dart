import 'package:get_it/get_it.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ConversationService.dart';
import 'package:nanny_mctea_sitters_flutter/services/DBService.dart';
import 'package:nanny_mctea_sitters_flutter/services/FCMNotificationService.dart';
import 'package:nanny_mctea_sitters_flutter/services/FormatterService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import 'package:nanny_mctea_sitters_flutter/services/StorageService.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ValidatorService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCardService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeChargeService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCouponService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCustomerService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeOrderService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripePlanService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeSkuService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeSubscriptionService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeTokenService.dart';
import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSAppointmentService.dart';
import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSResourceService.dart';

GetIt locator = GetIt.I;

void setUpLocater() {
  //Other
  locator.registerLazySingleton(() => ValidatorService());
  locator.registerLazySingleton(() => ModalService());
  locator.registerLazySingleton(() => FormatterService());

  //Firebase
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => FCMNotificationService());
  locator.registerLazySingleton(() => DBService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => ConversationsService());

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
  
  //Super SaaS
  locator.registerLazySingleton(() => SuperSaaSAppointmentService());
  locator.registerLazySingleton(() => SuperSaaSResourceService());
}
