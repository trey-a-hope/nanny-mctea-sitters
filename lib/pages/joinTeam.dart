import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/common/join_team_widget.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';

class JoinTeamPage extends StatefulWidget {
  @override
  State createState() => JoinTeamPageState();
}

class JoinTeamPageState extends State<JoinTeamPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: TabBarView(
          children: [
            JoinTeamWidget(
              image: group_nannies,
              title: ('Full Time Nanny'),
            ),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      bottom: TabBar(
        tabs: [
          Tab(
            child: Text('Full Time',textAlign: TextAlign.center,),
          ),
          Tab(child: Text('Part Time',textAlign: TextAlign.center,)),
          Tab(child: Text('Temporary Part Time', textAlign: TextAlign.center,)),
        ],
      ),
      title: Text('JOIN THE TEAM'),
      centerTitle: true,
    );
  }
}
