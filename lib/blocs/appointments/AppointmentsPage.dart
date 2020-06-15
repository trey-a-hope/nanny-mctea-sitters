import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/appointments/Bloc.dart'
    as APPOINTMENTS_BP;
import 'package:nanny_mctea_sitters_flutter/blocs/appointmentDetails/Bloc.dart'
    as APPOINTMENT_DETAILS_BP;
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AgendaModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ValidatorService.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  State createState() => AppointmentsPageState();
}

class AppointmentsPageState extends State<AppointmentsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  APPOINTMENTS_BP.AppointmentsBloc appointmentsBloc;
  @override
  void initState() {
    super.initState();

    appointmentsBloc =
        BlocProvider.of<APPOINTMENTS_BP.AppointmentsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      key: _scaffoldKey,
      body: BlocConsumer<APPOINTMENTS_BP.AppointmentsBloc,
          APPOINTMENTS_BP.AppointmentsState>(
        listener:
            (BuildContext context, APPOINTMENTS_BP.AppointmentsState state) {
          // if (state is LoginSuccessfulState) {
          //   Navigator.of(context).pop();
          // }
        },
        builder:
            (BuildContext context, APPOINTMENTS_BP.AppointmentsState state) {
          if (state is APPOINTMENTS_BP.InitialState) {
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              itemCount: state.agendas.length,
              itemBuilder: (BuildContext context, int index) {
                AgendaModel agenda = state.agendas[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  title: Text('Sitter: ${agenda.res_name}'),
                  subtitle: Text(
                    'Starts ${DateFormat(DATE_FORMAT_FULL).format(
                      agenda.start,
                    )}',
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(
                      builder: (BuildContext context) => BlocProvider(
                        create: (BuildContext context) =>
                            APPOINTMENT_DETAILS_BP.AppointmentDetailsBloc(
                                agenda: agenda),
                        child: APPOINTMENT_DETAILS_BP.AppointmentDetailsPage(),
                      ),
                    );

                    Navigator.push(context, route);
                  },
                );
              },
            );
          } else if (state is APPOINTMENTS_BP.ErrorState) {
            return Center(
              child: Text('Error: ${state.error.toString()}'),
            );
          } else {
            return Center(
              child: Text('You should never see this.'),
            );
          }
        },
      ),
    );
  }
}
