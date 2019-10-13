import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/services/url_launcher.dart';

class ProfessionalNanniesPage extends StatefulWidget {
  @override
  State createState() => ProfessionalNanniesPageState();
}

class ProfessionalNanniesPageState extends State<ProfessionalNanniesPage> {
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
                    ),
                    title: 'Professional Nannies',
                    subtitle: '',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: asImgGroup_nannies,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'With many years of experience, our professional consultants have you covered. Our Consultant began in the nanny world themselves. We have learned the in\'s and out\'s of selecting a quality caregiver and are happy to share this with you.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Nanny McTea Sitters Consultants handles the entire screening process for you. With our 5 step interview process we fully vet applicants to send your family qualified candidates.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'We work closely with your family to draft your work agreement and set your nanny/employer relationship for success.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Our total placement cost \$1,475 split into a non refundable deposit of \$350 this allows us to post your application and begin screening candidates on your behalf. If you select a nanny that our team has vetted for you, the remainder balance of \$1,125 is due upon signing the work agreement.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'We receive anywhere from 15 to 30 applicants per job posting depending on hours, location, pay and number of children etc. With our 5 step interview process we are spending roughly 5 or more hours with each candidate to determine their eligibility with your family.  The final nanny placement of \$1,125 is only paid if your family selects a nanny that we bring to you and is based on the amount of hours we spend reviewing candidates. 15 candidate x 5 hours = 75 hours, 75 hours x \$15/hr = \$1,125.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Text(
                          '​For more information fill out our family application and a Nanny McTea Sitter consultant will be in touch.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20)
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        onPressed: () {
          URLLauncher.launchUrl(
              'https://docs.google.com/forms/d/e/1FAIpQLSc1BoEVUcebGSTZaGRMvMfebVC-G7YX2EVBhxPs8niHv4HYkA/viewform');
        },
        color: Theme.of(context).buttonColor,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                MdiIcons.face,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                'FAMILY APPLICATION',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
