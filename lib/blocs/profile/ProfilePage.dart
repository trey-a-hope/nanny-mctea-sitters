import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/profile/Bloc.dart';
import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AgendaModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AppointmentModel.dart';
import 'package:nanny_mctea_sitters_flutter/pages/messages/messages_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  State createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String timeFormat = 'MMM d, yyyy @ hh:mm a';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: <Widget>[],
      ),
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (BuildContext context, ProfileState state) {},
        builder: (BuildContext context, ProfileState state) {
          if (state is LoadingState) {
            return Spinner();
          } else if (state is LoadedState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Info',
                    style: TextStyle(color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        leading: Icon(Icons.person,
                            color: Theme.of(context).primaryIconTheme.color),
                        title: Text(state.currentUser.name),
                        subtitle: Text('Name'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        leading: Icon(Icons.phone,
                            color: Theme.of(context).primaryIconTheme.color),
                        title: Text(state.currentUser.phone),
                        subtitle: Text('Phone'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        leading: Icon(Icons.email,
                            color: Theme.of(context).primaryIconTheme.color),
                        title: Text(state.currentUser.email),
                        subtitle: Text('Email'),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('EDIT PROFILE'),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => EditProfilePage(),
                      //   ),
                      // );
                    },
                  ),
                  Divider(),
                  SizedBox(height: 20),
                  Text(
                    'Appointments',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.agendas.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return state.agendas.isEmpty
                          ? Text('No Appoinents Right Now')
                          : _buildApointment(state.agendas[index]);
                    },
                  )
                ],
              ),
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

  Widget _buildApointment(AgendaModel agendaModel) {
    return ListTile(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         AppointmentDetailsPage(appointment: appointment),
        //   ),
        // );
      },
      leading: CircleAvatar(
        child: Text(
          'A',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      title: Text(
        agendaModel.full_name,
      ),
      trailing: Icon(Icons.chevron_right),
    );
  }
}
