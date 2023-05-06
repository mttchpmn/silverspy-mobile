import 'package:flutter/material.dart';
import 'package:silverspy/helpers/icon_helper.dart';

import '../models/transaction_response_model.dart';

class CategoryTotalList extends StatelessWidget {
  final List<TransactionCategorySummary> categoryTotals;
  final ValueChanged<String> onTapCallback;

  const CategoryTotalList(
      {super.key, required this.categoryTotals, required this.onTapCallback});

  @override
  Widget build(BuildContext context) {
    var sortedTotals = _sortList(categoryTotals);

    return Expanded(
      child: ListView.builder(
        itemCount: sortedTotals.length,
        itemBuilder: (context, index) {
          var ct = sortedTotals[index];

          return CategoryTotalRow(
            name: ct.category,
            total: ct.currentSpend,
            target: ct.budget,
            onTapCallback: onTapCallback,
          );
        },
      ),
    );
  }

  List<TransactionCategorySummary> _sortList(
      List<TransactionCategorySummary> categoryTotals) {
    var budgets = List.of(categoryTotals);
    var nonBudgets = List.of(categoryTotals);

    budgets.retainWhere((element) => element.budget > 0);
    budgets.sort((a, b) => a.currentSpend.compareTo(b.currentSpend));

    nonBudgets.retainWhere((element) => element.budget == 0);
    nonBudgets.sort((a, b) => a.currentSpend.compareTo(b.currentSpend));

    return budgets + nonBudgets;
  }
}

class CategoryTotalRow extends StatelessWidget {
  final String name;
  final double total;
  final double target;
  final ValueChanged<String> onTapCallback;

  CategoryTotalRow(
      {required this.name,
      required this.total,
      required this.target,
      required this.onTapCallback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconHelper.getIconForCategory(name),
      title: Text(name),
      subtitle: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('\$${total.abs().toStringAsFixed(2)}'),
            ],
          ),
          if (target > 0)
            (SpendProgress(
              target: target,
              currentSpend: total,
            ))
        ],
      ),
      onTap: () {
        onTapCallback(name);
      },
    );
  }
}

class SpendProgress extends StatelessWidget {
  const SpendProgress({
    super.key,
    required this.currentSpend,
    required this.target,
  });

  final double currentSpend;
  final double target;

  @override
  Widget build(BuildContext context) {
    var value = (currentSpend / target).abs();
    var color = value > 1 ? Colors.red : Colors.purple;

    return Row(
      children: [
        Expanded(
            child: LinearProgressIndicator(
          value: value,
          // backgroundColor: Colors.grey,
          color: color,
        )),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("\$$target"),
        ),
      ],
    );
  }
}
