import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/slot.dart';
import 'package:nanny_mctea_sitters_flutter/models/local/service_order.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/pages/booking/book_sitter_sitter.dart';

class BookSitterTimePage extends StatefulWidget {
  final List<dynamic> _slots;
  final Map<User, List<Slot>> _sitterSlotMap;
  final ServiceOrder serviceOrder;

  BookSitterTimePage(this._slots, this._sitterSlotMap, this.serviceOrder);

  @override
  State createState() => BookSitterTimePageState(
      this._slots, this._sitterSlotMap, this.serviceOrder);
}

class BookSitterTimePageState extends State<BookSitterTimePage> {
  BookSitterTimePageState(this._slots, this._sitterSlotMap, this.serviceOrder);

  final List<dynamic> _slots;
  final Map<User, List<Slot>> _sitterSlotMap;
  final ServiceOrder serviceOrder;
  final String timeFormat = 'hh:mm a';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  Slot _selected;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    //Sort slots.
    _slots.sort(
          (a, b) => a.time.compareTo(
            b.time,
          ),
        );

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                    subtitle: 'Select a time.',
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _slots.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return _buildSlot(
                        _slots[index],
                      );
                    },
                  )
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Container _buildBottomNavigationBar() {
    return _selected == null
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
                      'NO TIME SELECTED',
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
                List<User> availableSitters = List<User>();

                //Pick sitters for the slot selected.
                _sitterSlotMap.forEach(
                  (sitter, slots) {
                    slots.forEach(
                      (slot) {
                        if (_selected.time == slot.time) {
                          availableSitters.add(sitter);
                        }
                      },
                    );
                  },
                );

                //Attach slot to order.
                serviceOrder.slot = _selected;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BookSitterSitterPage(availableSitters, serviceOrder),
                  ),
                );
              },
              color: Colors.grey.shade200,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      MdiIcons.faceAgent,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      'PICK A SITTER',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildSlot(Slot slot) {
    return InkWell(
      child: ListTile(
        title: Text(
          DateFormat(timeFormat).format(slot.time),
        ),
        leading: CircleAvatar(
          backgroundColor: _selected == slot ? Colors.green : Colors.red,
          child: _selected == slot
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Icon(Icons.close, color: Colors.white),
        ),
      ),
      onTap: () {
        setState(
          () {
            _selected = slot;
          },
        );
      },
    );
  }
}
