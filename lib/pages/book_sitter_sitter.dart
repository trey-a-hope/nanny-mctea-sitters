import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/constants.dart';
import 'package:nanny_mctea_sitters_flutter/models/sitter.dart';
import 'package:nanny_mctea_sitters_flutter/pages/book_sitter_info.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookSitterSitterPage extends StatefulWidget {
  BookSitterSitterPage();

  @override
  State createState() => BookSitterSitterPageState();
}

class BookSitterSitterPageState extends State<BookSitterSitterPage>
    with SingleTickerProviderStateMixin {
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
          : Container()
          // ListView.builder(
          //     itemCount: _sitters.length,
          //     itemBuilder: (BuildContext ctx, int index) {
          //       return _buildSitterWidget(_sitters[index]);
          //     },
          //   ),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookSitterInfoPage(),
          ),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(sitter.imgUrl),
        ),
        title: Text(sitter.name),
        subtitle: Text(sitter.details),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
