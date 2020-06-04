import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AppointmentModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/ResourceModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSAppointmentService.dart';
import 'package:nanny_mctea_sitters_flutter/services/supersaas/SuperSaaSResourceService.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../ServiceLocator.dart';
import '../../constants.dart';
import 'Bloc.dart';

class BookSitterInfoBloc
    extends Bloc<BookSitterInfoEvent, BookSitterInfoState> {
  BookSitterInfoBloc({
    @required this.selectedDate,
  });

  final DateTime selectedDate;

  @override
  BookSitterInfoState get initialState => BookSitterInfoState();

  @override
  Stream<BookSitterInfoState> mapEventToState(
      BookSitterInfoEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        yield LoadedState();
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}