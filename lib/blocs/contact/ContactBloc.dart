import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants_ui.dart';
import 'Bloc.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  @override
  ContactState get initialState => InitialState();

  @override
  Stream<ContactState> mapEventToState(ContactEvent event) async* {

    if (event is SendEmailEvent) {
      yield LoadingState();

      try {
        String uri =
            'mailto:$COMPANY_EMAIL?subject=${event.subject}&body=${event.message}';
        if (await canLaunch(uri)) {
          await launch(uri);
          yield InitialState();
        } else {
          throw 'Could not launch $uri';
        }
      } catch (error) {
        yield SendEmailFailureState(error: error);
      }
    }
  }
}
