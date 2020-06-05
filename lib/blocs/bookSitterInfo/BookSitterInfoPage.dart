import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/pages/profile/profile.dart';
import 'package:nanny_mctea_sitters_flutter/services/ValidatorService.dart';
import '../../ServiceLocator.dart';
import '../../blocs/bookSitterInfo/Bloc.dart' as BookSitterInfoBP;
import '../../blocs/bookSitterPayment/Bloc.dart' as BookSitterPaymentBP;

class BookSitterInfoPage extends StatefulWidget {
  @override
  State createState() => BookSitterInfoPageState();
}

class BookSitterInfoPageState extends State<BookSitterInfoPage> {
  BookSitterInfoPageState();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _dateFormat = 'MMMM dd, yyyy';
  final String _timeFormat = '@ hh:mm a';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _aptFloorController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  BookSitterInfoBP.BookSitterInfoBloc bookSitterInfoBloc;

  @override
  void initState() {
    bookSitterInfoBloc =
        BlocProvider.of<BookSitterInfoBP.BookSitterInfoBloc>(context);
    super.initState();
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
          'Book Sitter - Payment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<BookSitterInfoBP.BookSitterInfoBloc,
          BookSitterInfoBP.BookSitterInfoState>(
        listener:
            (BuildContext context, BookSitterInfoBP.BookSitterInfoState state) {
          if (state is BookSitterInfoBP.NavigateToPaymentPageState) {
            Route route = MaterialPageRoute(
              builder: (BuildContext context) => BlocProvider(
                create: (BuildContext context) =>
                    BookSitterPaymentBP.BookSitterPaymentBloc(),
                child: BookSitterPaymentBP.BookSitterPaymentPage(),
              ),
            );
            Navigator.push(context, route);
          }
        },
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
                          BookSitterInfoBP.ValidateFormEvent(
                              formKey: state.formKey),
                        );
                      },
                    )
                  ],
                ),
              ),
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
