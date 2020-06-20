import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';

import 'Bloc.dart' as APPOINTMENT_DETAILS_BP;

class AppointmentDetailsPage extends StatefulWidget {
  @override
  State createState() => APPOINTMENT_DETAILS_BP.AppointmentDetailsPageState();
}

class AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  APPOINTMENT_DETAILS_BP.AppointmentDetailsBloc appointmentDetailsBloc;
  final String _dateFormat = 'MMMM dd, yyyy @ hh:mm a';

  @override
  void initState() {
    super.initState();

    appointmentDetailsBloc =
        BlocProvider.of<APPOINTMENT_DETAILS_BP.AppointmentDetailsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointment Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool confirm = await locator<ModalService>().showConfirmation(
                  context: context,
                  title: 'Cancel Appointment',
                  message: 'Are you sure?');
              if (confirm) {
                appointmentDetailsBloc
                    .add(APPOINTMENT_DETAILS_BP.DeleteAppointmentEvent());
              }
            },
          )
        ],
      ),
      key: _scaffoldKey,
      body: BlocBuilder<APPOINTMENT_DETAILS_BP.AppointmentDetailsBloc,
          APPOINTMENT_DETAILS_BP.AppointmentDetailsState>(
        builder: (BuildContext context,
            APPOINTMENT_DETAILS_BP.AppointmentDetailsState state) {
          if (state is APPOINTMENT_DETAILS_BP.InitialState) {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(state.agenda.res_name),
                  subtitle: Text(
                    'Starts: ${DateFormat(_dateFormat).format(state.agenda.start)}'
                  ),
                )
              ],
            );
          }

          return Container();
        },
      ),
    );
  }
}
