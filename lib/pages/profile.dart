import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
import 'package:table_calendar/table_calendar.dart';

class ProfilePage extends StatefulWidget {
  final String id;

  ProfilePage(this.id);

  @override
  State createState() => ProfilePageState(this.id);
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final String id;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;

  ProfilePageState(this.id);

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(),
        body: TabBarView(
          children: [
            SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Trey Hope',
                    style: TextStyle(color: Colors.grey, fontSize: 25),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Email',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'trey.a.hope@gmail.com',
                    style: TextStyle(color: Colors.grey, fontSize: 25),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Phone',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '(937)270-5527',
                    style: TextStyle(color: Colors.grey, fontSize: 25),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  MaterialButton(
                    child: Text(
                      'EDIT',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {},
                    color: Colors.blue,
                  )
                ],
              ),
            )),
            false
                ? ListView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return _buildApointmentCard();
                    },
                  )
                : Center(
                    child: Text('You have nothing booked at the moment.'),
                  ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('MY PROFILE'),
      centerTitle: true,
      bottom: TabBar(
        tabs: [
          Tab(
            child: Text(
              'My Info',
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
            child: Text(
              'My Appointments',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApointmentCard() {
    return InkWell(
      onTap: () {
        Modal.showInSnackBar(_scaffoldKey, 'Selected Appointment');
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
        ),
        title: Text('Appointment 1'),
        subtitle: Text('Talea Chenault'),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
