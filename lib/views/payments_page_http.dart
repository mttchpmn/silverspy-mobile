import 'package:flutter/material.dart';

import '../models/payment_response_model.dart';
import '../services/payment_service.dart';

class Payment {
  final String id;
  final String description;
  final double amount;
  final String date;

  Payment({required this.id,
    required this.description,
    required this.amount,
    required this.date});
}

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({Key? key}) : super(key: key);

  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  late Future<PaymentData> paymentData;

  void _editPayment(int index, Payment payment) {
    // setState(() {
    //   _payments[index] = payment;
    // });
  }

  @override
  void initState() {
    super.initState();

    paymentData = PaymentsService().getPaymentData();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('Total Monthly Incoming'),
                  Text('\$${data.monthlyIncoming.total}'),
                ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('Total Monthly Outgoing'),
                  Text('\$${data.monthlyOutgoing.total}'),
                ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('Net Monthly Position'),
                  Text('\$${data.monthlyNet.total}'),
                ],),
                Text('All Payments'),
                Expanded(
                  child: ListView.builder(
                        itemCount: data.payments.length,
                        itemBuilder: (context, index) {
                          final payment = data.payments[index];
                          return ListTile(
                            title: Text(payment.name),
                            subtitle: Text(payment.details ?? ""),
                            trailing: Text('\$${payment.value}'),
                            onTap: () {
                              // _showPaymentDialog(payment: payment, index: index);
                            },
                          );
                        },

                  ),
                )
              ],
            );

          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end,  children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator()],)]);
        }
    ));
  }

  void _showPaymentDialog({required Payment payment, required int index}) {
    final TextEditingController descriptionController =
    TextEditingController(text: payment.description);
    final TextEditingController amountController =
    TextEditingController(text: payment.amount.toString());
    final TextEditingController dateController =
    TextEditingController(text: payment.date);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newPayment = Payment(
                  id: payment.id,
                  description: descriptionController.text,
                  amount: double.tryParse(amountController.text) ?? 0.0,
                  date: dateController.text,
                );
                _editPayment(index, newPayment);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
