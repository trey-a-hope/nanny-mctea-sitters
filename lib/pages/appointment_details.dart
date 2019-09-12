import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/models/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';

class AppointmentDetailsPage extends StatefulWidget {
  final Appointment appointment;

  AppointmentDetailsPage(this.appointment);

  @override
  State createState() => AppointmentDetailsPageState(this.appointment);
}

class AppointmentDetailsPageState extends State<AppointmentDetailsPage>
    with SingleTickerProviderStateMixin {
  AppointmentDetailsPageState(this.appointment);
  final Appointment appointment;
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      key: _scaffoldKey,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Text(appointment.service),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('APPOINTMENT DETAILS'),
      centerTitle: true,
    );
  }

  _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        onPressed: () {
          Modal.showInSnackBar(_scaffoldKey, 'Cancel Appointment.');
        },
        color: Colors.red,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                MdiIcons.close,
                color: Colors.white,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                'CANCEL APPOINTMENT',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
