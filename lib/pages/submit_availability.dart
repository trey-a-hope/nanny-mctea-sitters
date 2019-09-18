import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/sitter_widget_x.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/appointment.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/sitter.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/slot.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';

class SubmitAvailabilityPage extends StatefulWidget {

  SubmitAvailabilityPage();

  @override
  State createState() => SubmitAvailabilityPageState();
}

class SubmitAvailabilityPageState extends State<SubmitAvailabilityPage>
    with SingleTickerProviderStateMixin {
  SubmitAvailabilityPageState();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String dateFormat = 'MMM d, yyyy';
  final String timeFormat = 'hh:mm a';

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
      appBar: _buildAppBar(),
      key: _scaffoldKey,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Text('Trey')
            ),
    );
  }

 
  AppBar _buildAppBar() {
    return AppBar(
      title: Text('SUBMIT AVAILABILITY'),
      centerTitle: true,
    );
  }
}
