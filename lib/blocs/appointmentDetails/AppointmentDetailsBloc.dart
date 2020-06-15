import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/CustomerModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AgendaModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCardService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCustomerService.dart';
import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeTokenService.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart' as APPOINTMENT_DETAILS_BP;

class AppointmentDetailsBloc extends Bloc<
    APPOINTMENT_DETAILS_BP.AppointmentDetailsEvent,
    APPOINTMENT_DETAILS_BP.AppointmentDetailsState> {
  final AgendaModel agenda;
  AppointmentDetailsBloc({
    @required this.agenda,
  });

  @override
  APPOINTMENT_DETAILS_BP.AppointmentDetailsState get initialState =>
      APPOINTMENT_DETAILS_BP.InitialState(agenda: agenda);

  @override
  Stream<APPOINTMENT_DETAILS_BP.AppointmentDetailsState> mapEventToState(
      APPOINTMENT_DETAILS_BP.AppointmentDetailsEvent event) async* {}
}
