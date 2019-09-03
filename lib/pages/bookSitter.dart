import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/common/join_team_widget.dart';
import 'package:nanny_mctea_sitters_flutter/services/modal.dart';

class BookSitterPage extends StatefulWidget {
  @override
  State createState() => BookSitterPageState();
}

class BookSitterPageState extends State<BookSitterPage>
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
        key: _scaffoldKey,
        appBar: _buildAppBar(),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext ctxt, int index) {
                return ExpansionTile(
                  title: Text(
                    "4 Hour Sitter Service | 4 hr \$77",
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking: - The rate for this service is \$13 / hr + \$25 booking fee -HERE is...",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                         MaterialButton(
                        onPressed: (){
                          Modal.showInSnackBar(_scaffoldKey, 'Proceed to Calendar');
                        },
                        color: Colors.green,
                        child: Text('Get More Info', style: TextStyle(color: Colors.white))
                      ),
                       MaterialButton(
                        onPressed: (){
                          Modal.showInSnackBar(_scaffoldKey, 'Proceed to Calendar');
                        },
                        color: Colors.blue,
                        child: Text('Book It', style: TextStyle(color: Colors.white))
                      )
                      ],
                    ),
                    )
                  ],
                );
              },
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
            child: Text(
              'Child Care Service',
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
              child: Text(
            'Fees & Registration',
            textAlign: TextAlign.center,
          )),
          Tab(
              child: Text(
            'Monthly Sitter Membership',
            textAlign: TextAlign.center,
          )),
        ],
      ),
      title: Text('BOOK A SITTER'),
      centerTitle: true,
    );
  }
}

class Entry {
  String title;
  String description;
  // final List<Entry> children;
  Entry(@required title, @required description) {
    this.title = title;
    this.description = description;
  }
}

final List<Entry> data = <Entry>[
  Entry(
    '4 Hour Sitter Service - 4 hr | \$77',
    <Entry>[
      Entry(
        'Section A0',
        'Thank you for interest in booking a Nanny McTea Sitter! A few things to remember while booking: - The rate for this service is \$13 / hr + \$25 booking fee',
      ),
    ],
  ),
];

class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    // if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
