import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSAppointmentService.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

class BookSitterPaymentBloc
    extends Bloc<BookSitterPaymentEvent, BookSitterPaymentState> {
  BookSitterPaymentBloc();

  @override
  BookSitterPaymentState get initialState => InitialState();

  @override
  Stream<BookSitterPaymentState> mapEventToState(
      BookSitterPaymentEvent event) async* {
    if (event is SubmitPaymentEvent) {
      // locator<SuperSaaSAppointmentService>().create(
      //   scheduleID: 489593,
      //   userID: currentUser.id,
      //   email: currentUser.email,
      //   fullName: '${currentUser.name}',
      //   start: DateTime.now(),
      //   finish: DateTime.now().add(
      //     Duration(hours: 2),
      //   ),
      // );
    }
  }
}
