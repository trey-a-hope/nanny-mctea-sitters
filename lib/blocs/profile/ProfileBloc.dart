import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AgendaModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AppointmentModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';
import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSAppointmentService.dart';

import '../../ServiceLocator.dart';
import 'Bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc();

  UserModel _currentUser;
  List<AgendaModel> _agendas;

  @override
  ProfileState get initialState => ProfileState();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        //Load current user.
        _currentUser = await locator<AuthService>().getCurrentUser();

        //Load appointments.
        _agendas = await locator<SuperSaaSAppointmentService>()
            .getAgendaForUser(userID: _currentUser.saasID);

        yield LoadedState(currentUser: _currentUser, agendas: _agendas);
      } catch (error) {
        //Display error page.
        yield ErrorState(error: error);
      }
    }
  }
}
