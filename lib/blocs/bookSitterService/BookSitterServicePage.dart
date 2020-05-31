import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanny_mctea_sitters_flutter/blocs/bookSitterService/Bloc.dart';

class BookSitterServicePage extends StatefulWidget {
  @override
  State createState() => BookSitterServicePageState();
}

class BookSitterServicePageState extends State<BookSitterServicePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BookSitterServiceBloc bookSitterServiceBloc;
  @override
  void initState() {
    super.initState();

    bookSitterServiceBloc = BlocProvider.of<BookSitterServiceBloc>(context);
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
      body: BlocConsumer<BookSitterServiceBloc, BookSitterServiceState>(
        listener: (BuildContext context, BookSitterServiceState state) {},
        builder: (BuildContext context, BookSitterServiceState state) {
          if (state is ChildCareServiceState) {
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
                              ToggleEvent(tab: 0),
                            );
                          },
                        ),
                        SizedBox(width: 20),
                        RaisedButton(
                          child: Text('Fees & Registration'),
                          onPressed: () {
                            bookSitterServiceBloc.add(
                              ToggleEvent(tab: 1),
                            );
                          },
                        ),
                        SizedBox(width: 20),
                        RaisedButton(
                          child: Text('Monthly Sitter Membership'),
                          onPressed: () {
                            bookSitterServiceBloc.add(
                              ToggleEvent(tab: 2),
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
                      state.services[index],
                )
              ],
            );
          } else if (state is FeesRegistrationState) {
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
                              ToggleEvent(tab: 0),
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
                              ToggleEvent(tab: 1),
                            );
                          },
                        ),
                        SizedBox(width: 20),
                        RaisedButton(
                          child: Text('Monthly Sitter Membership'),
                          onPressed: () {
                            bookSitterServiceBloc.add(
                              ToggleEvent(tab: 2),
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
                      state.services[index],
                )
              ],
            );
          } else if (state is MonthlySitterMembershipState) {
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
                              ToggleEvent(tab: 0),
                            );
                          },
                        ),
                        SizedBox(width: 20),
                        RaisedButton(
                          child: Text('Fees & Registration'),
                          onPressed: () {
                            bookSitterServiceBloc.add(
                              ToggleEvent(tab: 1),
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
                              ToggleEvent(tab: 2),
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
                      state.services[index],
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
}
