import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/bookSitterService/Bloc.dart'
    as BookSitterServiceBP;
import 'package:nanny_mctea_sitters_flutter/blocs/bookSitterCalendar/Bloc.dart'
    as BookSitterCalendarBP;

class BookSitterServicePage extends StatefulWidget {
  @override
  State createState() => BookSitterServicePageState();
}

class BookSitterServicePageState extends State<BookSitterServicePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BookSitterServiceBP.BookSitterServiceBloc bookSitterServiceBloc;

  @override
  void initState() {
    super.initState();

    bookSitterServiceBloc =
        BlocProvider.of<BookSitterServiceBP.BookSitterServiceBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Sitter - Service',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<BookSitterServiceBP.BookSitterServiceBloc,
          BookSitterServiceBP.BookSitterServiceState>(
        listener: (BuildContext context,
            BookSitterServiceBP.BookSitterServiceState state) {
          if (state is BookSitterServiceBP.NavigateToBookSitterCalendarState) {
            //Create route to Book Sitter Calendar Page.
            Route route = MaterialPageRoute(
              builder: (BuildContext context) => BlocProvider(
                create: (BuildContext context) =>
                    BookSitterCalendarBP.BookSitterCalendarBloc(
                  service: state.service,
                  hours: state.hours,
                  cost: state.cost,
                )..add(
                        BookSitterCalendarBP.LoadPageEvent(),
                      ),
                child: BookSitterCalendarBP.BookSitterCalendarPage(),
              ),
            );
            //Push route.
            Navigator.push(context, route);
          }
        },
        builder: (BuildContext context,
            BookSitterServiceBP.BookSitterServiceState state) {
          if (state is BookSitterServiceBP.ChildCareServiceState) {
            return ListView(
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.red,
                          child: Text(
                            'Child Care Service',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            bookSitterServiceBloc.add(
                              BookSitterServiceBP.ToggleEvent(tab: 0),
                            );
                          },
                        ),
                        SizedBox(width: 20),
                        RaisedButton(
                          child: Text('Fees & Registration'),
                          onPressed: () {
                            bookSitterServiceBloc.add(
                              BookSitterServiceBP.ToggleEvent(tab: 1),
                            );
                          },
                        ),
                        SizedBox(width: 20),
                        RaisedButton(
                          child: Text('Monthly Sitter Membership'),
                          onPressed: () {
                            bookSitterServiceBloc.add(
                              BookSitterServiceBP.ToggleEvent(tab: 2),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.services.length,
                  itemBuilder: (BuildContext ctxt, int index) =>
                      _buildBookSitterTileWidget(
                    service: state.services[index]['service'],
                    description: state.services[index]['description'],
                    cost: state.services[index]['cost'],
                    hours: state.services[index]['hours'],
                  ),
                )
              ],
            );
          } else if (state is BookSitterServiceBP.FeesRegistrationState) {
            return ListView(
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                          child: Text('Child Care Service'),
                          onPressed: () {
                            bookSitterServiceBloc.add(
                              BookSitterServiceBP.ToggleEvent(tab: 0),
                            );
                          },
                        ),
                        SizedBox(width: 20),
                        RaisedButton(
                          color: Colors.red,
                          child: Text(
                            'Fees & Registration',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            bookSitterServiceBloc.add(
                              BookSitterServiceBP.ToggleEvent(tab: 1),
                            );
                          },
                        ),
                        SizedBox(width: 20),
                        RaisedButton(
                          child: Text('Monthly Sitter Membership'),
                          onPressed: () {
                            bookSitterServiceBloc.add(
                              BookSitterServiceBP.ToggleEvent(tab: 2),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.services.length,
                  itemBuilder: (BuildContext ctxt, int index) =>
                      _buildBookSitterTileWidget(
                    service: state.services[index]['service'],
                    description: state.services[index]['description'],
                    cost: state.services[index]['cost'],
                    hours: state.services[index]['hours'],
                  ),
                )
              ],
            );
          } else if (state
              is BookSitterServiceBP.MonthlySitterMembershipState) {
            return ListView(
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                          child: Text('Child Care Service'),
                          onPressed: () {
                            bookSitterServiceBloc.add(
                              BookSitterServiceBP.ToggleEvent(tab: 0),
                            );
                          },
                        ),
                        SizedBox(width: 20),
                        RaisedButton(
                          child: Text('Fees & Registration'),
                          onPressed: () {
                            bookSitterServiceBloc.add(
                              BookSitterServiceBP.ToggleEvent(tab: 1),
                            );
                          },
                        ),
                        SizedBox(width: 20),
                        RaisedButton(
                          color: Colors.red,
                          child: Text(
                            'Monthly Sitter Membership',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            bookSitterServiceBloc.add(
                              BookSitterServiceBP.ToggleEvent(tab: 2),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.services.length,
                  itemBuilder: (BuildContext ctxt, int index) =>
                      _buildBookSitterTileWidget(
                    service: state.services[index]['service'],
                    description: state.services[index]['description'],
                    cost: state.services[index]['cost'],
                    hours: state.services[index]['hours'],
                  ),
                )
              ],
            );
          } else {
            return Center(
              child: Text('You should NEVER see this.'),
            );
          }
        },
      ),
    );
  }

  Widget _buildBookSitterTileWidget({
    @required String service,
    @required String description,
    @required int hours,
    @required double cost,
  }) {
    return ExpansionTile(
      title: Text(
        service,
        style: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      children: <Widget>[
        ListTile(
          title: Text(
            description,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '\n'),
                TextSpan(
                  text: 'Cancellation Policy:',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '\n\n'),
                TextSpan(
                    text:
                        'Please cancel at least 48 hours in advance if you wish to cancel your sitter service. If you cancel with less than 24 hours before service no refund will be given.',
                    style: TextStyle(color: Colors.grey))
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: RaisedButton(
            color: Colors.red,
            onPressed: () {
              bookSitterServiceBloc.add(
                BookSitterServiceBP.NavigateToBookSitterCalendarEvent(
                    cost: cost, hours: hours, service: service),
              );
            },
            child: Text(
              'Book It',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
