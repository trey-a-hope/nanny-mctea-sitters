import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AgendaModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/AuthService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import 'package:nanny_mctea_sitters_flutter/services/ValidatorService.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'Bloc.dart' as APPOINTMENT_DETAILS_BP;

class AppointmentDetailsPage extends StatefulWidget {
  @override
  State createState() => APPOINTMENT_DETAILS_BP.AppointmentDetailsPageState();
}

class AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  APPOINTMENT_DETAILS_BP.AppointmentDetailsBloc appointmentDetailsBloc;
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
      body: BlocConsumer<APPOINTMENT_DETAILS_BP.AppointmentDetailsBloc,
          APPOINTMENT_DETAILS_BP.AppointmentDetailsState>(
        listener: (BuildContext context,
            APPOINTMENT_DETAILS_BP.AppointmentDetailsState state) {
          // if (state is LoginSuccessfulState) {
          //   Navigator.of(context).pop();
          // }
        },
        builder: (BuildContext context,
            APPOINTMENT_DETAILS_BP.AppointmentDetailsState state) {
          if (state is APPOINTMENT_DETAILS_BP.InitialState) {
            return Center(
              child: Text(state.agenda.res_name),
            );
          }
          // if (state is InitialState) {
          //   return ListView.builder(
          //     itemCount: state.agendas.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       AgendaModel agenda = state.agendas[index];
          //       return ListTile(
          //         title: Text(agenda.full_name),
          //         onTap: (){
          //                           Route route = MaterialPageRoute(
          //         builder: (BuildContext context) => BlocProvider(
          //           create: (BuildContext context) =>
          //               APPOINTMENTS_BP.AppointmentsBloc(agendas: agendas),
          //           child: APPOINTMENTS_BP.AppointmentsPage(),
          //         ),
          //       );

          //       Navigator.push(context, route);
          //         },
          //       );
          //     },
          //   );
          // } else if (state is ErrorState) {
          //   return Center(
          //     child: Text('Error: ${state.error.toString()}'),
          //   );
          // } else {
          //   return Center(
          //     child: Text('You should never see this.'),
          //   );
          // }
        },
      ),
    );
  }
}
