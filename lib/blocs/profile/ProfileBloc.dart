import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AgendaModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AppointmentModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/StorageService.dart';
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

  Future<void> handleImage(
      {@required ImageSource source, @required String userID}) async {
    //Pick an image.
    File file = await ImagePicker.pickImage(source: source);

    //Check that user picked an image.
    if (file == null) return;

    //Crop an image.
    File image = await ImageCropper.cropImage(sourcePath: file.path);

    //Check that user cropped the image.
    if (image == null) return;

    //Upload image to storage.
    final String imgUrl = await locator<StorageService>()
        .uploadImage(file: image, path: 'Images/Users/$userID/avatar');

    //Update image url.
    locator<UserService>().updateUser(userID: userID, data: {
      'imgUrl': imgUrl,
    });

    return;
  }

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

    if (event is HandleImageEvent) {
      try {
        await handleImage(
          source: event.imageSource,
          userID: event.userID,
        );

        //Load current user.
        _currentUser = await locator<AuthService>().getCurrentUser();

        yield LoadedState(currentUser: _currentUser, agendas: _agendas);
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
