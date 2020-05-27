// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:nanny_mctea_sitters_flutter/asset_images.dart';
// import 'package:nanny_mctea_sitters_flutter/common/scaffold_clipper.dart';
// import 'package:nanny_mctea_sitters_flutter/common/simple_navbar.dart';
// import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
// import 'package:nanny_mctea_sitters_flutter/models/stripe/CustomerModel.dart';
// import 'package:nanny_mctea_sitters_flutter/models/stripe/customer.dart';
// import 'package:nanny_mctea_sitters_flutter/services/modal.dart';
// import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeCustomerService.dart';
// import 'package:nanny_mctea_sitters_flutter/services/stripe/StripeTokenService.dart';
// import 'package:nanny_mctea_sitters_flutter/services/stripe/customer.dart';
// import 'package:nanny_mctea_sitters_flutter/services/stripe/token.dart';
// import 'package:nanny_mctea_sitters_flutter/services/validator.dart';

// class AddCreditCardPage extends StatefulWidget {
//   AddCreditCardPage({@required this.customer});
//   final Customer customer;
//   @override
//   State createState() => AddCreditCardPageState(this.customer);
// }

// class AddCreditCardPageState extends State<AddCreditCardPage> {
//   AddCreditCardPageState(this._customer);
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   bool _autoValidate = false;
//   final TextEditingController _cardNumberController = TextEditingController();
//   final TextEditingController _expirationController = TextEditingController();
//   final TextEditingController _cvcController = TextEditingController();
//   final CustomerModel _customer;
//   final GetIt getIt = GetIt.I;

//   @override
//   void initState() {
//     super.initState();
//   }

//   void _addTestCardInfo() {
//     _cardNumberController.text = '4242424242424242';
//     _expirationController.text = '0621';
//     _cvcController.text = '323';
//     _autoValidate = true;
//   }

//   void _clearForm() {
//     _cardNumberController.clear();
//     _expirationController.clear();
//     _cvcController.clear();
//   }

//   void _submitCard() async {
//     final FormState form = _formKey.currentState;
//     if (!form.validate()) {
//       _autoValidate = true;
//     } else {
//       bool confirm = await getIt<Modal>().showConfirmation(
//           context: context,
//           title: 'Add Card',
//           text: 'This will become your default card on file. Proceed?');
//       if (confirm) {
//         setState(
//           () {
//             _isLoading = true;
//           },
//         );

//         String number = _cardNumberController.text;
//         String exp_month = _expirationController.text.substring(0, 2);
//         String exp_year = _expirationController.text.substring(2, 4);
//         String cvc = _cvcController.text;

//         try {
//           String token = await getIt<StripeTokenService>().create(
//               number: number,
//               exp_month: exp_month,
//               exp_year: exp_year,
//               cvc: cvc);

//           await getIt<StripeCustomerService>()
//               .update(customerID: _customer.id, token: token);

//           print(token);

//           setState(
//             () {
//               _isLoading = false;
//             },
//           );
//           getIt<Modal>().showInSnackBar(
//               scaffoldKey: _scaffoldKey, text: 'Card added successfully.');
//         } catch (e) {
//           setState(
//             () {
//               _isLoading = false;
//             },
//           );
//           getIt<Modal>().showAlert(
//               context: context,
//               title: 'Error',
//               message: 'Could not save card at this time.');
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         body: _isLoading
//             ? Spinner()
//             : SingleChildScrollView(
//                 child: Form(
//                   key: _formKey,
//                   autovalidate: _autoValidate,
//                   child: Column(
//                     children: <Widget>[
//                       ScaffoldClipper(
//                         simpleNavbar: SimpleNavbar(
//                           leftWidget:
//                               Icon(MdiIcons.chevronLeft, color: Colors.white),
//                           leftTap: () {
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                         title: 'Add Credit Card',
//                         subtitle: 'Just need some quick info.',
//                       ),
//                       Container(
//                         child: creditCard2,
//                         height: 250.0,
//                       ),
//                       //Card Number
//                       Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Card(
//                           elevation: 3,
//                           child: Padding(
//                             padding: EdgeInsets.all(20),
//                             child: TextFormField(
//                               controller: _cardNumberController,
//                               keyboardType: TextInputType.number,
//                               textInputAction: TextInputAction.next,
//                               obscureText: false,
//                               onFieldSubmitted: (term) {},
//                               validator: getIt<Validator>().cardNumber,
//                               onSaved: (value) {},
//                               decoration: InputDecoration(
//                                 hintText: 'Card Number',
//                                 icon: Icon(Icons.credit_card,
//                                     color: Theme.of(context)
//                                         .primaryIconTheme
//                                         .color),
//                                 fillColor: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       //Expiration
//                       Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Card(
//                           elevation: 3,
//                           child: Padding(
//                             padding: EdgeInsets.all(20),
//                             child: TextFormField(
//                               controller: _expirationController,
//                               keyboardType: TextInputType.number,
//                               textInputAction: TextInputAction.next,
//                               obscureText: false,
//                               onFieldSubmitted: (term) {},
//                               validator: getIt<Validator>().cardExpiration,
//                               onSaved: (value) {},
//                               decoration: InputDecoration(
//                                 hintText: 'Expiration',
//                                 icon: Icon(Icons.date_range,
//                                     color: Theme.of(context)
//                                         .primaryIconTheme
//                                         .color),
//                                 fillColor: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       //CVC
//                       Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Card(
//                           elevation: 3,
//                           child: Padding(
//                             padding: EdgeInsets.all(20),
//                             child: TextFormField(
//                               controller: _cvcController,
//                               keyboardType: TextInputType.number,
//                               textInputAction: TextInputAction.next,
//                               obscureText: false,
//                               onFieldSubmitted: (term) {},
//                               validator: getIt<Validator>().cardCVC,
//                               onSaved: (value) {},
//                               decoration: InputDecoration(
//                                 hintText: 'CVC',
//                                 icon: Icon(Icons.security,
//                                     color: Theme.of(context)
//                                         .primaryIconTheme
//                                         .color),
//                                 fillColor: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(20),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: <Widget>[
//                             RaisedButton(
//                               color: Theme.of(context).buttonColor,
//                               child: Text('Add Automatic',
//                                   style:
//                                       Theme.of(context).accentTextTheme.button),
//                               onPressed: () {
//                                 _addTestCardInfo();
//                               },
//                             ),
//                             RaisedButton(
//                               color: Theme.of(context).buttonColor,
//                               child: Text('Add Card',
//                                   style:
//                                       Theme.of(context).accentTextTheme.button),
//                               onPressed: () {
//                                 _submitCard();
//                               },
//                             ),
//                             RaisedButton(
//                               color: Theme.of(context).buttonColor,
//                               child: Text('Clear',
//                                   style:
//                                       Theme.of(context).accentTextTheme.button),
//                               onPressed: () {
//                                 _clearForm();
//                               },
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ));
//   }
// }
