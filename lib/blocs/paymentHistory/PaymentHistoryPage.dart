import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nanny_mctea_sitters_flutter/common/spinner.dart';
import 'package:nanny_mctea_sitters_flutter/models/stripe/ChargeModel.dart';
import 'package:nanny_mctea_sitters_flutter/services/FormatterService.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

class PaymentHistoryPage extends StatefulWidget {
  @override
  State createState() => PaymentHistoryPageState();
}

class PaymentHistoryPageState extends State<PaymentHistoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int detailsCharLimit = 60;
  final String timeFormat = 'MMM d, yyyy';
  PaymentHistoryBloc paymentHistoryBloc;

  @override
  void initState() {
    super.initState();

    paymentHistoryBloc = BlocProvider.of<PaymentHistoryBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.add),
          //   onPressed: () {
          //     paymentMethodBloc.add(
          //       PaymentMethodBP.NavigateToAddCardEvent(),
          //     );
          //   },
          // )
        ],
      ),
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<PaymentHistoryBloc, PaymentHistoryState>(
        listener: (BuildContext context, PaymentHistoryState state) {
        },
        builder: (BuildContext context, PaymentHistoryState state) {
          if (state is LoadingState) {
            return Spinner();
          } else if (state is LoadedState) {
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.charges.length,
              itemBuilder: (BuildContext ctx, int index) {
                return _buildChargeView(state.charges[index]);
              },
            );
          } else if (state is EmptyChargesState) {
            return Center(
              child: Text(
                'You have no charges.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          } else if (state is ErrorState) {
            return Center(
              child: Text('Error: ${state.error.toString()}'),
            );
          } else {
            return Center(
              child: Text('You should never see this.'),
            );
          }
        },
      ),
    );
  }

  Widget _buildChargeView(ChargeModel charge) {
    final bool descTooBig = charge.description.length > detailsCharLimit;

    return ListTile(
      leading: Icon(
        MdiIcons.check,
        color: Colors.green,
      ),
      title: Text(
          '${locator<FormatterService>().money(amount: charge.amount.toInt())} - ${DateFormat(timeFormat).format(charge.created)}'),
      subtitle: Text(descTooBig
          ? charge.description.substring(0, detailsCharLimit) + '...'
          : charge.description),
    );
  }
}
