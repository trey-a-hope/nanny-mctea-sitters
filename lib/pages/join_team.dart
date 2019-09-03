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
              posted: 'Aug 3rd, 2019',
              description: 'Norwood / Montgomery families seeking Full Time long term nanny to join the team.  Families are seeking fun, reliable nanny.  Care will take place in host families home in Montgomery with 2 sometimes 3 infants. Hours are 7:30 am - 5:30 pm. Pay starts at \$15/hr',
            ),
            JoinTeamWidget(
              image: group_nannies,
              title: ('Part Time Nanny'),
              posted: 'Aug 8th, 2019',
              description: 'Hyde Park family seeks part time nanny for a long term contract with 4 year old girl. Hours Include: -Monday - Friday 6:30 am - 8:30 am . -Monday - Wednesday 3 pm - 5:30 pm  -Thursday & Friday 11 am - 4:30 pm  Some household chores are expected such as loading and unloading dishwasher. Child\'s laundry.  Family is seeking a reliable, experienced and enthusiastic individual. Pay starts at \$15/hr and is based on education and experience.',
            ),
            JoinTeamWidget(
              image: group_nannies,
              title: ('Temporary Part Time Nanny'),
              posted: 'Aug 3rd, 2019',
              description: 'Lawrenceburg family seeks part time to full time nanny to assist in the transition of current nanny while away on maternity leave. Starting early / mid October until late May. Hours are 7:30 am - 5:30 pm ; Child will be 9 months at that time. Pay is starting at \$15/hr',
            ),
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
          Tab(
            child: Text('Part Time',textAlign: TextAlign.center,),
          ),
          Tab(
            child: Text('Temporary Part Time',textAlign: TextAlign.center,),
          ),
        ],
      ),
      title: Text('JOIN THE TEAM'),
      centerTitle: true,
    );
  }
}
