import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silverspy/models/payment_model.dart';
import 'package:silverspy/providers/auth_provider.dart';

import '../models/payment_input_model.dart';
import '../forms/add_payment_form.dart';
import '../models/payment_response_model.dart';
import '../services/payment_service.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({Key? key}) : super(key: key);

  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  late String _accessToken;
  late Future<PaymentData> paymentData;
  final PaymentsService _paymentsService = PaymentsService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    paymentData = getPaymentData();
  }

  @override
  void initState() {
    super.initState();

    paymentData = getPaymentData();
  }

  Future<PaymentData> getPaymentData() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return authProvider.getCredentials().then((value) {
      _accessToken = value.accessToken;
      return _paymentsService.getPaymentData(value.accessToken);
    });
  }

  void _handleAddPayment(PaymentInput payment) {
    debugPrint("Received payment");
    debugPrint(payment.toString());

    _paymentsService.addPayment(payment, _accessToken);
    setState(() {
      paymentData = getPaymentData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Payments'),
        ),
        body: FutureBuilder<PaymentData>(
            future: paymentData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!;

                return Column(
                  children: [
                    PaymentTypeSummaryRow(
                      data: data.monthlyIncoming,
                      label: 'Total Monthly Incoming',
                    ),
                    PaymentTypeSummaryRow(
                      data: data.monthlyOutgoing,
                      label: 'Total Monthly Outgoing',
                    ),
                    PaymentTypeSummaryRow(
                      data: data.monthlyNet,
                      label: 'Monthly Net Position',
                    ),
                    Text('All Payments'),
                    PaymentsList(data: data),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => PaymentFormDialog(
                                onFormSubmit: _handleAddPayment));
                        // _addPaymentDialog();
                      },
                      icon: Icon(Icons.add),
                      splashColor: Colors.deepPurple,
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    )
                  ]);
            }));
  }
}

class PaymentsList extends StatelessWidget {
  const PaymentsList({
    super.key,
    required this.data,
  });

  final PaymentData data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: data.payments.length,
        itemBuilder: (context, index) {
          final payment = data.payments[index];
          return ListTile(
            title: Text(payment.name),
            subtitle: Text(payment.details ?? ""),
            trailing: Text('\$${payment.value}'),
            onTap: () {},
          );
        },
      ),
    );
  }
}

class PaymentTypeSummaryRow extends StatelessWidget {
  const PaymentTypeSummaryRow({
    super.key,
    required this.data,
    required this.label,
  });

  final String label;
  final PaymentTypeSummary data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('\$${data.total}'),
        ],
      ),
    );
  }
}
