import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nanny_mctea_sitters_flutter/common/job_posting_widget.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/database/job_posting.dart';

class JoinTeamPage extends StatefulWidget {
  @override
  State createState() => JoinTeamPageState();
}

class JoinTeamPageState extends State<JoinTeamPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  final _db = Firestore.instance;
  List<JobPosting> jobPostings = List<JobPosting>();

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    QuerySnapshot querySnapshot =
        await _db.collection('JobPostings').getDocuments();
    List<DocumentSnapshot> documentSnapshots = querySnapshot.documents;
    documentSnapshots.forEach(
      (documentSnapshot) {
        JobPosting jobPosting = JobPosting();
        jobPosting.description = documentSnapshot.data['description'];
        jobPosting.imgUrl = documentSnapshot.data['imgUrl'];
        jobPosting.posted = documentSnapshot.data['posted'].toDate();
        jobPosting.url = documentSnapshot.data['url'];
        jobPosting.title = documentSnapshot.data['title'];

        jobPostings.add(jobPosting);
      },
    );

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Spinner() : DefaultTabController(
      length: jobPostings.length,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(),
        body: TabBarView(
          children: [
            for (var i = 0; i < jobPostings.length; i++)
              JobPostingWidget(
                imgUrl: jobPostings[i].imgUrl,
                title: jobPostings[i].title,
                posted: jobPostings[i].posted,
                description: jobPostings[i].description,
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
          for (var i = 0; i < jobPostings.length; i++)
            Tab(
              child: Text(
                'Full Time',
                textAlign: TextAlign.center,
              ),
            ),
          // Tab(
          //   child: Text(
          //     'Part Time',
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          // Tab(
          //   child: Text(
          //     'Temporary Part Time',
          //     textAlign: TextAlign.center,
          //   ),
          // ),
        ],
      ),
      title: Text('JOIN THE TEAM'),
      centerTitle: true,
    );
  }
}
