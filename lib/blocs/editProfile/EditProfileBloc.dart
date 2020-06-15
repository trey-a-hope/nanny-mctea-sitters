import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart' as EDIT_PROFILE_BP;

class EditProfileBloc extends Bloc<EDIT_PROFILE_BP.EditProfileEvent,
    EDIT_PROFILE_BP.EditProfileState> {
  EditProfileBloc();

  UserModel currentUser;

  @override
  EDIT_PROFILE_BP.EditProfileState get initialState =>
      EDIT_PROFILE_BP.EditProfileState();

  @override
  Stream<EDIT_PROFILE_BP.EditProfileState> mapEventToState(
      EDIT_PROFILE_BP.EditProfileEvent event) async* {
    if (event is EDIT_PROFILE_BP.LoadPageEvent) {
      yield EDIT_PROFILE_BP.LoadingState();
      //Fetch current user;
      currentUser = await locator<AuthService>().getCurrentUser();

      yield EDIT_PROFILE_BP.LoadedState(
        currentUser: currentUser,
      );
    }
  }
}
