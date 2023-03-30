import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/payment_model.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({Key? key}) : super(key: key);

  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  late List<Payment> _payments;

  Future<List<Payment>> _fetchPayments() async {
    final response = await http.get(Uri.parse('https://example.com/api/payments'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      return jsonData.map((json) => Payment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load payments');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPayments().then((payments) {
      setState(() {
        _payments = payments;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
      ),
      body: _payments == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _payments.length,
        itemBuilder: (context, index) {
          final payment = _payments[index];
          return ListTile(
            title: Text(payment.description),
            subtitle: Text(payment.date),
            trailing: Text('\$${payment.value}'),
          );
        },
      ),
    );
  }
}
