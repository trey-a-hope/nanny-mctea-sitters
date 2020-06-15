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
import 'Bloc.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final List<AgendaModel> agendas;

  AppointmentsBloc({
    @required this.agendas,
  });

  @override
  AppointmentsState get initialState => InitialState(agendas: agendas);

  @override
  Stream<AppointmentsState> mapEventToState(AppointmentsEvent event) async* {}
}
