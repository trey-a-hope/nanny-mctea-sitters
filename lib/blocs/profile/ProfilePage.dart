import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/profile/Bloc.dart'
    as PROFILE_BP;
import 'package:nanny_mctea_sitters_flutter/blocs/appointments/Bloc.dart'
    as APPOINTMENTS_BP;
import 'package:nanny_mctea_sitters_flutter/blocs/editProfile/Bloc.dart'
    as EDIT_PROFILE_BP;
import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AgendaModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/supersaas/AppointmentModel.dart';
import 'package:nanny_mctea_sitters_flutter/pages/messages/messages_page.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';

import '../../ServiceLocator.dart';
import '../../asset_images.dart';

class ProfilePage extends StatefulWidget {
  @override
  State createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String timeFormat = 'MMM d, yyyy @ hh:mm a';
  PROFILE_BP.ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();

    profileBloc = BlocProvider.of<PROFILE_BP.ProfileBloc>(context);
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Route route = MaterialPageRoute(
                builder: (BuildContext context) => BlocProvider(
                  create: (BuildContext context) =>
                      EDIT_PROFILE_BP.EditProfileBloc()
                        ..add(
                          EDIT_PROFILE_BP.LoadPageEvent(),
                        ),
                  child: EDIT_PROFILE_BP.EditProfilePage(),
                ),
              );

              Navigator.push(context, route);
            },
          )
        ],
      ),
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<PROFILE_BP.ProfileBloc, PROFILE_BP.ProfileState>(
        listener: (BuildContext context, PROFILE_BP.ProfileState state) {},
        builder: (BuildContext context, PROFILE_BP.ProfileState state) {
          if (state is PROFILE_BP.LoadingState) {
            return Spinner();
          } else if (state is PROFILE_BP.LoadedState) {
            return SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3),
                            BlendMode.darken,
                          ),
                          image: Image(
                            image: imgAllIn.image,
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.darken,
                            color: Colors.black87,
                          ).image,
                          fit: BoxFit.cover),
                    ),
                    width: double.infinity,
                    height: 250,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
                    child: Column(
                      children: <Widget>[
                        buildUserImage(
                            currentUser: state.currentUser,
                            agendas: state.agendas),
                        SizedBox(height: 20.0),
                        buildUserInformation(
                            currentUser: state.currentUser,
                            agendas: state.agendas),
                        SizedBox(
                          height: 20,
                        ),
                        // buildResources(),
                        // buildCamps(),
                        // buildVideos()
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is PROFILE_BP.ErrorState) {
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

  Widget buildUserImage({
    @required UserModel currentUser,
    @required List<AgendaModel> agendas,
  }) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.only(top: 16.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 96.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${currentUser.name}',
                      style: Theme.of(context).textTheme.title,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(currentUser.email),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 10.0),
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: Column(
              //         children: <Widget>[
              //           Text('${agendas.length}'),
              //           Text("Appointments")
              //         ],
              //       ),
              //     ),
              //     Expanded(
              //       child: Column(
              //         children: <Widget>[Text('${4}'), Text("Camps")],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
        InkWell(
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                  image: NetworkImage(currentUser.imgUrl), fit: BoxFit.cover),
            ),
            margin: EdgeInsets.only(left: 16.0),
          ),
          onTap: () async {
            //Prompt user to select what image source.
            int choice = await locator<ModalService>().showOptions(
              context: context,
              title: 'Add Photo',
              options: [
                'Take A Photo',
                'Choose From Gallery',
              ],
            );

            //Take user to camera or gallery.
            switch (choice) {
              case 0:
                profileBloc.add(
                  PROFILE_BP.HandleImageEvent(
                      userID: currentUser.id, imageSource: ImageSource.camera),
                );
                break;
              case 1:
                profileBloc.add(
                  PROFILE_BP.HandleImageEvent(
                      userID: currentUser.id, imageSource: ImageSource.gallery),
                );
                break;
              default:
                break;
            }
          },
        ),
      ],
    );
  }

  Widget buildUserInformation({
    @required UserModel currentUser,
    @required List<AgendaModel> agendas,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Appointments - ${agendas.length}"),
            trailing: agendas.isNotEmpty
                ? InkWell(
                    child: Text(
                      'View All',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Route route = MaterialPageRoute(
                        builder: (BuildContext context) => BlocProvider(
                          create: (BuildContext context) =>
                              APPOINTMENTS_BP.AppointmentsBloc(
                                  agendas: agendas),
                          child: APPOINTMENTS_BP.AppointmentsPage(),
                        ),
                      );

                      Navigator.push(context, route);
                    },
                  )
                : SizedBox.shrink(),
          ),
          // Divider(),
          // ListTile(
          //   title: Text("Email"),
          //   subtitle: Text(currentUser.email),
          //   leading: Icon(Icons.email),
          // ),
          // ListTile(
          //   title: Text("Phone"),
          //   subtitle: Text(currentUser.phone ?? 'N/A'),
          //   leading: Icon(Icons.phone),
          // ),
          // ListTile(
          //   title: Text("Joined Date"),
          //   subtitle: Text(
          //     DateFormat(DATE_FORMAT_FULL).format(currentUser.time),
          //   ),
          //   leading: Icon(Icons.calendar_view_day),
          // ),
        ],
      ),
    );
  }

  // Widget _buildApointment(AgendaModel agendaModel) {
  //   return ListTile(
  //     onTap: () {
  //                      Route route = MaterialPageRoute(
  //                       builder: (BuildContext context) => BlocProvider(
  //                         create: (BuildContext context) =>
  //                             PAYMENT_METHOD_BLOC.PaymentMethodBloc()
  //                               ..add(PAYMENT_METHOD_BLOC.LoadPageEvent()),
  //                         child: PAYMENT_METHOD_BLOC.PaymentMethodPage(),
  //                       ),
  //                     );

  //                     Navigator.push(context, route);
  //     },
  //     leading: CircleAvatar(
  //       child: Text(
  //         'A',
  //         style: TextStyle(color: Colors.white),
  //       ),
  //       backgroundColor: Colors.blue,
  //     ),
  //     title: Text(
  //       agendaModel.full_name,
  //     ),
  //     trailing: Icon(Icons.chevron_right),
  //   );
  // }
}
