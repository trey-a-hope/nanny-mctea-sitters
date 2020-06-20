import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/services/ValidatorService.dart';
import '../../ServiceLocator.dart';
import '../../blocs/bookSitterInfo/Bloc.dart' as BookSitterInfoBP;
import '../../blocs/bookSitterPayment/Bloc.dart' as BOOK_SITTER_PAYMENT_BP;

class BookSitterInfoPage extends StatefulWidget {
  @override
  State createState() => BookSitterInfoPageState();
}

class BookSitterInfoPageState extends State<BookSitterInfoPage>
    implements BookSitterInfoBP.BookSitterInfoBlocDelegate {
  BookSitterInfoPageState();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _dateFormat = 'MMMM dd, yyyy';
  final String _timeFormat = '@ hh:mm a';

  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _phoneController;
  TextEditingController _streetController;
  TextEditingController _aptFloorController;
  TextEditingController _cityController;

  BookSitterInfoBP.BookSitterInfoBloc bookSitterInfoBloc;

  @override
  void initState() {
    //Assign bloc instance and set delegate.
    bookSitterInfoBloc =
        BlocProvider.of<BookSitterInfoBP.BookSitterInfoBloc>(context);
    bookSitterInfoBloc.setDelegate(delegate: this);
    super.initState();

    // _nameController = TextEditingController(text: 'Trey Hope');
    // _emailController = TextEditingController(text: 'trey.a.hope@gmail.com');
    // _phoneController = TextEditingController(text: '9372705527');
    // _streetController = TextEditingController(text: '5 Patrick Street');
    // _aptFloorController = TextEditingController(text: '1');
    // _cityController = TextEditingController(text: 'Trotwood');
  }

  @override
  void dispose() {
    bookSitterInfoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Sitter - Info',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<BookSitterInfoBP.BookSitterInfoBloc,
          BookSitterInfoBP.BookSitterInfoState>(
        builder:
            (BuildContext context, BookSitterInfoBP.BookSitterInfoState state) {
          if (state is BookSitterInfoBP.LoadedState) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: state.formKey,
                autovalidate: state.autoValidate,
                child: ListView(
                  children: <Widget>[
                    Text(
                      DateFormat(_dateFormat).format(state.selectedDate),
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      DateFormat(_timeFormat).format(state.selectedDate),
                      style: TextStyle(fontSize: 18),
                    ),

                    SizedBox(
                      height: 40,
                    ),
                    //Name input field.
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      maxLengthEnforced: true,
                      // maxLength: MyFormData.nameCharLimit,
                      onFieldSubmitted: (term) {},
                      validator: locator<ValidatorService>().isEmpty,
                      onSaved: (value) {},
                      decoration: InputDecoration(
                        hintText: 'Name',
                        icon: Icon(Icons.face, color: Colors.black),
                        fillColor: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      maxLengthEnforced: true,
                      // maxLength: MyFormData.nameCharLimit,
                      onFieldSubmitted: (term) {},
                      validator: locator<ValidatorService>().email,
                      onSaved: (value) {},
                      decoration: InputDecoration(
                        hintText: 'Email',
                        icon: Icon(Icons.email, color: Colors.black),
                        fillColor: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //Phone Number
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      maxLengthEnforced: true,
                      // maxLength: MyFormData.nameCharLimit,
                      onFieldSubmitted: (term) {},
                      validator: locator<ValidatorService>().mobile,
                      onSaved: (value) {},
                      decoration: InputDecoration(
                        hintText: 'Phone',
                        icon: Icon(Icons.phone, color: Colors.black),
                        fillColor: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //Street Address
                    TextFormField(
                      controller: _streetController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      maxLengthEnforced: true,
                      // maxLength: MyFormData.nameCharLimit,
                      onFieldSubmitted: (term) {},
                      validator: locator<ValidatorService>().isEmpty,
                      onSaved: (value) {},
                      decoration: InputDecoration(
                        hintText: 'Street',
                        icon: Icon(Icons.location_on, color: Colors.black),
                        fillColor: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //Apt. / Floor No.
                    TextFormField(
                      controller: _aptFloorController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      maxLengthEnforced: true,
                      // maxLength: MyFormData.nameCharLimit,
                      onFieldSubmitted: (term) {},
                      // validator: Validater.isEmpty,
                      onSaved: (value) {},
                      decoration: InputDecoration(
                        hintText: 'Apt. / Floor No.',
                        icon: Icon(MdiIcons.locationEnter, color: Colors.black),
                        fillColor: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //City
                    TextFormField(
                      controller: _cityController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      maxLengthEnforced: true,
                      // maxLength: MyFormData.nameCharLimit,
                      onFieldSubmitted: (term) {},
                      validator: locator<ValidatorService>().isEmpty,
                      onSaved: (value) {},
                      decoration: InputDecoration(
                        hintText: 'City',
                        icon: Icon(Icons.location_city, color: Colors.black),
                        fillColor: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    RaisedButton(
                      child: Text(
                        'Proceed to Payment?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () {
                        bookSitterInfoBloc.add(
                          BookSitterInfoBP.NavigateToPaymentPageEvent(
                            formKey: state.formKey,
                            name: _nameController.text,
                            email: _emailController.text,
                            street: _streetController.text,
                            aptNo: _aptFloorController.text,
                            city: _cityController.text,
                            phoneNumber: _phoneController.text,
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  @override
  void navigateToPaymentPage({
    DateTime selectedDate,
    String service,
    int hours,
    double cost,
    String aptNo,
    String street,
    String city,
    String name,
    String email,
    String phoneNumber,
    String resourceID,
  }) {
    Route route = MaterialPageRoute(
      builder: (BuildContext context) => BlocProvider(
        create: (BuildContext context) =>
            BOOK_SITTER_PAYMENT_BP.BookSitterPaymentBloc(
          selectedDate: selectedDate,
          service: service,
          hours: hours,
          cost: cost,
          aptNo: aptNo,
          street: street,
          city: city,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          resourceID: resourceID,
        ),
        child: BOOK_SITTER_PAYMENT_BP.BookSitterPaymentPage(),
      ),
    );
    Navigator.push(context, route);
  }
}
