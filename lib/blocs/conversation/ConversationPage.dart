import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanny_mctea_sitters_flutter/common/ConversationListTile.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/UserModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/ConversationService.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

class ConversationPage extends StatefulWidget {
  @override
  State createState() => ConversationPageState();
}

class ConversationPageState extends State<ConversationPage> {
  double imageSize = 120;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ConversationBloc conversationBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    locator<ConversationsService>().cancelConversationSubscription();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    conversationBloc = BlocProvider.of<ConversationBloc>(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: BlocConsumer<ConversationBloc, ConversationState>(
        listener: (BuildContext context, ConversationState state) async {},
        builder: (BuildContext context, ConversationState state) {
          if (state is LoadingState) {
            return Spinner();
          } else if (state is LoadedState) {
            List<DocumentSnapshot> docs = state.querySnapshot.documents;

            //Sort the conversations by time client side, server side requires an index.
            docs.sort(
              (a, b) {
                DateTime aDate = a.data['time'].toDate();
                DateTime bDate = b.data['time'].toDate();
                return bDate.compareTo(aDate);
              },
            );

            return buildView(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              currentUser: state.currentUser,
              mainWidget: Expanded(
                flex: 6,
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot conversationDoc = docs[index];
                    return ConversationListTile(
                      key: UniqueKey(),
                      conversationDoc: conversationDoc,
                      currentUser: state.currentUser,
                    );
                  },
                ),
              ),
            );
          } else if (state is NoConversationsState) {
            return buildView(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              currentUser: state.currentUser,
              mainWidget: Center(
                child: Text('No messages...'),
              ),
            );
          } else {
            ErrorState errorState = state as ErrorState;
            return Center(
              child: Text('Error: ${errorState.error.toString()}'),
            );
          }
        },
      ),
    );
  }

  Widget buildView({
    @required double screenWidth,
    @required double screenHeight,
    @required UserModel currentUser,
    @required Widget mainWidget,
  }) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          width: screenWidth,
          height: screenHeight,
        ),
        Stack(
          children: <Widget>[
            Container(
              height: imageSize + 100,
              width: screenWidth,
              color: Colors.blue,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(
                    currentUser.name,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: showSelectImageDialog,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(currentUser.imgUrl),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: imageSize,
          child: Container(
            height: screenHeight - imageSize,
            width: screenWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Container(
              height: screenHeight - imageSize,
              width: screenWidth,
              child: Column(
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Messages',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  mainWidget,
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.message,
                          size: 15,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Thanks for using this app!',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  showSelectImageDialog() {
    return Platform.isIOS ? iOSBottomSheet() : androidDialog();
  }

  iOSBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Add Photo'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Take Photo'),
                onPressed: () {
                  Navigator.of(context).pop();

                  conversationBloc
                      .add(UpdatePhotoEvent(imageSource: ImageSource.camera));
                },
              ),
              CupertinoActionSheetAction(
                child: Text('Choose From Gallery'),
                onPressed: () {
                  Navigator.of(context).pop();
                  conversationBloc
                      .add(UpdatePhotoEvent(imageSource: ImageSource.gallery));
                },
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  androidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Add Photo'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Take Photo'),
              onPressed: () {
                Navigator.of(context).pop();

                conversationBloc
                    .add(UpdatePhotoEvent(imageSource: ImageSource.camera));
              },
            ),
            SimpleDialogOption(
              child: Text('Choose From Gallery'),
              onPressed: () {
                Navigator.of(context).pop();

                conversationBloc
                    .add(UpdatePhotoEvent(imageSource: ImageSource.gallery));
              },
            ),
            SimpleDialogOption(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }
}
