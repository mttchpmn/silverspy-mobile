import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silverspy/providers/auth_provider.dart';
import 'package:silverspy/views/payments_list_page.dart';

import '../components/payment_cost_summaries_component.dart';
import '../models/payment_input_model.dart';
import '../models/payment_response_model.dart';
import '../services/payment_service.dart';

class PaymentsOverviewPage extends StatefulWidget {
  const PaymentsOverviewPage({Key? key}) : super(key: key);

  @override
  _PaymentsOverviewPageState createState() => _PaymentsOverviewPageState();
}

class _PaymentsOverviewPageState extends State<PaymentsOverviewPage> {
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
          title: Text('Payments Overview'),
        ),
        body: FutureBuilder<PaymentData>(
            future: paymentData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        PaymentCostSummaries(data: data),
                        Divider(),
                        Text(
                          'Category Summaries',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Column(
                          children: _buildCategories(data.categoryTotals),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            minimumSize: const Size.fromHeight(50)
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllPaymentsPage()));
                          },
                          child: Text('View All Payments')),
                    ),
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
    return categoryTotals
        .map((x) => ListTile(
              title: Text(x.category),
              trailing: Text('\$${x.total}'),
            ))
        .toList();
  }
}
