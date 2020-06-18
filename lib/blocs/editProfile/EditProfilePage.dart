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

import 'Bloc.dart' as EDIT_PROFILE_BP;

class EditProfilePage extends StatefulWidget {
  @override
  State createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  EDIT_PROFILE_BP.EditProfileBloc editProfileBloc;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  @override
  void initState() {
    super.initState();

    editProfileBloc = BlocProvider.of<EDIT_PROFILE_BP.EditProfileBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[],
      ),
      key: _scaffoldKey,
      body: SafeArea(
        child: BlocConsumer<EDIT_PROFILE_BP.EditProfileBloc,
            EDIT_PROFILE_BP.EditProfileState>(
          listener:
              (BuildContext context, EDIT_PROFILE_BP.EditProfileState state) {
            // if (state is LoginSuccessfulState) {
            //   Navigator.of(context).pop();
            // }
          },
          builder:
              (BuildContext context, EDIT_PROFILE_BP.EditProfileState state) {
            if (state is EDIT_PROFILE_BP.LoadingState) {
              return Spinner();
            }

            if (state is EDIT_PROFILE_BP.LoadedState) {
              _nameController.text = state.currentUser.name;
              _phoneController.text = state.currentUser.phone;

              return Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      maxLengthEnforced: true,
                      // maxLength: MyFormData.nameCharLimit,
                      onFieldSubmitted: (term) {},
                      validator: locator<ValidatorService>().isEmpty,
                      onSaved: (value) {},
                      decoration: InputDecoration(
                        hintText: 'Name',
                        icon: Icon(Icons.face, color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      maxLengthEnforced: true,
                      // maxLength: MyFormData.nameCharLimit,
                      onFieldSubmitted: (term) {},
                      validator: locator<ValidatorService>().mobile,
                      onSaved: (value) {},
                      decoration: InputDecoration(
                        hintText: 'Phone',
                        icon: Icon(Icons.phone, color: Colors.grey),
                      ),
                    ),
                    Spacer(),
                    RaisedButton(
                      onPressed: () async {
                        bool confirm = await locator<ModalService>()
                            .showConfirmation(
                                context: context,
                                title: 'Update',
                                message: 'Are you sure?');
                        if (confirm) {
                          editProfileBloc.add(
                            EDIT_PROFILE_BP.SubmitEvent(
                                name: _nameController.text,
                                phone: _phoneController.text),
                          );
                        }
                      },
                      textColor: Colors.white,
                      color: Colors.red,
                      child: Text('Save'),
                    )
                  ],
                ),
              );
            }
            return Container();

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
      ),
    );
  }
}
