import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silverspy/providers/auth_provider.dart';

import '../components/payment_list_component.dart';
import '../models/payment_input_model.dart';
import '../forms/add_payment_form.dart';
import '../models/payment_response_model.dart';
import '../services/payment_service.dart';

class AllPaymentsPage extends StatefulWidget {
  const AllPaymentsPage({Key? key}) : super(key: key);

  @override
  _AllPaymentsPageState createState() => _AllPaymentsPageState();
}

class _AllPaymentsPageState extends State<AllPaymentsPage> {
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
          title: Text('All Payments'),
        ),
        body: FutureBuilder<PaymentData>(
            future: paymentData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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

  List<ListTile> _buildCategories(List<PaymentCategoryTotal> categoryTotals) {
    return categoryTotals.map((x) => ListTile(
      title: Text(x.category),
      trailing: Text('\$${x.total}'),
    )).toList();
  }
}

