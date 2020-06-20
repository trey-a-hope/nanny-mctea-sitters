import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

abstract class SitterDetailsBlocDelegate {
  void showMessage({@required String message});
  void navigateToMessageThread();
}

//todo: VALIDATE THAT SIGN UP WORKS BY DELETEING ALL USER DATE AND STARTING WITH CLEAN TRY
class SitterDetailsBloc extends Bloc<SitterDetailsEvent, SitterDetailsState> {
  final UserModel sitter;

  SitterDetailsBlocDelegate _delegate;
  UserModel currentUser;

  SitterDetailsBloc({
    @required this.sitter,
  });

  @override
  SitterDetailsState get initialState => LoadingState();

  void setDelegate({@required SitterDetailsBlocDelegate delegate}) {
    this._delegate = delegate;
  }

  @override
  Stream<SitterDetailsState> mapEventToState(SitterDetailsEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      //Fetch current user.
      currentUser = await locator<AuthService>().getCurrentUser();

      yield LoadedState(sitter: sitter);
    }

    if (event is SendMessageEvent) {
      //Validate the user is logged in.
      if (currentUser == null) {
        _delegate.showMessage(
            message: 'Sorry, you must be logged in to use this feature.');
      } else {
        _delegate.navigateToMessageThread();
      }
    }
  }
}
