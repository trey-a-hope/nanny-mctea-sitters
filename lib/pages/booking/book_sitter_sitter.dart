import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/local/service_order.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/pages/booking/book_sitter_info.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookSitterSitterPage extends StatefulWidget {
  final List<User> availableSitters;
  final Appointment appointment;

  BookSitterSitterPage({@required this.availableSitters, @required this.appointment});

  @override
  State createState() =>
      BookSitterSitterPageState(availableSitters: availableSitters, appointment: appointment);
}

class BookSitterSitterPageState extends State<BookSitterSitterPage> {
  BookSitterSitterPageState({@required this.availableSitters, @required this.appointment});

  final List<User> availableSitters;
  final Appointment appointment;
  User _selectedSitter;
  bool _isLoading = true;

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isLoading
          ? Spinner()
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ScaffoldClipper(
                    simpleNavbar: SimpleNavbar(
                      leftWidget:
                          Icon(MdiIcons.chevronLeft, color: Colors.white),
                      leftTap: () {
                        Navigator.of(context).pop();
                      },
                      // rightWidget: Icon(Icons.refresh, color: Colors.white),
                      // rightTap: () async {
                      //   await _getSlotsAndCaledar();
                      // },
                    ),
                    title: 'Book Sitter',
                    subtitle: 'Select a sitter.',
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: availableSitters.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return _buildSitterWidget(availableSitters[index]);
                    },
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSitterWidget(User sitter) {
    return InkWell(
      onTap: () {
        setState(
          () {
            _selectedSitter = sitter;
          },
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(sitter.imgUrl),
        ),
        title: Text(sitter.name),
        subtitle: Text(sitter.details),
        trailing: CircleAvatar(
          backgroundColor:
              _selectedSitter == sitter ? Colors.green : Colors.red,
          child: _selectedSitter == sitter
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Icon(Icons.close, color: Colors.white),
        ),
      ),
    );
  }

  Container _buildBottomNavigationBar() {
    return (_selectedSitter == null)
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: RaisedButton(
              onPressed: () {},
              color: Colors.grey.shade200,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      MdiIcons.close,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      'NO SITTER SELECTED',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: RaisedButton(
              onPressed: () {
                //Attach selected sitter to service order.
                appointment.sitter = _selectedSitter;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookSitterInfoPage(appointment: appointment,),
                  ),
                );
              },
              color: Colors.grey.shade200,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      MdiIcons.check,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      'FINISH UP',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
