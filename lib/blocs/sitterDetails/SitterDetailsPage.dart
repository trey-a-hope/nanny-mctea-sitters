import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/ServiceLocator.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/sitterDetails/Bloc.dart'
    as SITTER_DETAILS_BP;
import 'package:nanny_mctea_sitters_flutter/blocs/messages/Bloc.dart'
    as MESSAGES_BP;
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/models/firebase/Conversation.dart';
import 'package:nanny_mctea_sitters_flutter/pages/messages/MessagePage.dart';
import 'package:nanny_mctea_sitters_flutter/services/ModalService.dart';
import 'package:nanny_mctea_sitters_flutter/services/UserService.dart';

class SitterDetailsPage extends StatefulWidget {
  SitterDetailsPage();

  @override
  State createState() => SitterDetailsPageState();
}

class SitterDetailsPageState extends State<SitterDetailsPage>
    implements SITTER_DETAILS_BP.SitterDetailsBlocDelegate {
  SitterDetailsPageState();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String dateFormat = 'MMM d, yyyy';
  final String timeFormat = 'hh:mm a';
  SITTER_DETAILS_BP.SitterDetailsBloc _bloc;

  @override
  void initState() {
    //Assign new instance of bloc and set delegate.
    _bloc = BlocProvider.of<SITTER_DETAILS_BP.SitterDetailsBloc>(context);
    _bloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sitter Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          //Button to message this sitter.
          IconButton(
            icon: Icon(
              Icons.message,
            ),
            onPressed: () {
              _bloc.add(
                SITTER_DETAILS_BP.SendMessageEvent(),
              );
            },
          )
        ],
      ),
      key: _scaffoldKey,
      body: BlocBuilder<SITTER_DETAILS_BP.SitterDetailsBloc,
          SITTER_DETAILS_BP.SitterDetailsState>(
        builder:
            (BuildContext context, SITTER_DETAILS_BP.SitterDetailsState state) {
          if (state is SITTER_DETAILS_BP.LoadingState) {
            return Spinner();
          }

          if (state is SITTER_DETAILS_BP.LoadedState) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    fadeInCurve: Curves.easeIn,
                    imageUrl: state.sitter.imgUrl,
                  ),
                ),
                _buildInfoBox(sitter: state.sitter),
                _buildBio()
              ],
            );
          }

          return Center(
            child: Text('you should never see this.'),
          );
        },
      ),
    );
  }

  Widget _buildInfoBox({@required UserModel sitter}) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 120.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(sitter.name,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        sitter.details,
                        style: TextStyle(fontSize: 20),
                      ),
                      // subtitle: Text(_gem.subCategory),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
                image: CachedNetworkImageProvider(sitter.imgUrl),
                fit: BoxFit.cover),
          ),
          margin: EdgeInsets.only(left: 16.0),
        ),
      ],
    );
  }

  Widget _buildBio() {
    return Card(
      elevation: 4,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Bio',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(15),
            child: Text('sitter bio'),
          )
        ],
      ),
    );
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>()
        .showInSnackBar(scaffoldKey: _scaffoldKey, message: message);
  }

  @override
  void navigateToMessageThread({
    UserModel currentUser,
    UserModel sitter,
  }) async {
    try {
      final ChatUser sendee = ChatUser(
          name: sitter.name,
          uid: sitter.id,
          avatar: sitter.imgUrl,
          fcmToken: sitter.fcmToken);

      final ChatUser sender = ChatUser(
          name: currentUser.name,
          uid: currentUser.id,
          avatar: currentUser.imgUrl,
          fcmToken: currentUser.fcmToken);

      Query query = Firestore.instance.collection('Conversations');

      query = query.where(currentUser.id, isEqualTo: true);
      query = query.where(sitter.id, isEqualTo: true);

      List<DocumentSnapshot> docs = (await query.getDocuments()).documents;

      DocumentReference convoDocRef;
      //Creat a new conversation document if one does not already exist.
      if (docs.isEmpty) {
        convoDocRef = Firestore.instance.collection('Conversations').document();
        convoDocRef.setData({
          'id': convoDocRef.documentID,
          sender.uid: true,
          sendee.uid: true,
          'users': [sender.uid, sendee.uid],
          'time': DateTime.now(),
          'lastMessage': ''
        });
      } else {
        convoDocRef = docs.first.reference;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessagePage(
            sendee: sendee,
            sender: sender,
            convoDocRef: convoDocRef,
          ),
        ),
      );
    } catch (e) {
      locator<ModalService>().showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }
}
