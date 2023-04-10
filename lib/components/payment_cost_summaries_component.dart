import 'package:flutter/material.dart';

import '../models/payment_response_model.dart';

class PaymentCostSummaries extends StatelessWidget {
  const PaymentCostSummaries({
    super.key,
    required this.data,
  });

  final PaymentData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Text('Cost Summaries', style: Theme.of(context).textTheme.labelLarge,),
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
        ],
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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8,),
                child: _getIcon(label),
              ),
              Text(label),
            ],
          ),
          Text('\$${data.total}'),
        ],
      ),
    );
  }

  Icon _getIcon(String label) {
    if (label == "Total Monthly Incoming")
      return Icon(Icons.arrow_circle_up, color: Colors.green,);

    if (label == "Total Monthly Outgoing")
      return Icon(Icons.arrow_circle_down, color: Colors.red,);

    return Icon(Icons.show_chart, color: Colors.purple,);
  }
}
