import 'package:flutter/material.dart';

import '../services/payment_service.dart';

class Payment {
  final String id;
  final String description;
  final double amount;
  final String date;

  Payment(
      {required this.id,
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
  final List<Payment> _payments = [
    Payment(id: '1', description: 'Rent', amount: 1000.0, date: '2022-03-01'),
    Payment(id: '2', description: 'Internet', amount: 50.0, date: '2022-03-03'),
    Payment(
        id: '3', description: 'Electricity', amount: 80.0, date: '2022-03-05'),
    Payment(id: '4', description: 'Water', amount: 30.0, date: '2022-03-07'),
  ];

  void _editPayment(int index, Payment payment) {
    setState(() {
      _payments[index] = payment;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var paymentResponse = PaymentsService().getPayments();

    debugPrint("Hello!");
    debugPrint(paymentResponse.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
      ),
      body: ListView.builder(
        itemCount: _payments.length,
        itemBuilder: (context, index) {
          final payment = _payments[index];
          return ListTile(
            title: Text(payment.description),
            subtitle: Text(payment.date),
            trailing: Text('\$${payment.amount}'),
            onTap: () {
              _showPaymentDialog(payment: payment, index: index);
            },
          );
        },
      ),
    );
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
