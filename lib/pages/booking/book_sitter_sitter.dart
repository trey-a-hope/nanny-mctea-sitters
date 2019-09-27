import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/models/local/service_order.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/user.dart';
import 'package:nanny_mctea_sitters_flutter/pages/booking/book_sitter_info.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookSitterSitterPage extends StatefulWidget {
  final List<Sitter> _availableSitters;
  final ServiceOrder serviceOrder;

  BookSitterSitterPage(this._availableSitters, this.serviceOrder);

  @override
  State createState() =>
      BookSitterSitterPageState(this._availableSitters, this.serviceOrder);
}

class BookSitterSitterPageState extends State<BookSitterSitterPage>
    with SingleTickerProviderStateMixin {
  BookSitterSitterPageState(this._availableSitters, this.serviceOrder);

  final List<Sitter> _availableSitters;
  final ServiceOrder serviceOrder;
  Sitter _selectedSitter;
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _availableSitters.length,
              itemBuilder: (BuildContext ctx, int index) {
                return _buildSitterWidget(_availableSitters[index]);
              },
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('PICK A SITTER'),
      centerTitle: true,
    );
  }

  Widget _buildSitterWidget(Sitter sitter) {
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
          backgroundColor: _selectedSitter == sitter ? Colors.green : Colors.red,
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
                serviceOrder.sitter = _selectedSitter;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookSitterInfoPage(serviceOrder),
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
