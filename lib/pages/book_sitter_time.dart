import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/models/local/service_order.dart';
import 'package:nanny_mctea_sitters_flutter/models/sitter.dart';
import 'package:nanny_mctea_sitters_flutter/pages/book_sitter_sitter.dart';

class BookSitterTimePage extends StatefulWidget {
  final List<dynamic> _slots;
  final Map<Sitter, List<DateTime>> _sitterSlotMap;
  final ServiceOrder serviceOrder;

  BookSitterTimePage(this._slots, this._sitterSlotMap, this.serviceOrder);

  @override
  State createState() =>
      BookSitterTimePageState(this._slots, this._sitterSlotMap, this.serviceOrder);
}

class BookSitterTimePageState extends State<BookSitterTimePage>
    with SingleTickerProviderStateMixin {
  BookSitterTimePageState(this._slots, this._sitterSlotMap, this.serviceOrder);

  final List<dynamic> _slots;
  final Map<Sitter, List<DateTime>> _sitterSlotMap;
  final ServiceOrder serviceOrder;
  final String timeFormat = 'hh:mm a';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  dynamic _selected;

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
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _slots.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return _buildSlot(
                  _slots[index],
                );
              },
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
              onPressed: () {
              },
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
                List<Sitter> availableSitters = List<Sitter>();

                //Pick sitters for the slot selected.
                _sitterSlotMap.forEach(
                  (sitter, slots) {
                    slots.forEach(
                      (slot) {
                        if (_selected == slot) {
                          availableSitters.add(sitter);
                        }
                      },
                    );
                  },
                );

                //Attach date to service order.
                serviceOrder.date = _selected;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookSitterSitterPage(availableSitters, serviceOrder),
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

  _buildAppBar() {
    return AppBar(
      title: Text('PICK A TIME'),
      centerTitle: true,
    );
  }

  Widget _buildSlot(dynamic slot) {
    return InkWell(
      child: ListTile(
        title: Text(
          DateFormat(timeFormat).format(slot),
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
