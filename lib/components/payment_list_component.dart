import 'package:flutter/material.dart';

import '../models/payment_model.dart';
import '../models/payment_response_model.dart';

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
            leading: payment.type == PaymentType.incoming ? Icon(Icons.arrow_circle_up, color: Colors.green,) : Icon(Icons.arrow_circle_down, color: Colors.red,),
            title: Text(payment.name),
            subtitle: Text(payment.category ?? ""),
            trailing: Text('\$${payment.value}'),
            onTap: () {},
          );
        },
      ),
    );
  }
}
