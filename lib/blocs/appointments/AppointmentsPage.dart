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

import 'Bloc.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  State createState() => AppointmentsPageState();
}

class AppointmentsPageState extends State<AppointmentsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppointmentsBloc appointmentsBloc;
  @override
  void initState() {
    super.initState();

    appointmentsBloc = BlocProvider.of<AppointmentsBloc>(context);
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
      body: BlocConsumer<AppointmentsBloc, AppointmentsState>(
        listener: (BuildContext context, AppointmentsState state) {
          // if (state is LoginSuccessfulState) {
          //   Navigator.of(context).pop();
          // }
        },
        builder: (BuildContext context, AppointmentsState state) {
          if (state is InitialState) {
            return ListView.builder(
              itemCount: state.agendas.length,
              itemBuilder: (BuildContext context, int index) {
                AgendaModel agenda = state.agendas[index];
                return ListTile(
                  title: Text(agenda.full_name),
                );
              },
            );
          } else if (state is ErrorState) {
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
